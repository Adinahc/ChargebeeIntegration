/**
* @author: Solved by Software, Co
*/

public with sharing class DeserializeChargebeeError {
    @InvocableMethod(Label='Deserialize ChargebeeError') 
    public static  List<ChargebeeError> parseChargebeeError(List<String> errorMessage) {
        List<ChargebeeError> errors = new List<ChargebeeError>();
        for(String s : errorMessage) {
            ChargebeeError e = (ChargebeeError)JSON.deserialize(errorMessage[0], ChargebeeError.class);
            errors.add(e);
        }
        return errors;
    }
}