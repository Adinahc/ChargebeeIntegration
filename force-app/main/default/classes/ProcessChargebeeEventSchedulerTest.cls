/**
* @author: Solved by Software, Co
*/

@isTest
public class ProcessChargebeeEventSchedulerTest {
	@TestSetup
    public static void makeData(){
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Phone = '111-222-3333';
        insert objAccount;
        
        Chargebee_Event__c objChargebeeEvent = new Chargebee_Event__c();
        objChargebeeEvent.Account__c=objAccount.Id;
        objChargebeeEvent.Processed__c=false;
        objChargebeeEvent.To_be_Processed__c=false;
        insert objChargebeeEvent;
    }
    @isTest
    public static void processChargebeeEventTest(){
        Chargebee_Event__c objChargebeeEvent = [SELECT To_be_Processed__c FROM Chargebee_Event__c LIMIT 1];
        System.assertEquals(false,objChargebeeEvent.To_be_Processed__c);
        
        Test.startTest();
        ProcessChargebeeEventScheduler sch = new ProcessChargebeeEventScheduler();
        sch.execute(null);
        Test.stopTest();
        
        objChargebeeEvent = [SELECT To_be_Processed__c FROM Chargebee_Event__c LIMIT 1];
        System.assertEquals(true,objChargebeeEvent.To_be_Processed__c);
    }
}