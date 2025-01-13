/**
* @author: Solved by Software, Co
*/

@isTest
public with sharing class ChargebeeCreateInvoiceResponseTest {
	static testMethod void testParse() {
		String json=		'{"invoice": {'+
		'    "id": "47111",'+
		'    "customer_id": "16BS9GTM8sLp51FpE",'+
		'    "recurring": false,'+
		'    "status": "payment_due",'+
		'    "price_type": "tax_exclusive",'+
		'    "date": 1667717583,'+
		'    "due_date": 1667717583,'+
		'    "net_term_days": 0,'+
		'    "exchange_rate": 1.0,'+
		'    "total": 300000,'+
		'    "amount_paid": 0,'+
		'    "amount_adjusted": 0,'+
		'    "write_off_amount": 0,'+
		'    "credits_applied": 0,'+
		'    "amount_due": 300000,'+
		'    "updated_at": 1667717583,'+
		'    "resource_version": 1667717583717,'+
		'    "deleted": false,'+
		'    "object": "invoice",'+
		'    "first_invoice": false,'+
		'    "amount_to_collect": 300000,'+
		'    "round_off_amount": 0,'+
		'    "has_advance_charges": false,'+
		'    "currency_code": "USD",'+
		'    "base_currency_code": "USD",'+
		'    "generated_at": 1667717583,'+
		'    "is_gifted": false,'+
		'    "term_finalized": true,'+
		'    "channel": "web",'+
		'    "tax": 0,'+
		'    "line_items": [{'+
		'        "id": "li_169loCTMO51UX7zid",'+
		'        "date_from": 1667707200,'+
		'        "date_to": 1667797199,'+
		'        "unit_amount": 300000,'+
		'        "quantity": 1,'+
		'        "amount": 300000,'+
		'        "pricing_model": "flat_fee",'+
		'        "is_taxed": false,'+
		'        "tax_amount": 0,'+
		'        "object": "line_item",'+
		'        "customer_id": "16BS9GTM8sLp51FpE",'+
		'        "description": "App & Brand Setup Fee",'+
		'        "entity_type": "charge_item_price",'+
		'        "entity_id": "App-Brand-Setup-Fee-USD",'+
		'        "metered": false,'+
		'        "tax_exempt_reason": "tax_not_configured",'+
		'        "discount_amount": 0,'+
		'        "item_level_discount_amount": 0'+
		'    }],'+
		'    "sub_total": 300000,'+
		'    "linked_payments": [],'+
		'    "applied_credits": [],'+
		'    "adjustment_credit_notes": [],'+
		'    "issued_credit_notes": [],'+
		'    "linked_orders": [],'+
		'    "dunning_attempts": [],'+
		'    "billing_address": {'+
		'        "first_name": "Chanida",'+
		'        "last_name": "Clarkston",'+
		'        "company": "Chanida Test Auto Sync",'+
		'        "validation_status": "not_validated",'+
		'        "object": "billing_address"'+
		'    }'+
		'}}'+
		'';
		ChargebeeCreateInvoiceResponse obj = ChargebeeCreateInvoiceResponse.parse(json);
		System.assert(obj != null);
	}
}