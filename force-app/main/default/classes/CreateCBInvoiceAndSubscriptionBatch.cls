/**
* @author: Solved by Software, Co
*/
public with sharing class CreateCBInvoiceAndSubscriptionBatch implements Database.Batchable<SObject> {
    private String oppId;
    public String CBSettingId;
    public Boolean hasInvoiceCreated;
    public Boolean hasSubscriptionCreated;

    public Opportunity opp;
    public Organization orgEnv;
    public CB_Hierarchy_Created__e CBHierarchyRecord;

    public List<Opportunity_Location__c> locationAccounts;
    public Set<Id> filteredAccountIdSet;

    public CreateCBInvoiceAndSubscriptionBatch (String oppId, CB_Hierarchy_Created__e record) {
        this.oppId = oppId;
        this.CBHierarchyRecord = record;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('CreateCBInvoiceAndSubscriptionBatch | START.: ');
        return Database.getQueryLocator('SELECT Id, CB_First_Invoice_Created__c, StageName, AccountId FROM Opportunity WHERE Id =:oppId');
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        System.debug('CreateCBInvoiceAndSubscriptionBatch | EXECUTE.: ' + scope);
        if(scope != null && scope.size() > 0) {
            try {
                this.opp = scope[0];
                this.CBSettingId = isSandbox() ? getChargebeeIdSettingMDT('Sandbox') : getChargebeeIdSettingMDT('Production');
                this.filteredAccountIdSet = getFilteredAccountIdsFromLocation(this.oppId);
                Boolean isCBInvoiceCreation      = this.CBHierarchyRecord.Type__c =='Invoice' && getAllCharges(this.oppId) != null;
                Boolean isCBSubscriptionCreation = this.CBHierarchyRecord.Type__c =='Subscription' && getAllPlansAndAddons(this.oppId) != null;

                System.debug('CreateCBInvoiceAndSubscriptionBatch | this.opp.: ' + this.opp);
                System.debug('CreateCBInvoiceAndSubscriptionBatch | this.CBHierarchyRecord.Type__c.: ' + this.CBHierarchyRecord.Type__c);
                System.debug('CreateCBInvoiceAndSubscriptionBatch | this.CBSettingId.: ' + this.CBSettingId);
                System.debug('CreateCBInvoiceAndSubscriptionBatch | this.filteredAccountIdSet.: ' + this.filteredAccountIdSet);
                System.debug('CreateCBInvoiceAndSubscriptionBatch | isInvoiceCBCreation.: ' + isCBInvoiceCreation);
                System.debug('CreateCBInvoiceAndSubscriptionBatch | isSubscriptionCBCreation.: ' + isCBSubscriptionCreation);
                
                //CREATE CB INVOICE   
                if(isCBInvoiceCreation) {
                    List<Opportunity> oppToUpdate = new List<Opportunity>();
                    for(Account account : [SELECT Id, ParentId FROM Account WHERE Id IN:filteredAccountIdSet
                    ]) {
                        List<Asset> accountInvoiceItems = new List<Asset>();
                        for(Asset charge : getAllCharges(this.oppId)) {
                            if(charge.AccountId == account.Id) {
                                accountInvoiceItems.add(charge);
                            }
                        }
    
                        if(accountInvoiceItems != null && accountInvoiceItems.size() > 0) {
                            createChargebeeInvoice(accountInvoiceItems, CBSettingId, account.Id, this.oppId, account.ParentId);
                        }
                    }
    
                    updateOppStage(this.opp);
                    createLog(false, 'Create CB Invoice', 'Chargebee Invoice Invocable. Opportunity.: ' + this.opp.Id);
                }
                //CREATE CB SUBSCRIPTION   
                if(isCBSubscriptionCreation) {
                
                    for(Account account : [SELECT Id, ParentId FROM Account WHERE Id IN:filteredAccountIdSet
                    ]) {
                        List<Asset> accountAddonItems = new List<Asset>();
                        for(Asset charge : getAllPlansAndAddons(this.oppId)) {
                            if(charge.AccountId == account.Id) {
                                accountAddonItems.add(charge);
                            }
                        }
    
                        if(accountAddonItems != null && accountAddonItems.size() > 0) {
                            createChargebeeSubscription(
                                new List<Id>(filteredAccountIdSet), 
                                this.CBHierarchyRecord.Subscription_Action__c, 
                                accountAddonItems, 
                                CBSettingId, 
                                account.Id, 
                                this.oppId, 
                                account.ParentId
                            );
                        }
                    }
                    createLog(false, 'Create CB Subscription', 'Chargebee Subscription Invocable. Opportunity.: ' + this.opp.Id);
                }
            } catch (Exception e) {
                System.debug('ERROR.:' + e.getMessage());
                createLog(true, 'Create CB Invoice And Subscription Batch', 'Opportunity.: ' + this.opp.Id);
            }
        }
    }

    public void finish(Database.BatchableContext BC){}
    
    private Opportunity getOpportunity(String oppId) {
        return [SELECT Id, CB_First_Invoice_Created__c, StageName, AccountId FROM Opportunity WHERE Id = :oppId LIMIT 1];
    }
    
    private Boolean isSandbox() {
        return [SELECT Id, IsSandbox FROM Organization LIMIT 1]?.IsSandbox;
    }

    private String getChargebeeIdSettingMDT(String envType) {
        return [SELECT Id FROM Chargebee_Setting__mdt WHERE Label = :envType LIMIT 1]?.Id;
    }

    private List<Asset> getAllCharges(String oppId) {
        return [SELECT AccountId, Product2Id, ProductCode, Name, Status,
                        Price, Quantity, Opportunity_Product__c, Paid_by_Parent__c,
                        Account_Name__c, Account_Ownership_Type__c, Bill_To_Account_Type__c,
                        Opportunity__c, Account_Grouped_Product_Code__c,
                        Account_Grouped_Product_Code_Key__c, Store_Location_Type__c, Account_Paid_by_Parent__c,
                        CB_Add_On_Event__c, CB_Contract_Term_Months__c, CB_External_Id__c,
                        CB_Net_Unit_Price__c, CB_Product_Type__c, CB_Service_Period__c,
                        CB_Subscription_Start_Date__c, Account_Location_Index__c, Net_Unit_Price__c,
                        Expired_On__c, Pricebook_Entry__c, Expired__c, Net_Unit_Price_Text__c,
                        Originating_Asset__c, Original_Price_Text__c
                  FROM Asset 
                 WHERE Opportunity__c = :oppId 
                   AND CB_Product_Type__c = 'CHARGE' 
                   AND Net_Unit_Price__c != 0.0
            ];
    }

    private List<Asset> getAllPlansAndAddons(String oppId) {
        return [SELECT AccountId, Product2Id, ProductCode, Name, Status,
                        Price, Quantity, Opportunity_Product__c, Paid_by_Parent__c,
                        Account_Name__c, Account_Ownership_Type__c, Bill_To_Account_Type__c,
                        Opportunity__c, Account_Grouped_Product_Code__c,
                        Account_Grouped_Product_Code_Key__c, Store_Location_Type__c, Account_Paid_by_Parent__c,
                        CB_Add_On_Event__c, CB_Contract_Term_Months__c, CB_External_Id__c,
                        CB_Net_Unit_Price__c, CB_Product_Type__c, CB_Service_Period__c,
                        CB_Subscription_Start_Date__c, Account_Location_Index__c, Net_Unit_Price__c,
                        Expired_On__c, Pricebook_Entry__c, Expired__c, Net_Unit_Price_Text__c,
                        Originating_Asset__c, Original_Price_Text__c
                  FROM Asset 
                 WHERE Opportunity__c =:oppId 
                   AND (CB_Product_Type__c = 'ADDON' OR CB_Product_Type__c = 'PLAN') 
                   AND Expired__c = false
        ];
    }

    private Set<Id> getFilteredAccountIdsFromLocation(String oppId) {
        Set<Id> accountIdSet         = new Set<Id>();
        Set<Id> filteredAccountIdSet = new Set<Id>();
        for(Opportunity_Location__c location : [
                SELECT Id, Location_Account__c FROM Opportunity_Location__c WHERE Opportunity__c = :oppId
        ]) {
            accountIdSet.add(location.Location_Account__c);
        }
        accountIdSet.add(this.opp.AccountId);
        
        for(Id accountId: accountIdSet) {
            if(CBHierarchyRecord != null && CBHierarchyRecord.Account_Ids__c.contains(accountId)) {
                filteredAccountIdSet.add(accountId);
            }
        }

        return filteredAccountIdSet;
    }
    
    private void createLog(Boolean hasError, String description, String interaction) {
        insert new Log__c(
            Description__c  = description,
            Error__c        = false,
            Interaction__c  = interaction
        );
    }
    
    private void createChargebeeInvoice(List<Asset> assets, String cbId, String accountId, String oppId, String parentId) {
        ChargebeeInvocableRequest request = new ChargebeeInvocableRequest();
        request.assets         = assets;
        request.cbId           = cbId;
        request.childId        = accountId;
        request.oppId          = oppId;
        request.parentId       = parentId;
        this.hasInvoiceCreated = true;

        ChargebeeInvoiceInvocable.CreateInvoice(new List<ChargebeeInvocableRequest>{request});

    }

    private void createChargebeeSubscription(List<Id> accountIds, String action, List<Asset> assets, String cbId, String accountId, String oppId, String parentId) {
        ChargebeeInvocableRequest request = new ChargebeeInvocableRequest();
        request.accountIds          = accountIds;
        request.action              = action;
        request.assets              = assets;
        request.cbId                = cbId;
        request.childId             = accountId;
        request.oppId               = oppId;
        request.parentId            = parentId;
        this.hasSubscriptionCreated = true;

        ChargebeeSubscriptionInvocable.CreateSubscription(new List<ChargebeeInvocableRequest>{request});

    }
    
    private void updateOppStage(Opportunity opp) {
        opp.CB_First_Invoice_Created__c = true;
        opp.StageName = hasInvoiceCreated ? 'Invoice/Auth Form Sent' : 'Roll-Out (In-Progress)';

        update opp;
    }
}