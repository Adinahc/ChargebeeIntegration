/**
* @author: Solved by Software, Co
*/
global class ChargebeeResumeSubscriptionInvocable {
    @InvocableMethod(Label='Resume Subscription') 
    public static void ResumeCBSubscription(List<ChargebeeInvocableRequest> reqs) {
        Chargebee_Setting__mdt chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
        List<ChargebeeAPIField__mdt> ChargebeeAPIFields = [SELECT Id, Key__c, Value__c FROM ChargebeeAPIField__mdt
                                                            WHERE API_Name__c = 'Resume Subscription'];
        String body = '';
        for(ChargebeeAPIField__mdt singleChargebeeAPIField:ChargebeeAPIFields){
            body += new ChargebeeController().setValue(singleChargebeeAPIField.Key__c, singleChargebeeAPIField.Value__c);    
        }
        body = body.substringBeforeLast('&');
        for(ChargebeeInvocableRequest req : reqs) {
            DoCallOut(chargebeeSetting.Resume_Subscription_Url__c.replace('{{SubscriptionId}}', req.cbSubscriptionId), body, 'POST', 'Resume CB Subscription for Account: ' + req.accountId);
        }
    } 
    @Future(callout=true)
    public static void DoCallOut(String URL, String body, String method, String logDescription) {
        new ChargebeeController().doCallOut(URL, body, method, logDescription);
    }
}