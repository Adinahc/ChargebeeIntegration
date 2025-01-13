/**
* @author: Solved by Software, Co
*/

public with sharing class CloneAssetsInvocable {
    @InvocableMethod(Label='Clone Assets') 
    public static List<CreateOpportunityLineItemRequest> Clone(List<CreateOpportunityLineItemRequest> requests) {
        CreateOpportunityLineItemRequest req = new CreateOpportunityLineItemRequest();
        List<Asset> assets = new List<Asset>();
        if(requests[0].assets != null) {
            for(Asset asst : requests[0].assets) {
                System.debug(asst.Price);

                Asset newAsset = asst.Clone();
                newAsset.Originating_Asset__c = asst.Id;
                newAsset.Opportunity__c = requests[0].opportunityId;
                if(requests[0].oppType == 'Contraction') {
                    newAsset.quantity = -1;
                }
                assets.add(newAsset);
            }
            req.assets = assets;
        }
        List<CreateOpportunityLineItemRequest> reqs = new List<CreateOpportunityLineItemRequest>();
        reqs.add(req);
        return reqs;
    }
}