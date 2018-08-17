//!!!!Without sharing is important.
public without sharing class AsyncDmlOperationHandler implements Queueable
{   

    private List<Sobject> records;
    private String dmlOperation;
    private Boolean disableTriggers;

    /**
    *    @description 
    */
    public AsyncDmlOperationHandler(List<Sobject> records, String dmlOperation, Boolean disableTriggers)
    {
        this.records = records;
        this.dmlOperation = dmlOperation;
        this.disableTriggers = disableTriggers;
    }

    /**
    *    @description Launch batch for address records update
    */
    public void execute(QueueableContext context) 
    {
        TriggerTemplateV2.allTriggersDisabled = this.disableTriggers;
        if (this.dmlOperation == 'upsert')
        {
            DatabaseUtils.executeCustomUpsert(this.records);
        } else if (this.dmlOperation == 'delete')
        {
            delete records;
        } else if (this.dmlOperation == 'insert')
        {
            insert records;
        } else
        {
            update records;
        }
        TriggerTemplateV2.allTriggersDisabled = TriggerTemplateV2.allTriggersDisabled ? !TriggerTemplateV2.allTriggersDisabled : TriggerTemplateV2.allTriggersDisabled;
    }
}