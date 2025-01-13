/**
* @author: Solved by Software, Co
*/

public with sharing class ChargebeeCancelSubscriptionInvocable {
    @InvocableMethod(Label='Cancel Subscription')
    public static void ChargebeeCancelSubscription(List<ChargebeeSubscriptionRequest> reqChargebeeSubscription) {
        for(ChargebeeSubscriptionRequest req : reqChargebeeSubscription) {
            if(reqChargebeeSubscription.size() + Limits.getFutureCalls() < Limits.getLimitFutureCalls()) {
                cancelSubscription(req.ChargeBeeSubscriptionId, req.CancelDate, req.CustomerType, req.AccountId);
            }
        }
    }

    @future(callout = true)
    public static void cancelSubscription(String ChargeBeeSubscriptionId, Date CancelDate, String CustomerType, String AccountId){
        System.debug(ChargeBeeSubscriptionId);
        System.debug(CancelDate);
        System.debug(CustomerType);
        ChargebeeController chargebeeCls = new ChargebeeController(); 
        chargebeeCls.cancelSubscription(ChargeBeeSubscriptionId, CancelDate, CustomerType, AccountId);
    }

    public class ChargebeeSubscriptionRequest {
        @InvocableVariable
        public String ChargeBeeSubscriptionId;
        @InvocableVariable
        public Date CancelDate;
        @InvocableVariable
        public String CustomerType;
        @InvocableVariable
        public String AccountId;
    }
}