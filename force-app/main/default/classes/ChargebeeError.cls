/**
* @author: Solved by Software, Co
*/

global class ChargebeeError {
	@InvocableVariable
    global Integer http_status_code;
	@InvocableVariable
    global String message;
	@InvocableVariable
    global String type;
	@InvocableVariable
    global String api_error_code;
	@InvocableVariable
    global String error_code;
	@InvocableVariable
    global String error_msg;
    public ChargebeeError() {

    }
}