/**
* @author: Solved by Software, Co
*/

public with sharing class DeserealizeTempAssets {
    @InvocableMethod(Label='Deserealize Temp Assets') 
    public static List<CreateOpportunityLineItemRequest> DeserealizeTempAssets(List<String> jsonString) {
        List<AssetRequest> oppReqs = (List<AssetRequest>)JSON.deserialize(jsonString[0], List<AssetRequest>.class);
        CreateOpportunityLineItemRequest req = new CreateOpportunityLineItemRequest();
        req.tempAssets = oppReqs;
        List<CreateOpportunityLineItemRequest> reqs = new List<CreateOpportunityLineItemRequest>();
        reqs.add(req);
        return reqs;
    }
}