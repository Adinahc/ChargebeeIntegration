/**
* @author: Solved by Software, Co
*/

global class GetChildAccountOpportunityInvocable {
    @InvocableMethod(Label='Get Child Account\'s Opportunity')
    public static List<GetChildAccountOpportunityResponse> getChild(List<GetChildAccountOpportunityRequest> reqs) {
        GetChildAccountOpportunityRequest request = reqs[0];
	
        Set<Id> accIdSet = new Set<Id>();
        for (Account acc: request.childAccountList){
            accIdSet.add(acc.id);
        }
		GetChildAccountOpportunityResponse response = new GetChildAccountOpportunityResponse();
        response.childAccountOpportunityList = [SELECT Id FROM Opportunity WHERE AccountId IN: accIdSet];
        
        List<GetChildAccountOpportunityResponse> responses = new List<GetChildAccountOpportunityResponse>();
        responses.add(response);
        return responses;
    }
    
    global class GetChildAccountOpportunityRequest {
        @InvocableVariable
        global List<Account> childAccountList;
    }
    
    global class GetChildAccountOpportunityResponse {
        @InvocableVariable
        global List<Opportunity> childAccountOpportunityList;
    }
}