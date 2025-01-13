global class CreateCBInvoiceAndSubscriptionIvocCopy {
    public static String oppId;
    public static CB_Hierarchy_Created__e CBHierarchyRecord;
    

    @InvocableMethod(label='Create CB Invoice And Subscription')
    public static void createCBInvoiceAndSubscription (List<CBHierarchyEvent> CBHierarchyEvents) {
        oppId             = CBHierarchyEvents[0].oppId;
        CBHierarchyRecord = CBHierarchyEvents[0].CBHierarchyRecord;
        System.debug('CreateCBInvoiceAndSubscriptionInvocable | oppId.: ' + oppId);
        System.debug('CreateCBInvoiceAndSubscriptionInvocable | CBHierarchyRecord.: ' + CBHierarchyRecord);
        run();
    }
    
    public static void run() {
        System.debug('CreateCBInvoiceAndSubscriptionInvocable |RUN()');
        CreateCBInvoiceAndSubscriptionBatchCopy batch = new CreateCBInvoiceAndSubscriptionBatchCopy(oppId, CBHierarchyRecord);
        Database.executeBatch(batch, 20);
    }

    global class CBHierarchyEvent {
        @InvocableVariable
        global Id oppId;
        @InvocableVariable
        global CB_Hierarchy_Created__e CBHierarchyRecord;

    }
}