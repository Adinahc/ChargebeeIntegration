/**
* @author: Solved by Software, Co
*/

public with sharing class ChargebeeUpdateSubscriptionInvocable {
    @InvocableMethod(Label='Update Subscription to Set Start Date')
    public static void ChargebeeUpdateSubscription(List<ChargebeeSubscriptionRequest> reqChargebeeSubscription) {
        ChargebeeSubscriptionRequest req = reqChargebeeSubscription.get(0);
        updateSubscription(req.accountId,req.ChargeBeeSubscriptionId,req.subscriptionStartDate);
    }

    @future(callout = true)
    public static void updateSubscription(String accountId, String ChargeBeeSubscriptionId, Date subscriptionStartDate){
        ChargebeeController chargebeeCls = new ChargebeeController(); 
        System.debug('CC:...' + subscriptionStartDate);
        //Start subscription immediate
        if(subscriptionStartDate.daysBetween(System.today())>=0){
            System.debug('run immediate');
            chargebeeCls.updateSubscription(ChargeBeeSubscriptionId, '0' );
        }else{
            //For Future Date
            System.debug('Future Date');
            DateTime startDate = Datetime.newInstance(subscriptionStartDate.year(), subscriptionStartDate.month(), subscriptionStartDate.day());            
            chargebeeCls.updateSubscription(ChargeBeeSubscriptionId, String.valueOf(startDate.getTime()/1000));

        }
    }

    public class ChargebeeSubscriptionRequest {
        @InvocableVariable
        public String accountId;

        @InvocableVariable
        public String ChargeBeeSubscriptionId;
        
        @InvocableVariable
        public Date subscriptionStartDate;    
    }
}