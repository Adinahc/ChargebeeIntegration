/**
* @author: Solved by Software, Co
*/

public with sharing class CBOpportunityProductTriggerHelper {
    public static void AssociateCBOppLineItem(List<chargebeeapps__CB_Opportunity_Product__c> opps) {
        System.debug('AssociateCBOppLineItem');
        List<Id> oppIds = new List<Id>();
        List<Id> cbItemIds = new List<Id>();
        for(chargebeeapps__CB_Opportunity_Product__c opp : opps) {
            oppIds.add(opp.chargebeeapps__Opportunity__c);
            cbItemIds.add(opp.Id);
        }
        System.debug('AssociateCBOppLineItem items: ' + opps);
        List<OpportunityLineItem> items = [SELECT Id, OpportunityId, CB_Opportunity_Product__c,Product2Id 
                                            FROM OpportunityLineItem
                                            WHERE OpportunityId in :oppIds];
        System.debug('AssociateCBOppLineItem items: ' + items);
        List<Id> oppItemIds = new List<Id>();
        for(OpportunityLineItem item : items) {
            oppIds.add(item.OpportunityId);
            oppItemIds.add(item.Id);
        }
        List<chargebeeapps__CB_Opportunity_Product__c> cbItems = [SELECT Id, chargebeeapps__Unit_Price__c,chargebeeapps__Opportunity__c,
                                                                    chargebeeapps__Product__c,chargebeeapps__CB_Item_Price__r.chargebeeapps__Price__c,
                                                                    chargebeeapps__Opportunity_Product_Id__c, chargebeeapps__Subtotal__c,
                                                                    chargebeeapps__Quantity__c
                                                                    FROM chargebeeapps__CB_Opportunity_Product__c
                                                                    WHERE chargebeeapps__Opportunity__c in :oppIds];
        System.debug('AssociateCBOppLineItem cbItems: ' + cbItems);
        Map<String, chargebeeapps__CB_Opportunity_Product__c> cbItemMap = new Map<String, chargebeeapps__CB_Opportunity_Product__c>();
        for(chargebeeapps__CB_Opportunity_Product__c cbItem : cbItems) {
            cbItemMap.put(String.valueOf(cbItem.chargebeeapps__Opportunity__c) + String.valueOf(cbItem.chargebeeapps__Product__c), cbItem);
        }
        System.debug('AssociateCBOppLineItem cbItemMap: ' + cbItemMap);
        for(OpportunityLineItem item : items) {
            chargebeeapps__CB_Opportunity_Product__c cbItem = cbItemMap.get(String.valueOf(item.OpportunityId) + String.valueOf(item.Product2Id));
            item.CB_Opportunity_Product__c = cbItem.Id;
            item.UnitPrice = cbItem.chargebeeapps__Subtotal__c/cbItem.chargebeeapps__Quantity__c;

            /*if(cbItemMap.get(String.valueOf(item.OpportunityId) + String.valueOf(item.Product2Id)).chargebeeapps__Unit_Price__c != null) {
                item.UnitPrice = cbItemMap.get(String.valueOf(item.OpportunityId) + String.valueOf(item.Product2Id)).chargebeeapps__Unit_Price__c;
            } else {
                item.UnitPrice = cbItemMap.get(String.valueOf(item.OpportunityId) + String.valueOf(item.Product2Id)).chargebeeapps__CB_Item_Price__r.chargebeeapps__Price__c;
            }*/

            System.debug('AssociateCBOppLineItem item: ' + item);
        }
        update items;
    }
}