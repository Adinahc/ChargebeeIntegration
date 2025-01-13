/**
* @author: Solved by Software, Co
*/

@RestResource(urlMapping='/ChargebeeEvent/*')
global class ChargebeeEventREST {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request; 
        RestResponse res = RestContext.response;
        if(req.requestBody != null) {
            //1. Save the raw JSON to Log__c with Description = 'Event from Chargebee'
            string json = req.requestBody.toString();
            System.debug('Request body: ' + json);
            Log__c log = Logger.CreateLog(json, null, 'Incoming Webhook', 'Event from Chargebee', false, null);
            //2. try to parse JSON to ChargebeeEvent class APEX class
            try {
                ChargebeeEvent obj = ChargebeeEvent.parse(json);
                System.debug(obj.content.invoice.id);
                //3. Create a Chargebee_Event__c record
                Chargebee_Event__c evet = new Chargebee_Event__c();
                List<CB_Item__c> cbItems = [SELECT Id, Account__c, Opportunity__c 
                                            FROM CB_Item__c
                                            WHERE CB_Item_Id__c = :obj.content.invoice.id];
                if(cbItems.size() > 0) {
                    CB_Item__c cbItem = cbItems[0];
                    evet.CB_Event_Type__c = obj.event_type;
                    evet.CB_Event_Id__c = obj.id;
                    evet.CB_Subscription_Id__c = obj.content.subscription != null ? obj.content.subscription.id : null;
                    evet.CB_Customer_Id__c = obj.content.customer != null ? obj.content.customer.id : null;
                    evet.CB_Invoice_Id__c = obj.content.invoice != null ? obj.content.invoice.id : null;
                    evet.Account__c = cbItem.Account__c;
                    evet.Opportunity__c = cbItem.Opportunity__c;
                    //Only save if the event is not related to a subscription
                    if(evet.CB_Subscription_Id__c == null) {
	                    insert evet;       
                    }
                }
            } catch (Exception ex) {
                log.Error__c = true;
                log.Error_Message__c = ex.getMessage();
            }
            insert log;            
        }
    }
    @HttpGet
    global static string Ping() {
        return 'Alive';
    }
}