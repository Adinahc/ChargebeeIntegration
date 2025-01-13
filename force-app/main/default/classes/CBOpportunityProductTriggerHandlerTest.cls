/**
* @author: Solved by Software, Co
*/

@isTest
public with sharing class CBOpportunityProductTriggerHandlerTest {
    @isTest
    public static void TestCreateCBOpportunityProduct() {
        RecordType recTypeCorporateClient = [SELECT id FROM recordType WHERE DeveloperName='Concept_Logo'];

        //Parent Account (Corporate Client Record Type)
        Account accCorporateClient = new Account(Name='Test Corporate Client',RecordTypeId=recTypeCorporateClient.Id, Sync_to_Chargebee__c=true);
        insert accCorporateClient;

        Vendor__c ven = new Vendor__c();
        ven.Active__c = true;
        ven.POS__c = true;
        insert ven;
        
        Opportunity opp = new Opportunity(Name='Test Opportunity',CloseDate=System.today(),StageName='Prospect',LeadSource='Paid', AccountId=accCorporateClient.Id);
        opp.POS__c = ven.Id;
        insert opp;

        Product2 productObj = new Product2(Name='Test Product 1',IsActive=true, ProductCode='TESTPROD1',StockKeepingUnit='TEST001',chargebeeapps__Product_Type__c='PLAN');
        insert productObj;

        PricebookEntry priceBookEntryObj = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=productObj.Id, UnitPrice=10, IsActive=true);
        insert priceBookEntryObj;

        chargebeeapps__CB_Item_Price__c cbItem = new chargebeeapps__CB_Item_Price__c ();
        cbItem.Name = 'Full Platform USD Monthly';
        //cbItem.CurrencyIsoCode = 'USD';
        cbItem.chargebeeapps__External_Id__c = 'Full-Platform-USD-Monthly';
        cbItem.chargebeeapps__Free_Quantity__c = 0;
        cbItem.chargebeeapps__Period_Unit__c = 'MONTH';
        cbItem.chargebeeapps__Period__c = 1;
        cbItem.chargebeeapps__Price_Book__c =  Test.getStandardPricebookId();
        cbItem.chargebeeapps__Price__c = 50;
        cbItem.chargebeeapps__Pricing_Model__c = 'PER_UNIT';
        cbItem.chargebeeapps__Product__c =  productObj.Id;
        cbItem.chargebeeapps__Resource_Version__c = 1666282532;
        cbItem.chargebeeapps__Status__c = 'ACTIVE';
        insert cbItem;
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, Quantity=1,UnitPrice=5,chargebeeapps__CB_Item_Price__c=cbItem.Id, PricebookEntryId = priceBookEntryObj.Id);
        insert oli;

        chargebeeapps__CB_Opportunity_Product__c item = new chargebeeapps__CB_Opportunity_Product__c();
        item.chargebeeapps__Opportunity__c = opp.Id;
        item.chargebeeapps__CB_Item_Price__c =  cbItem.Id;
        item.chargebeeapps__Product__c = productObj.Id;
        item.chargebeeapps__Quantity__c = 1;
        item.chargebeeapps__Subtotal__c = 20;
        insert item;

        item.chargebeeapps__Quantity__c = 2;
        update item;

        delete item;

        List<OpportunityLineItem> oppItems = [SELECT Id, CB_Opportunity_Product__c, UnitPrice
                                                FROM OpportunityLineItem];
        update oppItems;
        delete oppItems;
        
    }
}