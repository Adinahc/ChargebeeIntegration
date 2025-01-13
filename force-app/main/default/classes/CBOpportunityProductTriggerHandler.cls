/**
* @author: Solved by Software, Co
*/

public with sharing class CBOpportunityProductTriggerHandler extends TriggerHandler{
    public CBOpportunityProductTriggerHandler() {
        //this.setMaxLoopCount(1);
    }

    protected override void beforeInsert(){

    }
    
    protected override void beforeUpdate(){
        // add beforeUpdate methods
    }
    
    protected override void beforeDelete(){
        // add beforeDelete methods
    }
    
    protected override void afterInsert(){    
        CBOpportunityProductTriggerHelper.AssociateCBOppLineItem((List<chargebeeapps__CB_Opportunity_Product__c>) Trigger.New); 
    }
    
    protected override void afterUpdate() {
        CBOpportunityProductTriggerHelper.AssociateCBOppLineItem((List<chargebeeapps__CB_Opportunity_Product__c>) Trigger.New); 
    }
    
    protected override void afterDelete(){
    }
    
    protected override void afterUndelete(){
        // add afterUndelete methods
    }
}