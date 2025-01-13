/**
* @author: Solved by Software, Co
*/

global class CreateCBSubBatchableScheduler implements Schedulable {
    private final ChargebeeInvocableRequest req;
    public CreateCBSubBatchableScheduler(ChargebeeInvocableRequest thisReq) {
        req = thisReq;
    }
    public void execute(SchedulableContext ctx) {
        Map<String, Object> params = new Map<String, Object>();
        params.put('Action',req.action);
        params.put('Accounts',req.accountList);
        params.put('Assets',req.assets);
        params.put('AccountIds',req.accountIds);
        params.put('OpportunityId',req.oppId);
        params.put('OpporutnityType',req.opporutnityType);

        //create instance of Interview
        Flow.Interview.Batch_Create_CB_Subscription_With_Wait thisFlow = new Flow.Interview.Batch_Create_CB_Subscription_With_Wait(params);
        //Invoke start method
        thisFlow.start();

        if(!Test.isRunningTest()) {
            System.abortJob(ctx.getTriggerId()); 
        }
    }
}