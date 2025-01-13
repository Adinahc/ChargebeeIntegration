/**
* @author: Solved by Software, Co
*/

@isTest
public with sharing class ChargebeeInvoiceInvocableTest {
    @TestSetup
    static void makeData(){
        SyncToChargebeeControllerTest.makeData();
    }
    @isTest
    public static void TestChargebeeInvoiceInvocable() {
        String oppId = System.Label.Test_Opp_Id;
        List<Asset> asses = [SELECT Id, AccountId, Product2Id, Product2.Name, ProductCode, Net_Unit_Price__c, Bill_To_Account_Type__c, Subscription_Type__c,
                                Account.Paid_by_Parent__c, Account.ParentId, Store_Location_Type__c, CB_Product_Type__c, CB_External_Id__c, CB_Net_Unit_Price__c, Opportunity_Product__c
                                FROM Asset
                                WHERE Opportunity__c = :oppId AND (Account.ParentId = null or Account.Paid_by_Parent__c = true) and 
                                CB_Product_Type__c ='CHARGE'];
        ChargebeeInvocableRequest req = new ChargebeeInvocableRequest();
        req.assets = asses;
        //req.childId = '0015Y00002h8iN0QAI';
        req.oppId = oppId;
        List<ChargebeeInvocableRequest> reqs = new List<ChargebeeInvocableRequest>();
        reqs.add(req);
        Test.setMock(HttpCalloutMock.class, new ChargebeeInvocableTest.ChargebeeHttpResponseGenerator());
        Test.startTest();
        ChargebeeInvoiceInvocable.CreateInvoice(reqs) ;
        Test.stopTest();
    }
}