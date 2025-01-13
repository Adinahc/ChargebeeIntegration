/**
* @author: Solved by Software, Co
*/

@IsTest
public with sharing class CreateOpportunityLineItemsFromAssetsTest {
    

    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test',
            chargebeeapps__CB_Id__c = 'Test',
            Type = 'Customer'
        );
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity', 
            StageName = 'Prospect', 
            CloseDate = Date.today()
        );
        insert opp;

        Product2 product = new Product2(
            Name='Test Product 1',
            IsActive=true, 
            ProductCode='TESTPROD1',
            StockKeepingUnit='TEST001',
            chargebeeapps__Product_Type__c='PLAN'
        );

        insert product;

        PricebookEntry priceBookEntry = new PricebookEntry(
            Pricebook2Id=Test.getStandardPricebookId(), 
            Product2Id=product.Id, 
            UnitPrice =10, 
            IsActive=true
        );
        insert priceBookEntry;

        Asset asset = new Asset(
            Opportunity__c = opp.Id, 
            AccountId = acc.Id, 
            Name = 'Asset A',
            Product2Id = product.Id,
            Pricebook_Entry__c = priceBookEntry.Id,
            Price = priceBookEntry.UnitPrice,
            Net_Unit_Price_Text__c = '10',
            Original_Price_Text__c = '10'
        );
        insert asset;

        chargebeeapps__CB_Item_Price__c cbItem = new chargebeeapps__CB_Item_Price__c (
            Name = 'Full Platform USD Monthly',
            chargebeeapps__External_Id__c = 'Full-Platform-USD-Monthly',
            chargebeeapps__Free_Quantity__c = 0,
            chargebeeapps__Period_Unit__c = 'MONTH',
            chargebeeapps__Period__c = 1,
            chargebeeapps__Price_Book__c =  Test.getStandardPricebookId(),
            chargebeeapps__Price__c = 50,
            chargebeeapps__Pricing_Model__c = 'PER_UNIT',
            chargebeeapps__Product__c =  product.Id,
            chargebeeapps__Resource_Version__c = 1666282532,
            chargebeeapps__Status__c = 'ACTIVE'
        );
        insert cbItem;

        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId=opp.Id, 
            Quantity=1,
            UnitPrice=10,
            chargebeeapps__CB_Item_Price__c=cbItem.Id, 
            PricebookEntryId = priceBookEntry.Id,
            Original_Price__c = 10
        );
		insert oli;
    }

    @IsTest
    static void createItems_Success_Test(){

        List<Id> accIds = new List<Id>();
        for(Account acc : [SELECT Id FROM Account]){
            accIds.add(acc.Id);
        }

        Id oppId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        List<OpportunityLineItem> olis = [SELECT Id, PricebookEntryId, Product_Name__c, Product2Id, OpportunityId, Original_Price__c, New_Price__c, Product_Code_copy__c, UnitPrice, Temp_Id__c, Quantity FROM OpportunityLineItem LIMIT 1];
        List<Asset> assets = [SELECT Id, Pricebook_Entry__c, ProductCode, Product2Id, Net_Unit_Price_Text__c, Original_Price_Text__c FROM Asset LIMIT 1];

        List<CreateOpportunityLineItemRequest> requests = new List<CreateOpportunityLineItemRequest>();
        CreateOpportunityLineItemRequest request = new CreateOpportunityLineItemRequest();
        request.oppLineItems    = JSON.serialize(olis);
        request.accountIds      = accIds;
        request.opportunityId   = oppId;
        request.tempOppLineItems = new List<OpportunityLineItemRequest>{new OpportunityLineItemRequest(olis[0])};
        request.assets = assets;
        request.initial = false;
        request.uniqueOppLineItems = JSON.serialize(olis);
        request.finalContract = true;

        requests.add(request);
        
        Test.startTest();
            CreateOpportunityLineItemsFromAssets.CreateItems(requests);
            SerializeTempOppLineItems.SerializeTempOpportunityLineItems(requests);
            DeserealizeTempOpportunityLineItems.DeserealizeTempOpportunityLineItems(new List<String> {JSON.serialize(request.tempOppLineItems)});
            DeserealizeTempAssets.DeserealizeTempAssets(new List<String> {JSON.serialize(request.assets)});
            SerializeTempOppLineItems.SerializeTempOpportunityLineItems(requests);
        Test.stopTest();
        
    }


}