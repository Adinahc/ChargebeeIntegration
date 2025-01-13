/**
* @author: Solved by Software, Co
*/

public with sharing class DeserealizeTempOpportunityLineItems {
    @InvocableMethod(Label='Deserealize Temp OpportunityLineItems') 
    public static List<CreateOpportunityLineItemRequest> DeserealizeTempOpportunityLineItems(List<String> jsonString) {
        List<OpportunityLineItemRequest> oppReqs = (List<OpportunityLineItemRequest>)JSON.deserialize(jsonString[0], List<OpportunityLineItemRequest>.class);
        CreateOpportunityLineItemRequest req = new CreateOpportunityLineItemRequest();
        req.tempOppLineItems = oppReqs;
        List<CreateOpportunityLineItemRequest> reqs = new List<CreateOpportunityLineItemRequest>();
        reqs.add(req);
        return reqs;
    }
}