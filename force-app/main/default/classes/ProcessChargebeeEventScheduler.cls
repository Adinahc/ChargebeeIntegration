/**
* @author: Solved by Software, Co
*/

public class ProcessChargebeeEventScheduler  implements Schedulable {
	public void execute(SchedulableContext ctx) {
    	Database.executeBatch(new ProcessChargebeeEventBatch(),1);
		Integer interval = Label.ProcessChargebeeEventBatchInterval != null ? Integer.valueOf(Label.ProcessChargebeeEventBatchInterval) : 60;
        DateTime nextTime = DateTime.Now().addMinutes(interval);
        String hour = String.valueOf(nextTime.hour());
        String min = String.valueOf(nextTime.minute()); 
        String ss = String.valueOf(nextTime.second());
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        if(!Test.isRunningTest()) {
            System.abortJob(ctx.getTriggerId());
            String jobID = system.schedule('ProcessChargebeeEventScheduler ' + nextFireTime, nextFireTime, new ProcessChargebeeEventScheduler());
        } 
	}
}