/**
* @author: Solved by Software, Co
*/


public with sharing class ChargebeeVoidUnpaidInvoices {
    @InvocableMethod(Label='Void All Unppaid Invoices') 
    public static List<ChargebeeInvocableRequest> VoidInvoices(List<ChargebeeInvocableRequest> reqs) {
        Chargebee_Setting__mdt chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
        Httprequest req = new HttpRequest();
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Blob headerValue = Blob.valueOf(chargebeeSetting.Private_Key__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http httpVar = new Http();
        ChargebeeInvocableRequest r = new ChargebeeInvocableRequest();
        r.logs = new List<Log__c>();
        for(string ll : reqs[0].invoiceIds) {
            string url = 'https://incentivio-test.chargebee.com/api/v2/invoices/' + ll  + '/void';
            req.setEndpoint(url);
            req.setMethod('POST');
	        HttpResponse response = httpVar.send(req);  
            Log__c log = new Log__c();
            log.Description__c = 'Void invoice: ' + ll;
            log.Request__c = url;
            log.Response__c = response.getBody();
            r.logs.add(log);
        }
        List<ChargebeeInvocableRequest> requs = new List<ChargebeeInvocableRequest>();
        requs.add(r);
        return requs;
    }
}