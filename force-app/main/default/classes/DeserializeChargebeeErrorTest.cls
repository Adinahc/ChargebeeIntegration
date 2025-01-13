/**
* @author: Solved by Software, Co
*/

@isTest
public with sharing class DeserializeChargebeeErrorTest {
    @isTest
    public static void TestDeserialization() {
        String cbJSON = '{"message":"Subscription cannot be updated as we are not able to collect USD 49.80 from your card on file. Error message: (bank_account_unverified) The customer\'s bank account must be verified in order to create an ACH payment. For more information, see https://stripe.com/docs/guides/ach#manually-collecting-and-verifying-bank-accounts.","type":"payment","api_error_code":"payment_processing_failed","error_code":"payment_error_during_update","error_msg":"Subscription cannot be updated as we are not able to collect USD 49.80 from your card on file. Error message: (bank_account_unverified) The customer\'s bank account must be verified in order to create an ACH payment. For more information, see https://stripe.com/docs/guides/ach#manually-collecting-and-verifying-bank-accounts.","http_status_code":400}';
        List<String> cbJSONList = new List<String>();
        cbJSONList.add(cbJSON);
        List<ChargebeeError> errors = DeserializeChargebeeError.parseChargebeeError(cbJSONList);
        Integer a = errors[0].http_status_code;
        ChargebeeError e = new ChargebeeError();
        e.http_status_code = 1;
        e.message = '';
        e.type = '';
        e.api_error_code = '';
        e.error_code = '';
        e.error_msg = '';
        System.assert(errors.size() == 1);
    }
}