/**
* @author: Solved by Software, Co
*/


public with sharing class CreateOpportunityLineItemsFromAssets {
    @InvocableMethod(Label='Create OpportunitLineItems from Assets') 
    public static List<CreateOpportunityLineItemRequest> CreateItems(List<CreateOpportunityLineItemRequest> requests) {
        List<AggregateResult> results = [SELECT Product2Id,Product2.Name,ProductCode, Pricebook_Entry__c, Net_Unit_Price_Text__c, count(Id) Qty
                                            FROM Asset
                                            WHERE AccountId in :requests[0].accountIds AND Expired__c = false AND CB_Product_Type__c = 'PLAN'
                                            GROUP BY Product2Id,Product2.Name,ProductCode, Pricebook_Entry__c, Net_Unit_Price_Text__c
                                            ORDER BY ProductCode];
        if(requests[0].Initial == false) {
            results = [SELECT Product2Id,Product2.Name,ProductCode, Pricebook_Entry__c, Net_Unit_Price_Text__c, count(Id) Qty
                                            FROM Asset
                                            WHERE AccountId in :requests[0].accountIds AND Expired__c = false AND CB_Product_Type__c = 'PLAN' 
                                            GROUP BY Product2Id,Product2.Name,ProductCode, Pricebook_Entry__c, Net_Unit_Price_Text__c
                                            ORDER BY ProductCode];
        }
        if(requests[0].finalContract == true) {
            results = [SELECT Product2Id,Product2.Name,ProductCode, Pricebook_Entry__c, Net_Unit_Price_Text__c, Original_Price_Text__c, count(Id) Qty
                                            FROM Asset
                                            WHERE AccountId in :requests[0].accountIds AND Expired__c = false AND CB_Product_Type__c = 'PLAN' AND Original_Price_Text__c != null
                                            GROUP BY Product2Id,Product2.Name,ProductCode, Pricebook_Entry__c, Net_Unit_Price_Text__c,Original_Price_Text__c
                                            ORDER BY ProductCode];
        }
        List<Asset> existingAssets = [SELECT Id, Account.Name,Product2.Name, ProductCode, Net_Unit_Price_Text__c, Price
                                        FROM Asset
                                        WHERE AccountId in :requests[0].accountIds AND Expired__c = false AND CB_Product_Type__c = 'PLAN'];
        Map<String, String> accountNameProductAndPriceMap = new Map<String, String>();
        for(Asset a : existingAssets) { 
            String productAndPrice = a.ProductCode + a.Net_Unit_Price_Text__c;
            System.debug(productAndPrice);
            String accountName = '';
            if(accountNameProductAndPriceMap.containsKey(productAndPrice)) {
                accountName = accountNameProductAndPriceMap.get(productAndPrice) + '\n';
            }
            accountName = accountName + a.Account.Name;
            accountNameProductAndPriceMap.put(productAndPrice, accountName);
        }
        List<OpportunityLineItem> itemsByPrice = new List<OpportunityLineItem>();
        List<OpportunityLineItemRequest> tempItemsByPrice = new List<OpportunityLineItemRequest>();
        for(AggregateResult result : results) {
            if(requests[0].finalContract){
                OpportunityLineItem originalItem = ConvertToItem(result, requests[0].opportunityId, true, true, requests[0].finalContract);
            	itemsByPrice.add(originalItem);
            }
            OpportunityLineItem item = ConvertToItem(result, requests[0].opportunityId, true, false, requests[0].finalContract);
            itemsByPrice.add(item);
            OpportunityLineItemRequest tempItem = new OpportunityLineItemRequest(item);
            System.debug(tempItem.ProductCode + String.valueOf(item.UnitPrice));
            tempItem.accountList = accountNameProductAndPriceMap.get(tempItem.ProductCode + String.valueOf(item.UnitPrice));
            System.debug(tempItem);
            tempItemsByPrice.add(tempItem);
        }
        List<OpportunityLineItem> uniqueItems = new List<OpportunityLineItem>();
        List<OpportunityLineItemRequest> uniqueTempItems = new List<OpportunityLineItemRequest>();
        results = [SELECT Product2Id,Product2.Name,ProductCode, Pricebook_Entry__c, count(Id) Qty, Min(Price) minPrice
                    FROM Asset
                    WHERE AccountId in :requests[0].accountIds AND Expired__c = false AND CB_Product_Type__c = 'PLAN'
                    GROUP BY Product2Id,Product2.Name,ProductCode, Pricebook_Entry__c
                    ORDER BY ProductCode];
        for(AggregateResult result : results) {
            OpportunityLineItem item = ConvertToItem(result, requests[0].opportunityId, false, false, requests[0].finalContract);
            uniqueItems.add(item);
            uniqueTempItems.add(new OpportunityLineItemRequest(item));
        }
        CreateOpportunityLineItemRequest req = new CreateOpportunityLineItemRequest();
        req.oppLineItems = JSON.serialize(tempItemsByPrice);
        req.uniqueOppLineItems = JSON.serialize(uniqueTempItems);
        req.tempOppLineItems = uniqueTempItems;
        req.oppLineItemList = itemsByPrice;
        List<CreateOpportunityLineItemRequest> reqs = new List<CreateOpportunityLineItemRequest>();
        reqs.add(req);
        return reqs;
    }
    private static OpportunityLineItem ConvertToItem(AggregateResult result, Id oppId, boolean includePrice, boolean createOriginal, boolean finalContract) {
        System.debug('result => ' + result);
        OpportunityLineItem item = new OpportunityLineItem();
        item.PricebookEntryId = Id.valueOf(result.get('Pricebook_Entry__c').toString());
        item.Product2Id = Id.valueOf(result.get('Product2Id').toString());
		item.Product_Name__c = result.get('Name').toString();        
        item.Product_Code_copy__c = result.get('ProductCode').toString();
        if(includePrice) {
            item.UnitPrice = Decimal.valueOf(result.get('Net_Unit_Price_Text__c').toString());
            item.Original_Price__c = item.UnitPrice;
            if(finalContract) {
                item.Original_Price__c = Decimal.valueOf(result.get('Original_Price_Text__c').toString());
            }
            item.Quantity = Integer.valueOf(result.get('Qty').toString());
            if(createOriginal) {
                Decimal originalPrice = 
                item.UnitPrice = Decimal.valueOf(result.get('Original_Price_Text__c').toString());
                item.Quantity = (Integer.valueOf(result.get('Qty').toString()))*-1;
            }
        } else {
            item.UnitPrice = -123456;
            item.Original_Price__c = Decimal.valueOf(result.get('minPrice').toString());
            item.Quantity = Integer.valueOf(result.get('Qty').toString());
        }
        item.OpportunityId = oppId;
        item.Temp_Id__c = GuidUtil.NewGuid()[0];
        return item;
    }
}