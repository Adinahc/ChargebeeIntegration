/**
* @author: Solved by Software, Co
*/

public class ChargebeeCalloutQueueable implements Queueable {
    public ChargebeeCalloutQueueable(Account objAccount, String body, String url, String cbType, Opportunity opp, List<CB_Item__c> cbItems, List<Log__c> logs, String logDescription) {
        createItems(objAccount, body,url, cbType, opp, cbItems, logs, logDescription);
    }
    public void execute(QueueableContext context) {
        Account a = new Account(Name='Acme',Phone='(415) 555-1212');
        insert a;        
    }
    public static String createItems(Account objAccount, String body, String url, String cbType, Opportunity opp, List<CB_Item__c> cbItems, List<Log__c> logs, String logDescription){
        /*Httprequest req = new HttpRequest();
        req.setEndpoint(url.replace('{{CustomerId}}', objAccount.chargebeeapps__CB_Id__c));
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Blob headerValue = Blob.valueOf(chargebeeSetting.Private_Key__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        integer i = 0;
        req.setBody(body);
        Log__c log = Logger.createLogFromRequest(req, 'Callout', logDescription);
        logs.add(log);
        if(!log.Error__c) {  
            String CBId = '';
            if(cbType == 'Invoice') {
                ChargebeeCreateInvoiceResponse cbResponse = ChargebeeCreateInvoiceResponse.parse(log.Response__c);
                CBId = cbResponse.invoice.Id;    
                opp.Chargebee_Invoice_Url__c = new ChargebeeController().chargebeeSetting.Invoice_Base_Url__c + cbResponse.invoice.Id;   
            }
            if(cbType == 'Subscription') {
                ChargebeeCreateSubscriptionResponse chargebeeCreateSubscriptionResponse = ChargebeeCreateSubscriptionResponse.parse(log.Response__c);
                CBId = chargebeeCreateSubscriptionResponse.subscription.Id;
            }
            CB_Item__c item = new CB_Item__c();
            item.Opportunity__c = opp.Id;
            item.CB_Item_Id__c = CBId;
            item.CB_Item_Type__c = cbType;
            item.Account__c = objAccount.Id;
            cbItems.add(item);
            return log.Response__C;
        } else {
            return null;
        }*/
        return null;
    }
}