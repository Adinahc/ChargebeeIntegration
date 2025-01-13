/**
* @author: Solved by Software, Co
*/

public class CreateCBSubBatchable implements Database.Batchable<CreateCBSubRequest>,Database.Stateful  {

    public integer counter = 1;
    public final List<CreateCBSubRequest> reqs;

    public CreateCBSubBatchable(List<CreateCBSubRequest> thisReqs) {
        System.debug('CC: ' + thisReqs.size());
        reqs = thisReqs;
    }
 
    public Iterable<CreateCBSubRequest> start(Database.BatchableContext bc){
       return reqs;
    }
 
    public void execute(Database.BatchableContext bc, List<CreateCBSubRequest> scope){
        System.debug('CC: ' + counter);
        if(scope.size() > 0) {
            List<chargebeeapps__CB_Subscription__c> cbSubs = new List<chargebeeapps__CB_Subscription__c>();
            List<Id> acctIds = new List<Id>();
            List<Account> accts = new List<Account>();
            Set<Asset> assets = new Set<Asset>();
            for(CreateCBSubRequest req : scope) {
                cbSubs.add(req.cbSub);
                acctIds.add(req.acctId);
                accts.add(req.acct);
                assets.addAll(req.assets);
            }
            List<Asset> assetList = new List<Asset>();
            for(Asset a : assets) {
                assetList.add(a);
            }
            ChargebeeInvocableRequest thisReq = new ChargebeeInvocableRequest();
            thisReq.accountList = accts;
            thisReq.accountIds = acctIds;
            thisReq.assets =  assetList;
            thisReq.cbSubs = cbSubs;
            thisReq.action = scope[0].action;
            thisReq.OppId = scope[0].OppId;
            thisReq.OpporutnityType = scope[0].OpporutnityType;
            DateTime nextTime = DateTime.Now().addMinutes(1 * counter);
            String hour = String.valueOf(nextTime.hour());
            String min = String.valueOf(nextTime.minute()); 
            String ss = String.valueOf(nextTime.second());
            String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
            String jobID = system.schedule('CreateCBSubBatchableScheduler ' + nextFireTime, nextFireTime, new CreateCBSubBatchableScheduler(thisReq));
            counter++;
        }
    }
 
    public void finish(Database.BatchableContext bc){
    }
 }