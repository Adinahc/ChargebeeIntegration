/**
* @author: Solved by Software, Co
*/

@isTest
public class ChargebeeAccountInvocableTest {
    @isTest
    static void testCreateAccount() {
        Vendor__c ven = new Vendor__c();
        ven.Active__c = true;
        ven.POS__c = true;
        insert ven;
        
         // Create Opportunity since it is required for Opportunity_Location__c
        Opportunity opp = new Opportunity();
        opp.Name  = 'Name Test';
        opp.StageName  = 'Prospect';
        opp.CloseDate  = Date.today().addDays(10);
        opp.POS__c = ven.Id;
        insert opp;
        
        Account acct = new Account();
        acct.Name = 'Test';
        acct.Type = 'Customer';
        acct.RecordTypeId = '0125Y000001bM34QAE';
        acct.Incentivio_Id__c = 'test';
        insert acct;
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.Email = 'test@test.com';
        con.AccountId = acct.Id;
        insert con;
        
        AccountContactRelation relate = [SELECT id, accountId, Contact_Email__c, Contact_Phone__c, Contact_Last_Name__c, Contact_First_Name__c 
                                            FROM AccountContactRelation
                                            WHERE contactid =: con.id];
        relate.Roles = 'Billing Contact';
        update relate;
        
        // Create a ChargebeeInvocableRequest for testing
        ChargebeeInvocableRequest request = new ChargebeeInvocableRequest();
        request.oppId = opp.id;
        request.parentId = acct.id;
        List<Account> acctList = new List<Account>();
        acctList.add(acct);
        List<AccountContactRelation> relateList = new List<AccountContactRelation>();
        relateList.add(relate);
        request.billingContacts = relateList;
        request.accountList = acctList;

        Test.setMock(HttpCalloutMock.class, new CBAccoutMockHttpResponseGenerator()); 
        Test.startTest();
        List<ChargebeeInvocableRequest> result = ChargebeeAccountInvocable.CreateAccount(new List<ChargebeeInvocableRequest>{request});
        Test.stopTest();
    }

    // Add more test methods to cover additional scenarios
}