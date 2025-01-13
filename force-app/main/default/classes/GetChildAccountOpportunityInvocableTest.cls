/**
* @author: Solved by Software, Co
*/

@isTest
public class GetChildAccountOpportunityInvocableTest {
	@isTest
    public static void run(){
        GetChildAccountOpportunityInvocable.GetChildAccountOpportunityRequest request = new GetChildAccountOpportunityInvocable.GetChildAccountOpportunityRequest();
        
        Account acct = new Account();
        acct.Name = 'Test';
        acct.Type = 'Customer';
        acct.RecordTypeId = '0125Y000001bM34QAE';
        insert acct;
        
        Vendor__c ven = new Vendor__c();
        ven.Active__c = true;
        ven.POS__c = true;
        insert ven;
        
        Opportunity opp = new Opportunity(Name='Test Opportunity',CloseDate=System.today(),StageName='Prospect',LeadSource='Paid', AccountId=acct.Id);
        opp.POS__c = ven.Id;
        insert opp;
        
        List<Account> accList = new List<Account>();
        accList.add(acct);
        request.childAccountList = accList;
        List<GetChildAccountOpportunityInvocable.GetChildAccountOpportunityRequest> requests = new List<GetChildAccountOpportunityInvocable.GetChildAccountOpportunityRequest>();
        requests.add(request);
        
        List<GetChildAccountOpportunityInvocable.GetChildAccountOpportunityResponse> responses = GetChildAccountOpportunityInvocable.getChild(requests);
        
        for (GetChildAccountOpportunityInvocable.GetChildAccountOpportunityResponse response: responses){
            System.assertEquals(response.childAccountOpportunityList.size(), 1);
            System.assertEquals(response.childAccountOpportunityList[0].id, opp.id);
        }
    }
}