public with sharing class GetUsageIdBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    private static List<Log__c> newLogs;
    public Database.QueryLocator start(Database.BatchableContext BC) {
        newLogs = new List<Log__c>();
        return Database.getQueryLocator('SELECT Id, CreatedDate, Description__c, Request__c, Response__c FROM Log__c WHERE Description__c = \'SubId for Usage\'');
    }
    public void execute(Database.BatchableContext BC, List<Log__c> logs) {
        List<Log__c> ll = RetrieveCBEvents.GetUsage(logs);
        
        insert ll;
        /*if(ll != null) {
        	newLogs.addAll(ll);   
        }*/
    }
    public void finish(Database.BatchableContext BC) {
        //insert newLogs;
    }
}