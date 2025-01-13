/**
* @author: Solved by Software, Co
*/

public with sharing class CreateTempAssetsFromTempOppLineItems {
    @InvocableMethod(Label='Create assets from temp opplineitems') 
    public static List<CreateOpportunityLineItemRequest> CreateAssets(List<OpportunityLineItemRequest> oppReqs) {
        for(OpportunityLineItemRequest items : oppReqs) {
            
        }
        CreateOpportunityLineItemRequest req = new CreateOpportunityLineItemRequest();
        //req.tempOppLineItems = oppReqs;
        List<CreateOpportunityLineItemRequest> reqs = new List<CreateOpportunityLineItemRequest>();
        reqs.add(req);
        return reqs;
    }
}