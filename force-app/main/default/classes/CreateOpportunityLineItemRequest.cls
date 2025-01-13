/**
* @author: Solved by Software, Co
*/

global class CreateOpportunityLineItemRequest {
    @InvocableVariable
    global String oppLineItems;
    @InvocableVariable
    global List<Id> accountIds;
    @InvocableVariable
    global Id opportunityId;
    @InvocableVariable
    global List<OpportunityLineItemRequest> tempOppLineItems;
    @InvocableVariable
    global List<Asset> assets;
    @InvocableVariable
    global boolean initial;
    @InvocableVariable
    global String uniqueOppLineItems;
    @InvocableVariable
    global String assetsString;
    @InvocableVariable
    global List<AssetRequest> tempAssets;
    @InvocableVariable
    global List<OpportunityLineItem> oppLineItemList;
    @InvocableVariable
    global List<OpportunityLineItem> uniqueOppLineItemList;
    @InvocableVariable
    global boolean finalContract;
    @InvocableVariable
    global string oppType;
}