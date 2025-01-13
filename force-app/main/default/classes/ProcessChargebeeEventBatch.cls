/**
* @author: Solved by Software, Co
*/

global class ProcessChargebeeEventBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {        
        String query = 'SELECT Id, Account__c, CB_Customer_Id__c, CB_Event_Id__c, ' +
	                    'CB_Event_Type__c, CB_Invoice_Id__c, CB_Subscription_Id__c, Opportunity__c, ' +
	                    'Processed__c, To_be_Processed__c ' +
                        'FROM Chargebee_Event__c ' +
                        'WHERE Processed__c = false';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<Chargebee_Event__c> events) {
        for(Chargebee_Event__c evet : events){
            evet.To_be_Processed__c = true;
        }
        update events;
    }
    public void finish(Database.BatchableContext BC) {
        system.debug('==========ProcessChargebeeEventBatch=====');
    }
}