/**
* @author: Solved by Software, Co
*/

public with sharing class ChargebeeAccountInvocable {
    @InvocableMethod(Label='Create Customer')
    public static List<ChargebeeInvocableRequest> CreateAccount(List<ChargebeeInvocableRequest> reqs) {
        Chargebee_Setting__mdt chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
        return CallCB(reqs[0].oppId, chargebeeSetting.Create_Customer_Url__c, reqs[0].parentId, 'Create CB Customer for:' + reqs[0].parentId, 'Customer', chargebeeSetting.Private_Key__c, reqs[0].accountList, reqs[0].billingContacts, reqs[0].EventId);
    }
    public static List<ChargebeeInvocableRequest> CallCB(Id oppId, string url, Id accountId, String logDescription, String cbType, String privateKey, List<Account> accountList, List<AccountContactRelation> relates, String eventId) {
        System.debug('CC Relates: ' + relates);
        System.debug('CC accountId: ' + accountId);
        List<ChargebeeInvocableRequest> rs = new List<ChargebeeInvocableRequest>();
        List<Log__c> logs = new List<Log__c>();
        ChargebeeInvocableRequest cbreq = new ChargebeeInvocableRequest();
        string cusId = null;
        AccountContactRelation relate = null;
        Account objAccount = new Account();
        for(Account acct : accountList) {
            if(acct.Id == accountId) {
                objAccount = acct;
                break;
            }
        }
        if(relates != null) {
            for(AccountContactRelation rel : relates) {
                if(rel.accountId == accountId) {
                    relate = rel;
                    break;
                }
            } 
        }  
        CB_Item__c item = new CB_Item__c();
        Log__c log = new Log__c();
        log.Description__c = 'Create CB Customer for: ' + accountId;
        if(objAccount.chargebeeapps__CB_Id__c == null) {
            Httprequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            Blob headerValue = Blob.valueOf(privateKey);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            String body = '';
            body += setValue('company', objAccount.Name);
            body += setValue('billing_address[line1]', objAccount.BillingStreet);
            body += setValue('billing_address[city]', objAccount.BillingCity);
            body += setValue('billing_address[state]', objAccount.BillingState);
            body += setValue('billing_address[zip]', objAccount.BillingPostalCode);
            //body += setValue('billing_address[country]', objAccount.BillingCountry);
            if(relate != null) {
                body += setValue('email', relate.Contact_Email__c);
                body += setValue('phone', relate.Contact_Phone__c);
                body += setValue('last_name', relate.Contact_Last_Name__c);
                body += setValue('first_name',relate.Contact_First_Name__c);
            }
            body += setValue('cf_incentivio_id',objAccount.Incentivio_Id__c);
            body += setValue('cf_account_salesforce_id',objAccount.Id);
            body += 'auto_collection=off&allow_direct_debit=true';
            req.setBody(body);
            log.Request__c = body;
            Http httpVar = new Http();
            string errorM = null;
            try {
                HttpResponse res = httpVar.send(req);
                if(res.getBody() != null) {
                    log.Response__c = res.getBody();
                    Customers cust = (Customers)JSON.deserialize(res.getBody(), Customers.Class);
                    System.debug('Customer Created: '+cust.customer.Id);
                    objAccount.chargebeeapps__CB_Id__c = cust.customer.Id;
                    item.Opportunity__c = oppId;
                    item.CB_Item_Id__c = cust.customer.Id;
                    item.CB_Item_Type__c = cbType;
                    item.Account__c = accountId;
                    cusId = cust.customer.Id;
                    cbreq.cbItem = item;
                }
            } catch (Exception ex) {
                log.Error__c = true;
                log.Error_Message__c = ex.getMessage();
            }
            logs.add(log);
        } else {
            cusId = objAccount.chargebeeapps__CB_Id__c;
        }
        cbreq.logs = logs;
        cbreq.cbId = cusId;
        rs.add(cbreq);
        return rs;
    }

    private static String setValue(String key, String value) {
        if(String.isNotBlank(value)) {
            return key + '=' + EncodingUtil.urlEncode(value,'UTF-8') + '&';
        }
        return '';
    }

    private class Customers{
        private Customer customer;
    }
    private class Customer{
        private String Id;
    }
}