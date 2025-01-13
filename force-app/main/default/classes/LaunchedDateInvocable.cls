/**
* @author: Solved by Software, Co
*/

global with sharing class LaunchedDateInvocable {
    @InvocableMethod(Label='Get Opportunity Location')
    global static List<LaunchedDateInvocableResponse> GetOpportunityLocation(List<LaunchedDateInvocableRequest> inputList) {
        LaunchedDateInvocableRequest currentRequest = inputList[0];
        
        List<Opportunity_Location__c> oppLocationList = [SELECT Id, Launch_Date__c, Location_Store_Type__c 
                                         FROM Opportunity_Location__c 
                                         WHERE Opportunity__c =: currentRequest.oppId];
        List<LaunchedDateInvocableResponse> responseList = new List<LaunchedDateInvocableResponse>();
        LaunchedDateInvocableResponse currentResponse = new LaunchedDateInvocableResponse();
        currentResponse.oppLocationList = oppLocationList;
        responseList.add(currentResponse);
        return responseList;
    }
    
    global class LaunchedDateInvocableRequest {
        @InvocableVariable
        global Id oppId;
	}
    
    global class LaunchedDateInvocableResponse {
        @InvocableVariable
        global List<Opportunity_Location__c> oppLocationList;
	}
}