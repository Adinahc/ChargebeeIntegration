/**
* @author: Solved by Software, Co
*/

@isTest
public with sharing class ChargebeeControllerTest {
    @TestSetup
    static void makeData(){
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.chargebeeapps__CB_Id__c = 'Test';
       	objAccount.Type = 'Customer';
        insert objAccount;
    }
    @isTest
    static void updateSubscriptionTest(){
        ChargebeeController cntrl = new ChargebeeController();
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseGenerator());
        cntrl.updateSubscription('Test', 'Test');
    }
    @isTest 
    static void cancelSubscriptionTest() {
        ChargebeeController cntrl = new ChargebeeController();
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseGenerator());
        cntrl.cancelSubscription('Test', System.today(), 'Test', '');
    }
    @isTest 
    static void pauseSubscriptionTest() {
        ChargebeeController cntrl = new ChargebeeController();
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseGenerator());
        cntrl.pauseSubscription('Test');
    }
    @isTest 
    static void resumeSubscriptionTest() {
        ChargebeeController cntrl = new ChargebeeController();
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseGenerator());
        cntrl.resumeSubscription('Test','Test');
    }
}