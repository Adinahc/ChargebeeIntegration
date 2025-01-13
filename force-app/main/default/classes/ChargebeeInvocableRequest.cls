/**
* @author: Solved by Software, Co
*/

global class ChargebeeInvocableRequest {
    @InvocableVariable
    global String flowName;

    @InvocableVariable
    global Id parentId;
    
    @InvocableVariable
    global Id childId;

    @InvocableVariable
    global Id oppId;

    @InvocableVariable
    global Id accountId;

    @InvocableVariable
    global String cbSubscriptionId;

    @InvocableVariable
    global string action;

    @InvocableVariable
    global List<OpportunityLineItem> items;

    @InvocableVariable
    global List<Id> accountIds;

    @InvocableVariable
    global List<Account> accountList;

    @InvocableVariable
    global List<Log__c> logs;

    @InvocableVariable
    global String cbId;

    @InvocableVariable
    global CB_Item__c cbItem;

    @InvocableVariable
    global List<Asset> assets;

    @InvocableVariable
    global Account acctObj;

    @InvocableVariable
    global Account parentAcct;

    @InvocableVariable
    global String cbCustomId;

    @InvocableVariable
    global String opporutnityType;

    @InvocableVariable
    global List<String> itemIds;

    @InvocableVariable
    global List<AccountContactRelation> billingContacts;

    @InvocableVariable
    global String EventId;

    @InvocableVariable
    global List<chargebeeapps__CB_Subscription__c> cbSubs;
}