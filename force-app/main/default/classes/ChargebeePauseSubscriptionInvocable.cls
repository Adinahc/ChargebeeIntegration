/**
* @author: Solved by Software, Co
*/
global class ChargebeePauseSubscriptionInvocable {
    @InvocableMethod(Label='Pause Subscription') 
    public static void PauseCBSubscription(List<ChargebeeInvocableRequest> reqs) {
        Chargebee_Setting__mdt chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
        List<ChargebeeAPIField__mdt> ChargebeeAPIFields = [SELECT Id, Key__c, Value__c FROM ChargebeeAPIField__mdt
                                                            WHERE API_Name__c = 'Pause Subscription without Date'];
        String body = '';
        for(ChargebeeAPIField__mdt singleChargebeeAPIField:ChargebeeAPIFields){
            body +=  new ChargebeeController().setValue(singleChargebeeAPIField.Key__c, singleChargebeeAPIField.Value__c);    
        }
        body = body.substringBeforeLast('&');
        for(ChargebeeInvocableRequest req : reqs) {
            ChargebeeResumeSubscriptionInvocable.doCallOut(chargebeeSetting.Pause_Subscription_Url__c.replace('{{SubscriptionId}}', req.cbSubscriptionId), body, 'POST', 'Pause CB Subscription for Account: ' + req.accountId);
        }
    }
}