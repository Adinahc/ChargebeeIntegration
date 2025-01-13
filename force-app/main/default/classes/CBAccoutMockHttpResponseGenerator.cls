/**
* @author: Solved by Software, Co
*/

global class CBAccoutMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"customer": { "id": "Azyh7dU6xPBRE2xiL", "company": "CC Corp Test Location #27 (Virtual or Catering)", "auto_collection": "off", "net_term_days": 0, "allow_direct_debit": true, "created_at": 1710381670, "taxability": "taxable", "updated_at": 1710381681, "pii_cleared": "active", "channel": "web", "resource_version": 1710381681167, "deleted": false, "object": "customer", "card_status": "no_card", "relationship": { "parent_id": "16BQJ5U6x4RCb2rFn", "payment_owner_id": "16BQJ5U6x4RCb2rFn", "invoice_owner_id": "16BQJ5U6x4RCb2rFn", "root_id": "16BQJ5U6x4RCb2rFn" }, "use_default_hierarchy_settings": true, "parent_account_access": { "portal_edit_child_subscriptions": "yes", "portal_download_child_invoices": "yes", "send_subscription_emails": true, "send_payment_emails": true, "send_invoice_emails": true }, "child_account_access": { "portal_edit_subscriptions": "yes", "portal_download_invoices": "view_only", "send_subscription_emails": true, "send_payment_emails": true, "send_invoice_emails": true }, "promotional_credits": 0, "refundable_credits": 0, "excess_payments": 0, "unbilled_charges": 0, "preferred_currency_code": "USD", "mrr": 0, "auto_close_invoices": true, "cf_account_salesforce_id": "001O900000HaFN1IAN" }}');
        res.setStatusCode(200);
        return res;
    }
}