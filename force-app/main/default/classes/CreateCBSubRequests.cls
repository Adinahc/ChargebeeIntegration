/**
* @author: Solved by Software, Co
*/

global class CreateCBSubRequests {
    @InvocableVariable
    global Account acct;

    @InvocableVariable
    global Id acctId;

    @InvocableVariable
    global chargebeeapps__CB_Subscription__c cbSub;

    @InvocableVariable
    global String cbCustomId;

    @InvocableVariable
    global String opporutnityType;

    @InvocableVariable
    global List<Asset> assets;

    @InvocableVariable
    global Id oppId;

    @InvocableVariable
    global string action;
}