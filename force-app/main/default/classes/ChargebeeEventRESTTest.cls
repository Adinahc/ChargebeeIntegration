/**
* @author: Solved by Software, Co
*/

@isTest
public with sharing class ChargebeeEventRESTTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Test',
            chargebeeapps__CB_Id__c = 'Test',
            Type = 'Customer'
        );
        insert acc;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity', 
            StageName = 'Prospect', 
            CloseDate = Date.today()
        );
        insert opp;

        CB_Item__c item = new CB_Item__c();
        item.Account__c = acc.Id;
        item.Opportunity__c = opp.Id;
        item.CB_Item_Id__c = '56307';
        insert item;
    }
    @isTest 
    public static void RESTTest() {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/services/apexrest/ChargebeeEvent/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueOf('{"id":"ev_16A4kBU5f1nWtvvQ","occurred_at":1709193990,"source":"scheduled_job","object":"event","api_version":"v2","content":{"transaction":{"id":"txn_16A4kBU5f1nU9vuy","customer_id":"6olPtTUnkDRW2fr","gateway_account_id":"gw_1mk51SrQnAl77d3TM","payment_source_id":"pm_AzZTXYTUnlAPN2ZN","payment_method":"card","gateway":"chargebee","type":"payment","date":1709193990,"exchange_rate":1.0,"amount":49800,"id_at_gateway":"cb_16A4kBU5f1nV8vv6","status":"success","updated_at":1709193990,"resource_version":1709193990175,"deleted":false,"object":"transaction","masked_card_number":"************1111","currency_code":"USD","base_currency_code":"USD","amount_unused":0,"linked_invoices":[{"invoice_id":"56307","applied_amount":49800,"applied_at":1709193990,"invoice_date":1709193898,"invoice_total":49800,"invoice_status":"paid"}],"linked_refunds":[],"initiator_type":"merchant","three_d_secure":false},"invoice":{"id":"56307","customer_id":"6olPtTUnkDRW2fr","recurring":true,"status":"paid","price_type":"tax_exclusive","date":1709193898,"due_date":1709193898,"net_term_days":0,"exchange_rate":1.0,"total":49800,"amount_paid":49800,"amount_adjusted":0,"write_off_amount":0,"credits_applied":0,"amount_due":0,"paid_at":1709193990,"updated_at":1709193990,"resource_version":1709193990178,"deleted":false,"object":"invoice","first_invoice":false,"amount_to_collect":0,"round_off_amount":0,"has_advance_charges":false,"currency_code":"USD","base_currency_code":"USD","generated_at":1709193898,"is_gifted":false,"term_finalized":true,"channel":"web","payment_owner":"6olPtTUnkDRW2fr","tax":0,"line_items":[{"id":"li_16CS5IU5f0Vg02P8I","date_from":1709193600,"date_to":1711868399,"unit_amount":24900,"quantity":1,"amount":24900,"pricing_model":"per_unit","is_taxed":false,"tax_amount":0,"object":"line_item","subscription_id":"16CM2ZTUnoelN2hz","customer_id":"16CM2ZTUnoNmh2ha","description":"Full Platform","entity_type":"plan_item_price","entity_id":"Full-Platform-USD-Monthly","metered":false,"tax_exempt_reason":"tax_not_configured","discount_amount":0,"item_level_discount_amount":0},{"id":"li_16CS5IU5f0WF42PEk","date_from":1709193600,"date_to":1711868399,"unit_amount":24900,"quantity":1,"amount":24900,"pricing_model":"per_unit","is_taxed":false,"tax_amount":0,"object":"line_item","subscription_id":"6olPtTUnosNk2nm","customer_id":"16CM2ZTUnmat32e6","description":"Base Platform","entity_type":"plan_item_price","entity_id":"Base-Platform-USD-Monthly","metered":false,"tax_exempt_reason":"tax_not_configured","discount_amount":0,"item_level_discount_amount":0}],"sub_total":49800,"linked_payments":[{"txn_id":"txn_16A4kBU5f1nU9vuy","applied_amount":49800,"applied_at":1709193990,"txn_status":"success","txn_date":1709193990,"txn_amount":49800}],"applied_credits":[],"adjustment_credit_notes":[],"issued_credit_notes":[],"linked_orders":[],"dunning_attempts":[]},"customer":{"id":"6olPtTUnkDRW2fr","email":"srujin@test.com","auto_collection":"on","net_term_days":0,"allow_direct_debit":false,"created_at":1675425872,"taxability":"taxable","updated_at":1675426716,"pii_cleared":"active","channel":"web","resource_version":1675426716849,"deleted":false,"object":"customer","card_status":"valid","relationship":{"payment_owner_id":"6olPtTUnkDRW2fr","invoice_owner_id":"6olPtTUnkDRW2fr","root_id":"6olPtTUnkDRW2fr"},"use_default_hierarchy_settings":true,"parent_account_access":{"portal_edit_child_subscriptions":"yes","portal_download_child_invoices":"yes","send_subscription_emails":true,"send_payment_emails":true,"send_invoice_emails":true},"child_account_access":{"portal_edit_subscriptions":"yes","portal_download_invoices":"view_only","send_subscription_emails":true,"send_payment_emails":true,"send_invoice_emails":true},"promotional_credits":0,"refundable_credits":0,"excess_payments":0,"unbilled_charges":0,"preferred_currency_code":"USD","mrr":0,"primary_payment_source_id":"pm_AzZTXYTUnlAPN2ZN","payment_method":{"object":"payment_method","type":"card","reference_id":"tok_AzZTXYTUnlAPA2ZM","gateway":"chargebee","gateway_account_id":"gw_1mk51SrQnAl77d3TM","status":"valid"},"auto_close_invoices":true}},"event_type":"payment_succeeded","webhook_status":"not_configured","webhooks":[{"id":"whv2_AzZj9JTVy6MOT22o2","webhook_status":"scheduled","object":"webhook"},{"id":"whv2_AzyhCKU3u4OG3EXC","webhook_status":"scheduled","object":"webhook"}]}');
        //Act
        Test.startTest();
        ChargebeeEventREST.doPosT();
        Test.stopTest();
      
    }
}