/**
* @author: Solved by Software, Co
*/

global class ChargebeeHierarchyInvocable {
    public static Chargebee_Setting__mdt getChargebeeSettingTest(){
        List<Chargebee_Setting__mdt> chargebeeSettings = new List<Chargebee_Setting__mdt>();
        Chargebee_Setting__mdt chargebeeSetting = new Chargebee_Setting__mdt();
        chargebeeSetting.Create_Customer_Url__c='https://mytest.chargebee.com/api/v2/customers';
        chargebeeSetting.Update_Customer_Url__c='https://mytest.chargebee.com/api/v2/customers/{{CustomerId}}';
        chargebeeSetting.ContentType__c='';
        chargebeeSetting.Private_Key__c='thisisprivatekey';                                                            
        chargebeeSetting.Create_Subscription_Url__c='https://mytest.chargebee.com/api/v2/customers/{{CustomerId}}/subscription_for_items';
        chargebeeSetting.Set_Hierarchy_Url__c='https://mytest.chargebee.com/api/v2/customers/{{CustomerId}}/relationships';
        chargebeeSetting.Create_Invoice_Url__c='https://mytest.chargebee.com/api/v2/invoices/create_for_charge_items_and_charges';                                                            
        chargebeeSetting.Cancel_Subscription_Url__c='https://mytest.chargebee.com/api/v2/subscriptions/{{SubscriptionId}}/cancel_for_items';
        chargebeeSetting.Pause_Subscription_Url__c='https://mytest.chargebee.com/api/v2/subscriptions/{{SubscriptionId}}/pause';
        chargebeeSetting.Resume_Subscription_Url__c='https://mytest.chargebee.com/api/v2/subscriptions/{{SubscriptionId}}/resume';
        chargebeeSetting.Update_Subscription_Url__c='https://mytest.chargebee.com/api/v2/subscriptions/{{SubscriptionId}}/update_for_items';
        chargebeeSetting.Delete_Hierarchy_Url__c='https://incentivio-test.chargebee.com/api/v2/customers/{{CustomerId}}//delete_relationship';
        chargebeeSetting.Set_Hierarchy_Url__c='https://incentivio-test.chargebee.com/api/v2/customers/{{CustomerId}}/relationships';
        chargebeeSetting.Retrieve_Invoice_as_PDF_URL__c = 'https://incentivio-test.chargebee.com/api/v2/invoices/{{invoice-id}}/pdf';
        chargebeeSetting.Charge_Bee_Site_Name__c='test-incentivio-chargebee';
        chargebeeSetting.Days_to_delay_parent_invoice__c=0;
        chargebeeSetting.Days_to_delay_location_invoice__c=0;
        chargebeeSetting.Days_to_delay_location_sub_start__c=0;
        chargebeeSetting.Void_Invoice_Url__c='https://incentivio-test.chargebee.com/api/v2/invoices/{{invoice-id}}/void';
        return chargebeeSetting;
    }
    public static Chargebee_Setting__mdt GetCBSetting() {
        boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String env = runningInASandbox?'Sandbox':'Production';
        return Test.isRunningTest()?getChargebeeSettingTest():Chargebee_Setting__mdt.getInstance(env);
    }
    private static string buildHierarchyPayload(Account parentAcct, Account objAccount, String action) {
        String body = '';
        body = 'parent_id='+parentAcct.chargebeeapps__CB_Id__c;
        boolean delaySetParentAsPayer = false;
        //If the monthly should be paid by parent and the setup fees should be paid by location, delay setting the parent as payer until after the setup invoice is paid
        if(action == 'Create' && objAccount.Monthly_Fees_Paid_by_Parent__c == true && objAccount.Paid_by_Parent__c == false) {
            delaySetParentAsPayer = true;
        }
        if(objAccount.Monthly_Fees_Paid_by_Parent__c && delaySetParentAsPayer == false) {
            body += '&payment_owner_id='+parentAcct.chargebeeapps__CB_Id__c;
            body += '&invoice_owner_id='+parentAcct.chargebeeapps__CB_Id__c;            
        } else {
            body += '&payment_owner_id='+objAccount.chargebeeapps__CB_Id__c;
            body += '&invoice_owner_id='+objAccount.chargebeeapps__CB_Id__c;      
        }
        return body;
    }
    @future(callout = true)
    public static void CallCBRecreateeHierarchy(List<Id> parentIds, List<Id> childIds) {
        List<Log__c> logs = new List<Log__c>();
        Chargebee_Setting__mdt chargebeeSetting = GetCBSetting();
        Httprequest req = new HttpRequest();
        Account objAccount= FetchAccount(childIds[0]);
        Account parentAcct = FetchAccount(parentIds[0]);
        System.debug('CC: ' + objAccount.chargebeeapps__CB_Id__c);
        req.setEndpoint(chargebeeSetting.Delete_Hierarchy_Url__c.replace('{{CustomerId}}', objAccount.chargebeeapps__CB_Id__c));
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Blob headerValue = Blob.valueOf(chargebeeSetting.Private_Key__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        logs.add(logger.CreateLogFromRequest(req, 'Callout', 'Delete Hierarchy for: ' + childIds[0]));

        req.setEndpoint(chargebeeSetting.Set_Hierarchy_Url__c.replace('{{CustomerId}}', objAccount.chargebeeapps__CB_Id__c));
        String body = buildHierarchyPayload(parentAcct,  objAccount, 'Recreate');
        req.setBody(body);

        logs.add(logger.CreateLogFromRequest(req, 'Callout', 'Create Hierarchy for: ' + childIds[0])); 
        insert logs;
    }
    public static ChargebeeInvocableRequest CallCBCreateHierarchy(Account objAccount, Account parentAcct, String eventId) {
        List<Log__c> logs = new List<Log__c>();
        ChargebeeInvocableRequest r = new ChargebeeInvocableRequest();
        Chargebee_Setting__mdt chargebeeSetting = GetCBSetting();
        Httprequest req = new HttpRequest();
        req.setEndpoint(chargebeeSetting.Set_Hierarchy_Url__c.replace('{{CustomerId}}', objAccount.chargebeeapps__CB_Id__c));
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Blob headerValue = Blob.valueOf(chargebeeSetting.Private_Key__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);

        String body = buildHierarchyPayload(parentAcct,  objAccount, 'Create');
        req.setBody(body);
        
        logs.add(logger.CreateLogFromRequest(req, 'Callout', chargebeeSetting.Set_Hierarchy_Url__c.replace('{{CustomerId}}', objAccount.chargebeeapps__CB_Id__c))); 
        
        r.logs = logs;

        List<CB_Cus_Created__e> cusEvents = new List<CB_Cus_Created__e>();
        cusEvents.add(new CB_Cus_Created__e(GUID__c = eventId));
        List<Database.SaveResult> results = EventBus.publish(cusEvents);
        return r;
    }
    private static Account FetchAccount(Id acctId) {
        System.debug('FetchAccount: ' + acctId);
        return [SELECT Id, chargebeeapps__CB_Id__c, Paid_By_Parent__c, Monthly_Fees_Paid_by_Parent__c
                FROM Account
                WHERE Id = :acctId
                LIMIT 1];
    }
    @InvocableMethod(Label='Chargebee Hierarchy')
    public static List<ChargebeeInvocableRequest> createHierarchy(List<ChargebeeInvocableRequest> reqs) {
        System.debug('createHierarchy: ' + reqs);
        List<ChargebeeInvocableRequest> rs = new List<ChargebeeInvocableRequest>();
        ChargebeeInvocableRequest r = new ChargebeeInvocableRequest();
        ChargebeeInvocableRequest req = reqs[0];
        List<Id> parentIds = new List<Id>();
        parentIds.add(req.parentId);
        List<Id> childIds = new List<Id>();
        childIds.add(req.childId);
        if(req.action == 'Create') {
            r = CallCBCreateHierarchy(req.acctObj, req.parentAcct, req.EventId);
            rs.add(r);
        } else {
            CallCBRecreateeHierarchy(parentIds, childIds);
        }
        List<CB_Cus_Created__e> cusEvents = new List<CB_Cus_Created__e>();
        cusEvents.add(new CB_Cus_Created__e(GUID__c = reqs[0].EventId));
        List<Database.SaveResult> results = EventBus.publish(cusEvents);
        return rs;
    }
}