/**
* @author: Solved by Software, Co
*/

@isTest
public class LaunchedDateInvocableTest {
    @isTest
    public static void runTest(){
        
        Vendor__c ven = new Vendor__c();
        ven.Active__c = true;
        ven.POS__c = true;
        insert ven;
        
        Opportunity opp = new Opportunity(Name='Test Opportunity',CloseDate=System.today(),StageName='Prospect',LeadSource='Paid');
        opp.POS__c = ven.Id;
        insert opp;
        
        Opportunity_Location__c objOpportunityLocation = new Opportunity_Location__c();
        objOpportunityLocation.Opportunity__c = opp.Id;
        insert objOpportunityLocation;
        
        List<LaunchedDateInvocable.LaunchedDateInvocableRequest> inputList = new List<LaunchedDateInvocable.LaunchedDateInvocableRequest>();
        LaunchedDateInvocable.LaunchedDateInvocableRequest input = new LaunchedDateInvocable.LaunchedDateInvocableRequest();
        input.oppId = opp.id;
        inputList.add(input);
        
        List<LaunchedDateInvocable.LaunchedDateInvocableResponse> responses = new List<LaunchedDateInvocable.LaunchedDateInvocableResponse>();
        responses = LaunchedDateInvocable.GetOpportunityLocation(inputList);
        
        LaunchedDateInvocable.LaunchedDateInvocableResponse response = responses[0];
        
        System.assertEquals(response.oppLocationList.size(), 1);
    }

}