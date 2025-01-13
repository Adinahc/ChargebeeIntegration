/**
* @author: Solved by Software, Co
*/

global class ChargebeeUpdateAccountContactInvocable {
    @future(callout=true)
    public static void CallCB(Id rId) {
        List<AccountContactRelation> re = [SELECT Id, AccountId, ContactId, Contact.LastName,
                                            Contact.FirstName, Contact.Phone, Contact.Email, Account.chargebeeapps__CB_Id__c
                                            FROM AccountContactRelation
                                            WHERE Id = :rId];
        List<Log__c> logs = new List<Log__c>();
        ChargebeeController ctrl = new ChargebeeController();
        Chargebee_Setting__mdt chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
        System.debug('CC chargebeeSetting: ' + chargebeeSetting);
        Httprequest req = new HttpRequest();
        req.setEndpoint(chargebeeSetting.Update_Customer_Url__c.replace('{{CustomerId}}',re[0].Account.chargebeeapps__CB_Id__c));
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Blob headerValue = Blob.valueOf(chargebeeSetting.Private_Key__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        System.debug(authorizationHeader);
        req.setHeader('Authorization', authorizationHeader);
        String body = '';
        body += ctrl.setValue('email', re[0].Contact.Email);
        body += ctrl.setValue('phone', re[0].Contact.Phone);
        body += ctrl.setValue('last_name', re[0].Contact.LastName);
        body += ctrl.setValue('first_name',re[0].Contact.FirstName);
        req.setBody(body);
        logs.add(logger.CreateLogFromRequest(req, 'Callout', chargebeeSetting.Update_Customer_Url__c.replace('{{CustomerId}}',re[0].Account.chargebeeapps__CB_Id__c))); 
        insert logs;
    }
    @InvocableMethod(Label='Update Customer Contact') 
    public static void ChargebeeUpdateAccountContactInvocable(List<ChargebeeInvocableRequest> reqs) {
        if(reqs.size() > 0) {
            CallCB(reqs[0].parentId);
        }
    }
}