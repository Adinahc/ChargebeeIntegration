/**
* @author: Solved by Software, Co
*/

public with sharing class ChargebeeRetrieveInvoiceAsPDF {

    private static Chargebee_Setting__mdt chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
    private static List<Log__c> logs = new List<Log__c>();

    @InvocableMethod(callout=true label='Retrieve Invoice as PDF')
    public static void retrieveInvoiceAsPDF(List<CBInvoiceWrapper> invoiceInputs) {
        if(!invoiceInputs.isEmpty()) {
            callRetrieveInvoiceAsPDF(invoiceInputs);
        }
    }

    public static void callRetrieveInvoiceAsPDF(List<CBInvoiceWrapper> invoiceInputs) {
        
        List<InvoicePDFWrapper> invoicePDFWrapperList = new List<InvoicePDFWrapper>();

        String authorization = buildAuthorizationHeader(chargebeeSetting.Private_Key__c);
        String baseEndpoint  = chargebeeSetting.Retrieve_Invoice_as_PDF_URL__c;
        
        for(chargebeeapps__CB_Invoice__c invoice : invoiceInputs[0].cbInvoiceList) {
            
            HttpResponse res = sendRequest(
            (baseEndpoint.replace('{{invoice-id}}', invoice.chargebeeapps__CB_Invoice_Id__c)), 
            'POST', 
            new Map<String, String>{
                'Content-Type'  => 'application/x-www-form-urlencoded',
                'Authorization' => authorization
            },
            'Retrieve CB Invoice as PDF [POST]: ' + invoice.chargebeeapps__CB_Invoice_Id__c);

            ChargebeeRetrieveInvoiceAsPDFResponse cbRetrieveInvoiceAsPDFResponse = parse(res.getBody());

            InvoicePDFWrapper invoicePDFWrapper = new InvoicePDFWrapper();
            invoicePDFWrapper.invoiceId         = invoice.chargebeeapps__CB_Invoice_Id__c;
            invoicePDFWrapper.accountId         = invoice.chargebeeapps__Account__c;
            invoicePDFWrapper.invoiceBody       = cbRetrieveInvoiceAsPDFResponse.download.download_url;
            invoicePDFWrapperList.add(invoicePDFWrapper);
        }

        for(InvoicePDFWrapper inv : invoicePDFWrapperList) {
            HttpResponse res = sendRequest(inv.invoiceBody, 'GET', new Map<String, String>(), 'Retrieve CB Invoice as PDF [GET]: ' + inv.invoiceId);
            inv.invoiceBlob = res.getBodyAsBlob();

        }

        createInvoicePDFFile(invoicePDFWrapperList);
        insert logs;
    }

    private static void createInvoicePDFFile(List<InvoicePDFWrapper> invoicePDFWrapperList) {

        List<ContentVersion> objCVList = new List<ContentVersion>();
        for(InvoicePDFWrapper inv : invoicePDFWrapperList) {
            objCVList.add(
                new ContentVersion(
                    Title           = 'CB_Invoice_' + inv.invoiceId + '_' + DateTime.now().getTime(),
                    PathOnClient    = 'CB_Invoice_' + inv.invoiceId + '_' + DateTime.now().getTime() + '.pdf',
                    VersionData     =  !Test.isRunningTest() ? inv.invoiceBlob : Blob.valueOf(inv.invoiceBody)
                )
            );
        }
        insert objCVList;

        List<ContentDocumentLink> objCDLList = new List<ContentDocumentLink>();
        for(ContentVersion cv : [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN: objCVList]) {
            objCDLList.add(
                new ContentDocumentLink(
                    ContentDocumentId = cv.ContentDocumentId,
                    LinkedEntityId    = invoicePDFWrapperList[0].accountId,
                    Visibility        = 'AllUsers'
                )
            );
        }
        insert objCDLList;
        
        sendInvoices(objCVList, invoicePDFWrapperList[0].accountId);
    }

    private static void sendInvoices(List<ContentVersion> invoicesToSent, String accountId) {
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        // Set the recipient address
        message.setToAddresses(addressesToSend(accountId));
        List<String> filesSent = new List<String>();
        List<String> cvIdList = new List<String>();
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        for (ContentVersion cv: invoicesToSent) {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            filesSent.add(cv.PathOnClient);
            efa.setFileName(cv.PathOnClient);
            efa.setBody(cv.VersionData);
            efa.setContentType(cv.FileType);
            attachments.add(efa);
            cvIdList.add(cv.Id);
        }
        message.setFileAttachments(attachments);
        
        // Set the message template
        EmailTemplate template = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'CB_Resend_Invoice' LIMIT 1];
        if (template != null) {
            message.setTemplateId(template.Id);
            message.setSubject(template.Subject);
            message.setHtmlBody(template.HtmlValue);
        }

        // Set the message sender address
        List<OrgWideEmailAddress> addresses = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'billing@incentivio.com'];
        if (!addresses.isEmpty()) {
            message.setOrgWideEmailAddressId(addresses[0].Id);
        }


        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            createInvoiceSentTask(accountId, filesSent);
            deleteInvoicesSent(cvIdList);
        } catch (Exception e) {
            throw e;
        }
    }

    @future
    public static void deleteInvoicesSent(List<String> cvIdList) {
        List<ContentDocument> listToDelete = new List<ContentDocument>();
        for(ContentVersion cv : [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN: cvIdList]) {
            listToDelete.add(
                new ContentDocument (
                    Id = cv.ContentDocumentId
                )
            );
        }

        delete listToDelete;
    }

    private static void createInvoiceSentTask(String whatId, List<String> invoicesSent) {
        Task sentInvoiceTask    = new Task (
                WhatId          = whatId,
                ActivityDate    = Date.today(),
                Priority        = 'Normal',
                Status          = 'Completed',
                Type            = 'Task',
                Description     = 'Open invoices were sent to the customer: ' + '\n' + String.join(invoicesSent,', \n'),
                Subject         = 'Open Invoices Sent'
        );
        
        insert sentInvoiceTask;
    }

    private static HttpResponse sendRequest(String endpoint, String httpMethod, Map<String, String> headers, String reqDescription) {

        Http http         = new Http();
        HttpRequest req   = new HttpRequest();
        HttpResponse res  = new HttpResponse();

        req.setEndpoint(endpoint);
        req.setMethod(httpMethod);
        for(String key : headers.keySet()) {
            req.setHeader(key, headers.get(key));
        }
        
        try{
            res = http.send(req);
            logs.add(Logger.CreateLog(req.getBody().left(131072), res.getBody().left(131072), 'Callout', reqDescription, false, ''));
        } catch (Exception ex) {
            logs.add(Logger.CreateLog(req.getBody().left(131072), res.getBody().left(131072), 'Callout', reqDescription, true, ex.getMessage()));
        }

        return res;
    }

    private static List<String> addressesToSend(Id accountId) {
        List<String> addresses = new List<String>();
        
        if(accountId != null) {
            for(AccountContactRelation relation : [
                SELECT Id, Contact.Email
                  FROM AccountContactRelation
                 WHERE Roles INCLUDES ('Billing Contact') AND AccountId =: accountId
              ORDER BY CreatedDate
                 LIMIT 1]){
                    addresses.add(relation.Contact.Email);
            }
        }

        return addresses;
    }

    private static String buildAuthorizationHeader(String CBprivateKey) {
        Blob headerValue = Blob.valueOf(CBprivateKey);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);

        return authorizationHeader;
    }

    public class CBInvoiceWrapper{
        @InvocableVariable 
        public List<chargebeeapps__CB_Invoice__c> cbInvoiceList;
    }

    public class InvoicePDFWrapper {
        public String invoiceId;
        public String accountId;
        public String invoiceBody;
        public Blob invoiceBlob;
    }

    public class ChargebeeRetrieveInvoiceAsPDFResponse {
        public cls_download download;
    }

    public class cls_download {
        public String download_url;	
        public String object_type;
        public Integer valid_till;
    }

    public static ChargebeeRetrieveInvoiceAsPDFResponse parse(String json){
        return (ChargebeeRetrieveInvoiceAsPDFResponse) System.JSON.deserialize(json, ChargebeeRetrieveInvoiceAsPDFResponse.class);
    }

}