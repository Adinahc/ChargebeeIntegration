/**
* @author: Solved by Software, Co
*/

global class ChargebeeSubscriptionInvocable {
    @InvocableMethod(Label='Create/Update Subscription') 
    public static void CreateSubscription(List<ChargebeeInvocableRequest> reqs) {
        Chargebee_Setting__mdt chargebeeSetting = ChargebeeHierarchyInvocable.GetCBSetting();
        System.debug('CC: ' + reqs[0]);
        System.debug('CC: ' + chargebeeSetting.Create_Subscription_Url__c);
        System.debug('CC: ' + reqs[0].assets);
        List<Asset> ass = new List<Asset>();
        /*List<Asset> ass = [SELECT Id, Product2Id, Opportunity_Product__c, Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.Id,Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.chargebeeapps__Product__r.chargebeeapps__Product_Type__c,
                                Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.chargebeeapps__Price__c,Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.chargebeeapps__External_Id__c, Opportunity_Product__r.Quantity, Opportunity_Product__r.chargebeeapps__Addon_Event__c,
                                Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.CB_Product_Type__c, Opportunity_Product__r.Opportunity.Contract_Term_months__c, Opportunity_Product__r.Opportunity.Chargebee_Subscription_Start_Date__c, 
                                Opportunity_Product__r.chargebeeapps__Service_Period__c, Opportunity_Product__r.UnitPrice, Opportunity_Product__r.TotalPrice, Opportunity_Product__r.Net_Unit_Price__c
                                FROM Asset
                                WHERE AccountId = :reqs[0].childId AND (Product2.chargebeeapps__Product_Type__c = 'ADDON' OR Product2.chargebeeapps__Product_Type__c = 'PLAN')];
        if(Test.isRunningTest()) {
            ass = [SELECT Id, Product2Id, Opportunity_Product__c, Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.Id,Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.chargebeeapps__Product__r.chargebeeapps__Product_Type__c,
                    Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.chargebeeapps__Price__c,Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.chargebeeapps__External_Id__c, Opportunity_Product__r.Quantity, Opportunity_Product__r.chargebeeapps__Addon_Event__c,
                    Opportunity_Product__r.chargebeeapps__CB_Item_Price__r.CB_Product_Type__c, Opportunity_Product__r.Opportunity.Contract_Term_months__c, Opportunity_Product__r.Opportunity.Chargebee_Subscription_Start_Date__c, 
                    Opportunity_Product__r.chargebeeapps__Service_Period__c, Opportunity_Product__r.UnitPrice, Opportunity_Product__r.TotalPrice, Opportunity_Product__r.Net_Unit_Price__c
                    FROM Asset];
        }*/
        for(ChargebeeInvocableRequest req : reqs) {
            if(req.assets != null) {
                ass = req.assets;
            }
            if(ass.size() > 0) {
                string action = 'create';
                if(String.isNotBlank(req.action) && req.action.toLowerCase() == 'update') {
                    action = 'update';
                }
                System.debug('  : ' + action);
                string body = buildSubscriptionPayload(req.cbId, req.parentId, ass, chargebeeSetting, action, req.opporutnityType, req.cbSubs);
                System.debug(body);
                String url = '';
                if(action == 'update') {
                    url = Test.isRunningTest() ? 'Test' : chargebeeSetting.Update_Subscription_Url__c.replace('{{SubscriptionId}}', req.cbCustomId);
                        ChargebeeInvoiceInvocable.CallCB(chargebeeSetting.Private_Key__c, 
                        req.childId, 
                        req.oppId, 
                        body, 
                        url, 
                        req.childId, 
                        'Update Subscription for ' + req.oppId + ': ' + req.childId + ' ' + url, 
                        'Subscription');
                } else {
                    url = Test.isRunningTest() ? 'Test' : chargebeeSetting.Create_Subscription_Url__c.replace('{{CustomerId}}', req.cbId);
                    ChargebeeInvoiceInvocable.CallCB(chargebeeSetting.Private_Key__c, 
                                                 req.childId, 
                                                 req.oppId, 
                                                 body, 
                                                 url, 
                                                 req.childId, 
                                                 'Create Subscription for ' + req.oppId + ': ' + req.childId, 
                                                 'Subscription');
                }
                
            }
        }


    }
    public static String buildSubscriptionPayload(String cbId, String parentId, List<Asset> assets, Chargebee_Setting__mdt chargebeeSetting, string action, string opportunityType, List<chargebeeapps__CB_Subscription__c> cbSubs) {
        System.debug('CC Action: ' + action);
        Date startDate = assets[0].CB_Subscription_Start_Date__c;
        String startDateClause = '';
        if(startDate == null) {
            integer defaultDelayStartDays = chargebeeSetting.Days_to_delay_location_sub_start__c != null ? Integer.valueOf(chargebeeSetting.Days_to_delay_location_sub_start__c) : 365;
            startDate = System.today().addDays(defaultDelayStartDays);
        }
        if(action == 'update' && String.isNotBlank(cbId)) {
            if(cbSubs == null) {
                List<chargebeeapps__CB_Subscription__c> subs = [SELECT Id, chargebeeapps__Subscription_Started_At__c
                                                                    FROM chargebeeapps__CB_Subscription__c
                                                                    WHERE chargebeeapps__CB_Subscription_Id__c = :cbId];
                if(subs.size() > 0) {
                    chargebeeapps__CB_Subscription__c sub = subs[0];
                    if(sub.chargebeeapps__Subscription_Started_At__c != null && sub.chargebeeapps__Subscription_Started_At__c < System.today()) {
                        startDateClause = 'start_date=0';
                    }
                }
            } else {
                for(chargebeeapps__CB_Subscription__c cbSub : cbSubs) {
                    if(cbSub.chargebeeapps__CB_Subscription_Id__c == cbId) {
                        chargebeeapps__CB_Subscription__c sub = cbSub;
                        if(sub.chargebeeapps__Subscription_Started_At__c != null && sub.chargebeeapps__Subscription_Started_At__c < System.today()) {
                            startDateClause = 'start_date=0';
                        }
                    }
                }
            }
        }
        if(startDateClause == '') {
            startDateClause = 'start_date=' + String.valueOf((datetime.newInstance(startDate, Time.newInstance(23,59,59,59))).getTime()).left(10) + '&';
        }
        String body = startDateClause;
        if(action != 'update') {
            body += 'billing_cycles=' + String.valueOf(Integer.valueOf(assets[0].CB_Contract_Term_Months__c)) + '&';
            body += 'cf_salesforce_opportunity_id=' + assets[0].Opportunity__c + '&';
        }
        integer i = 0;
        for(Asset ass : assets) {
            String qty = String.valueOf(integer.valueOf(ass.Quantity));
            if(parentId != null) {
                qty = '1';
            }
            body += 'subscription_items[item_price_id][' + String.valueOf(i) + ']=' + ass.CB_External_Id__c + '&';
            if(ass.CB_Product_Type__c == 'PLAN' || 	ass.CB_Product_Type__c == 'CHARGE'
            ) {
                body += 'subscription_items[quantity][' + String.valueOf(i) + ']=' + qty + '&';
            }
            if(String.isNotBlank(ass.CB_Add_On_Event__c)) {
                body += 'subscription_items[charge_on_option][' + String.valueOf(i) + ']=on_event&';                
                body += 'subscription_items[charge_on_event][' + String.valueOf(i) + ']=' + ass.CB_Add_On_Event__c + '&';                
            }
            if(ass.CB_Service_Period__c != null) {
                body += 'subscription_items[net_term_days][' + String.valueOf(i) + ']=' + ass.CB_Service_Period__c + '&';                           
            }
            if(ass.Pricing_Model__c != 'Stairstep') {
                if(action != 'update') {
                    body += 'subscription_items[unit_price][' + String.valueOf(i) + ']=' + Integer.valueOf(ass.CB_Net_Unit_Price__c * 100) + '&';                
                    body += 'subscription_items[amount][' + String.valueOf(i) + ']=' + Integer.valueOf(ass.CB_Net_Unit_Price__c* 100) + '&';   
                } else {
                    body += 'subscription_items[unit_price][' + String.valueOf(i) + ']=' + Integer.valueOf(ass.Price * 100) + '&';                
                    body += 'subscription_items[amount][' + String.valueOf(i) + ']=' + Integer.valueOf(ass.Price* 100) + '&';   
                }     
            }        
            body += 'subscription_items[item_type][' + String.valueOf(i) + ']=' + ass.CB_Product_Type__c + '&';                
            i++;
        }
        if(action == 'update' && opportunityType != 'Add-On') {
            body += '&replace_items_list=true';
        }
        if(body != null) {
            body = body.replace('&&','&');
        }
        System.debug('buildSubscriptionPayload: ' + body);
        return body;
    }

}