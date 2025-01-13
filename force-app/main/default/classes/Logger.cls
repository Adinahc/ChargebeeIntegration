/**
* @author:  Solved by Software, Co
* @date:    1/11/2022
*/

global class Logger {
    public static Log__c CreateLogFromRequest(HttpRequest req, string interaction, string description) {
        boolean error = false;
        Http httpVar = new Http();
        string errorM = null;
        HttpResponse res = new HttpResponse();
        try{
            if(!Test.isRunningTest()) {
                res = httpVar.send(req);
            }
        } catch (Exception ex) {
            errorM = ex.getMessage();
        } finally {
            return CreateLog(req.getBody(), res.getBody(), interaction, description, error, errorM);
        }
        return null; 
    }
    public static Log__c CreateLog(string request, string response, string interaction, string description, boolean error, string errorMessage) {
        Log__c l = new Log__c();
        l.Interaction__c = interaction != null ? interaction.left(255) : '';
        l.Request__c = request != null ? request.left(131072) : '';
        l.Response__c = response != null ? response.left(131072) : '';
        l.Description__c = description != null ? description.left(131072) : '';
        l.Error_Message__c = errorMessage != null ? errorMessage.left(131072) : '';
        l.Error__c = error;
        return l;
    }
}