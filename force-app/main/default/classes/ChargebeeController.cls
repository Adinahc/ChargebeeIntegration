/**
* @author: Solved by Software, Co
*/

public with sharing class ChargebeeController {
    public Chargebee_Setting__mdt chargebeeSetting {get;set;}
    Boolean runningInASandbox =false;
    public Id siteId {get;set;}

    public ChargebeeController() {
        runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String env = runningInASandbox?'Sandbox':'Production';
        chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
        List<chargebeeapps__CB_Sites__c>  sites = [SELECT Id, Name
                                                    FROM chargebeeapps__CB_Sites__c 
                                                    WHERE Name = :chargebeeSetting.Charge_Bee_Site_Name__c];
        if(sites.size() > 0) {
            siteId = sites[0].Id;
        }
    }

    //Update Subscription
    public void updateSubscription(String SubscriptionId, String StartDate){
        String body = '';
        body += setValue('start_date', StartDate);
        body = body.substringBeforeLast('&');
        doCallOut(chargebeeSetting.Update_Subscription_Url__c.replace('{{SubscriptionId}}',SubscriptionId), body, 'POST', 'Update Chargebee Subscription ' + SubscriptionId);
    }

    public String setValue(String key, String value) {
        if(String.isNotBlank(value)) {
            return key + '=' + EncodingUtil.urlEncode(value,'UTF-8') + '&';
        }
        return '';
    }

    //Cancel Subscription
    public void cancelSubscription(String SubscriptionId, Date cancelDate, String CustomerType, String accountId){
        
        List<ChargebeeAPIField__mdt> ChargebeeAPIFields = [SELECT Id, Key__c, Value__c FROM ChargebeeAPIField__mdt
                                                            WHERE API_Name__c = 'Cancel Subscription'];
        String body = '';
        for(ChargebeeAPIField__mdt singleChargebeeAPIField:ChargebeeAPIFields){
            body += setValue(singleChargebeeAPIField.Key__c, singleChargebeeAPIField.Value__c);    
        }
        if(cancelDate > System.today()) {
            DateTime cancelDT = (DateTime)cancelDate;
            long cancelDateTime = cancelDT.getTime();
            body += setValue('cancel_at', (String.valueOf(cancelDateTime)).left(10));
        }
        body += setValue('cf_customer_type', CustomerType);
        body = body.substringBeforeLast('&');
        doCallOut(chargebeeSetting.Cancel_Subscription_Url__c.replace('{{SubscriptionId}}',SubscriptionId), body, 'POST', 'Cancel Chargebee Subscription for Account: ' + accountId);
    }

    //Pause Subscription Without Date
    public void pauseSubscription(String SubscriptionId){

        List<ChargebeeAPIField__mdt> ChargebeeAPIFields = [SELECT Id, Key__c, Value__c FROM ChargebeeAPIField__mdt
                                                            WHERE API_Name__c = 'Pause Subscription without Date'];
        String body = '';
        for(ChargebeeAPIField__mdt singleChargebeeAPIField:ChargebeeAPIFields){
            body += setValue(singleChargebeeAPIField.Key__c, singleChargebeeAPIField.Value__c);    
        }
        body = body.substringBeforeLast('&');
        //postCallOut(chargebeeSetting.Pause_Subscription_Url__c.replace('{{SubscriptionId}}',SubscriptionId), body);    
    }

    //Pause Subscription with Date
    public void pauseSubscriptionWithDate(String SubscriptionId, String ResumeDate){

        List<ChargebeeAPIField__mdt> ChargebeeAPIFields = [SELECT Id, Key__c, Value__c FROM ChargebeeAPIField__mdt
                                                            WHERE API_Name__c = 'Pause Subscription with Date'];
        String body = '';
        for(ChargebeeAPIField__mdt singleChargebeeAPIField:ChargebeeAPIFields){
            body += setValue(singleChargebeeAPIField.Key__c, singleChargebeeAPIField.Value__c);    
        }
        body += setValue('resume_date', ResumeDate);
        body = body.substringBeforeLast('&');
        //postCallOut(chargebeeSetting.Pause_Subscription_Url__c.replace('{{SubscriptionId}}',SubscriptionId), body);        
    }
    //Resume Subscription
    public void resumeSubscription(String SubscriptionId, String ResumeDate){

        List<ChargebeeAPIField__mdt> ChargebeeAPIFields = [SELECT Id, Key__c, Value__c FROM ChargebeeAPIField__mdt
                                                            WHERE API_Name__c = 'Resume Subscription'];
        String body = '';
        for(ChargebeeAPIField__mdt singleChargebeeAPIField:ChargebeeAPIFields){
            body += setValue(singleChargebeeAPIField.Key__c, singleChargebeeAPIField.Value__c);    
        }
        body += setValue('resume_date', ResumeDate);
        body = body.substringBeforeLast('&');
        //postCallOut(chargebeeSetting.Resume_Subscription_Url__c.replace('{{SubscriptionId}}',SubscriptionId), body);          
    }

    
    //Update Customer in Chargebee
    public void updateCustomer(String CBCustomerId, String body, String accountId){
        doCallOut(chargebeeSetting.Update_Customer_Url__c.replace('{{CustomerId}}',CBCustomerId), body, 'POST', 'Update Chargebee Customer for Account:' + accountId);
    }

    //Retrieve Chargebee Customer Details By Id
    public void getCustomer(String CBCustomerId, String accountId){
        System.debug('getCustomer: '+CBCustomerId );
        doCallOut(chargebeeSetting.Update_Customer_Url__c.replace('{{CustomerId}}',CBCustomerId),null,'GET', 'Get Chargebee Customer for Account:' + accountId);
    }   

    public void doCallOut(String URL, String body, String method, String logDescription){
        System.debug('CC:' + URL);
        Httprequest req = new HttpRequest();
        req.setEndpoint(URL);
        req.setMethod(method);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Blob headerValue = Blob.valueOf(chargebeeSetting.Private_Key__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        if(body!=null){
            req.setBody(body);
        }
        Log__c log = Logger.createLogFromRequest(req, 'Callout', logDescription); 
        insert log;
    }
    
    private class Customers{
        private Customer customer;
    }
    private class Customer{
        private String Id;
    }
}