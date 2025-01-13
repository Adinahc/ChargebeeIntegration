/**
* @author: Solved by Software, Co
*/

@isTest
public without sharing class ChargebeeCreateSubscriptionResponseTest {
	static testMethod void testParse() {
		String json=		'{'+
		'    "subscription": {'+
		'        "id": "16BS9GTMNvAw07sku",'+
		'        "billing_period": 1,'+
		'        "billing_period_unit": "month",'+
		'        "customer_id": "Azz5afTMNtyOh7rFs",'+
		'        "status": "active",'+
		'        "current_term_start": 1667707200,'+
		'        "current_term_end": 1669784399,'+
		'        "next_billing_at": 1669784400,'+
		'        "created_at": 1667715236,'+
		'        "started_at": 1667707200,'+
		'        "activated_at": 1667707200,'+
		'        "updated_at": 1667715236,'+
		'        "has_scheduled_changes": false,'+
		'        "channel": "web",'+
		'        "resource_version": 1667715236853,'+
		'        "deleted": false,'+
		'        "object": "subscription",'+
		'        "currency_code": "USD",'+
		'        "subscription_items": ['+
		'            {'+
		'                "item_price_id": "Base-Platform-USD-Monthly",'+
		'                "item_type": "plan",'+
		'                "quantity": 1,'+
		'                "unit_price": 24900,'+
		'                "amount": 24900,'+
		'                "free_quantity": 0,'+
		'                "object": "subscription_item"'+
		'            }'+
		'        ],'+
		'        "due_invoices_count": 1,'+
		'        "due_since": 1667707200,'+
		'        "total_dues": 319920,'+
		'        "mrr": 0,'+
		'        "has_scheduled_advance_invoices": false,'+
		'        "override_relationship": false,'+
		'        "create_pending_invoices": false,'+
		'        "auto_close_invoices": true'+
		'    },'+
		'    "customer": {'+
		'        "id": "Azz5afTMNtyOh7rFs",'+
		'        "first_name": "John2",'+
		'        "last_name": "Lastname 1667714950",'+
		'        "company": "Company Name 1667714950",'+
		'        "auto_collection": "off",'+
		'        "net_term_days": 0,'+
		'        "allow_direct_debit": false,'+
		'        "created_at": 1667714950,'+
		'        "taxability": "taxable",'+
		'        "updated_at": 1667714950,'+
		'        "pii_cleared": "active",'+
		'        "channel": "web",'+
		'        "resource_version": 1667714950210,'+
		'        "deleted": false,'+
		'        "object": "customer",'+
		'        "billing_address": {'+
		'            "city": "Denver",'+
		'            "validation_status": "not_validated",'+
		'            "object": "billing_address"'+
		'        },'+
		'        "card_status": "no_card",'+
		'        "promotional_credits": 0,'+
		'        "refundable_credits": 0,'+
		'        "excess_payments": 0,'+
		'        "unbilled_charges": 0,'+
		'        "preferred_currency_code": "USD",'+
		'        "auto_close_invoices": true'+
		'    },'+
		'    "invoice": {'+
		'        "id": "47103",'+
		'        "customer_id": "Azz5afTMNtyOh7rFs",'+
		'        "subscription_id": "16BS9GTMNvAw07sku",'+
		'        "recurring": true,'+
		'        "status": "payment_due",'+
		'        "price_type": "tax_exclusive",'+
		'        "date": 1667707200,'+
		'        "due_date": 1667707200,'+
		'        "net_term_days": 0,'+
		'        "exchange_rate": 1.0,'+
		'        "total": 319920,'+
		'        "amount_paid": 0,'+
		'        "amount_adjusted": 0,'+
		'        "write_off_amount": 0,'+
		'        "credits_applied": 0,'+
		'        "amount_due": 319920,'+
		'        "updated_at": 1667715236,'+
		'        "resource_version": 1667715236838,'+
		'        "deleted": false,'+
		'        "object": "invoice",'+
		'        "first_invoice": true,'+
		'        "amount_to_collect": 319920,'+
		'        "round_off_amount": 0,'+
		'        "new_sales_amount": 319920,'+
		'        "has_advance_charges": false,'+
		'        "currency_code": "USD",'+
		'        "base_currency_code": "USD",'+
		'        "generated_at": 1667707200,'+
		'        "is_gifted": false,'+
		'        "term_finalized": true,'+
		'        "channel": "web",'+
		'        "tax": 0,'+
		'        "line_items": ['+
		'            {'+
		'                "id": "li_16BS9GTMNvAwa7skw",'+
		'                "date_from": 1667707200,'+
		'                "date_to": 1669784399,'+
		'                "unit_amount": 19920,'+
		'                "quantity": 1,'+
		'                "amount": 19920,'+
		'                "pricing_model": "per_unit",'+
		'                "is_taxed": false,'+
		'                "tax_amount": 0,'+
		'                "object": "line_item",'+
		'                "subscription_id": "16BS9GTMNvAw07sku",'+
		'                "customer_id": "Azz5afTMNtyOh7rFs",'+
		'                "description": "Base Platform - Prorated Charges",'+
		'                "entity_type": "plan_item_price",'+
		'                "entity_id": "Base-Platform-USD-Monthly",'+
		'                "metered": false,'+
		'                "tax_exempt_reason": "tax_not_configured",'+
		'                "discount_amount": 0,'+
		'                "item_level_discount_amount": 0'+
		'            },'+
		'            {'+
		'                "id": "li_16BS9GTMNvAwe7skx",'+
		'                "date_from": 1667707200,'+
		'                "date_to": 1667707200,'+
		'                "unit_amount": 300000,'+
		'                "quantity": 1,'+
		'                "amount": 300000,'+
		'                "pricing_model": "flat_fee",'+
		'                "is_taxed": false,'+
		'                "tax_amount": 0,'+
		'                "object": "line_item",'+
		'                "subscription_id": "16BS9GTMNvAw07sku",'+
		'                "customer_id": "Azz5afTMNtyOh7rFs",'+
		'                "description": "App & Brand Setup Fee",'+
		'                "entity_type": "charge_item_price",'+
		'                "entity_id": "App-Brand-Setup-Fee-USD",'+
		'                "metered": false,'+
		'                "tax_exempt_reason": "tax_not_configured",'+
		'                "discount_amount": 0,'+
		'                "item_level_discount_amount": 0'+
		'            }'+
		'        ],'+
		'        "sub_total": 319920,'+
		'        "linked_payments": [],'+
		'        "applied_credits": [],'+
		'        "adjustment_credit_notes": [],'+
		'        "issued_credit_notes": [],'+
		'        "linked_orders": [],'+
		'        "dunning_attempts": [],'+
		'        "billing_address": {'+
		'            "first_name": "John2",'+
		'            "last_name": "Lastname 1667714950",'+
		'            "company": "Company Name 1667714950",'+
		'            "city": "Denver",'+
		'            "validation_status": "not_validated",'+
		'            "object": "billing_address"'+
		'        }'+
		'    }'+
		'}';
		ChargebeeCreateSubscriptionResponse obj = ChargebeeCreateSubscriptionResponse.parse(json);
		System.assert(obj != null);
	}
}