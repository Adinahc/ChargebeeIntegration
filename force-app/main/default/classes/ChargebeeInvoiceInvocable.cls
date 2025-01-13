/**
* @author: Solved by Software, Co
*/

global class ChargebeeInvoiceInvocable  {
    @InvocableMethod(Label='Create Invoice') 
    public static void CreateInvoice(List<ChargebeeInvocableRequest> reqs) {
        Chargebee_Setting__mdt chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
        Account objAccount = reqs[0].acctObj;
        List<Asset> ass = new List<Asset>();
        if(reqs[0].assets != null) {
            ass = reqs[0].assets;
        }
        if(ass.size() > 0) {
            string body = buildInvoicePayload(objAccount, ass, chargebeeSetting);
            CallCB(chargebeeSetting.Private_Key__c, reqs[0].childId, reqs[0].oppId, body, chargebeeSetting.Create_Invoice_Url__c, reqs[0].childId, 'Create Invoice for ' + reqs[0].oppId, 'Invoice');
        }
    }
    @future(callout = true)
    public static void CallCB(String privateKey, String accountCBId, Id oppId, string body, string url, Id accountId, String logDescription, String cbType) {
        List<Log__c> logs = new List<Log__c>();
        Httprequest req = new HttpRequest();
        req.setEndpoint(url.replace('{{CustomerId}}', accountCBId));
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Blob headerValue = Blob.valueOf(privateKey);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        integer i = 0;
        req.setBody(body);
        Log__c log = Logger.createLogFromRequest(req, 'Callout', logDescription);
        logs.add(log);
        String CBId = '';
        if(cbType == 'Invoice') {
            if(!Test.isRunningTest()) {
                ChargebeeCreateInvoiceResponse cbResponse = ChargebeeCreateInvoiceResponse.parse(log.Response__c);
                if(cbResponse.invoice != null) {
                    CBId = cbResponse.invoice.Id;
                }
            }
        }
        if(cbType == 'Subscription') {
            if(!Test.isRunningTest()) {
                ChargebeeCreateSubscriptionResponse chargebeeCreateSubscriptionResponse = ChargebeeCreateSubscriptionResponse.parse(log.Response__c);
                if(chargebeeCreateSubscriptionResponse.subscription != null) {
                    CBId = chargebeeCreateSubscriptionResponse.subscription.Id;
                }
                Account act = [SELECT Id, ChargeBeeSubscriptionId__c
                                FROM Account
                                WHERE ID = :accountId];
                act.ChargeBeeSubscriptionId__c = CBId;
                act.Last_CB_Attempted__c = System.Now();
                if(CBId != '') {
                    act.Last_CB_updated__c = System.Now();
                }
                update act;
            }
        }
        CB_Item__c item = new CB_Item__c();
        item.Opportunity__c = oppId;
        item.CB_Item_Id__c = CBId;
        item.CB_Item_Type__c = cbType;
        item.Account__c = accountId;
        if(oppId != null) {
            insert item;
        }
        insert logs;
    }
    public static String buildInvoicePayload(Account objAccount, List<Asset> assets, Chargebee_Setting__mdt chargebeeSetting) {
        List<Id> itemIds = new List<Id>();
        Map<String, integer> assetQuantityMap = new Map<String, integer>();
        Map<String, Asset> assetMap = new Map<String, Asset>();
        for(Asset ass : assets) {
            integer count = 1;
            if(assetQuantityMap.containsKey(ass.Opportunity_Product__c)) {
                count = assetQuantityMap.get(ass.Opportunity_Product__c) + 1;
            }
            assetQuantityMap.put(ass.Opportunity_Product__c, count);
            if(!assetMap.containsKey(ass.Opportunity_Product__c)) {
                assetMap.put(ass.Opportunity_Product__c, ass);
            }
        }
        String body = '';
        body += 'customer_id=' + objAccount.chargebeeapps__CB_Id__c + '&';
        integer i = 0;
        for(string s : assetMap.keySet()) {
            Asset ass = assetMap.get(s);
            Integer quantity = assetQuantityMap.get(s);
            body += 'item_prices[item_price_id][' + String.valueOf(i) + ']=' + ass.CB_External_Id__c + '&';
            body += 'item_prices[unit_price][' + String.valueOf(i) + ']=' + Integer.valueOf(ass.CB_Net_Unit_Price__c * 100) + '&'; 
            if(objAccount.ParentId == null) {
                body += 'item_prices[quantity][' + String.valueOf(i) + ']=' + String.valueOf(quantity) + '&'; 
            } else {
                body += 'item_prices[quantity][' + String.valueOf(i) + ']=1&'; 
            }
            i++;
        }
        return body;
    }
}