/*
*   @description MessageInApprovalAfterHandler
*
*   @author mto
*   @copyright PARX
*/
public with sharing class MessageInApprovalAfterHandler implements TriggerTemplateV2.AfterTriggerHandler {
    
    public void onAfterInsert (List<sObject> newList, Map<Id, sObject> newMap)
    {
        TriggerTemplateV2.setupUnitTest();
        for(sObject obj : newList)
        {
            MessageInApproval__c mia = (MessageInApproval__c) obj;
            setWaitingForApproval(mia);
        }

    }
    
    public void onAfterUpdate (List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap)
    {
        TriggerTemplateV2.setupUnitTest();
        for(sObject obj : newList)
        {
            MessageInApproval__c mia = (MessageInApproval__c) obj;
            setWaitingForApproval(mia);
        }
    }

    /**
    *    @description DE32. Moved soql from for loop.
    */

    
    public void onAfterDelete (List<sObject> oldList, Map<Id, sObject> oldMap)
    {

    }

    public void onAfterUndelete (List<sObject> newList, Map<Id, sObject> newMap)
    {

    }

    @TestVisible
    private static void setWaitingForApproval(MessageInApproval__c mia)
    {
        if(mia.Status__c == 'Approved')
        {
            Message message = sendEmail(mia);

            if(message.errorMessage != null)
            {
                mia.addError(message.errorMessage);
                return;
            }
        }
    }

    private static Message sendEmail(MessageInApproval__c messageInApproval)
    {
        String fromAddressId = '';
        if(String.isNotEmpty(messageInApproval.From__c))
        {
            OrgWideEmailAddress[] fromAddresses = [select Id, Address from OrgWideEmailAddress where Address = :messageInApproval.From__c];
            if(fromAddresses != null && fromAddresses.size() == 1)
            {
                fromAddressId = fromAddresses[0].Id;
            }
        }

        List<AttachmentItem> attachments = AttachmentsService.wrapAttachmentsForSelectionOnUI(AttachmentsService.getRecordRelatedAttachments(messageInApproval.Id, true));

        ComunicationService communicationService = new ComunicationService();

        return communicationService.sendEmail(
                messageInApproval.To__c,
                messageInApproval.Cc__c,
                messageInApproval.Bcc__c,
                messageInApproval.Subject__c,
                messageInApproval.TextContent__c,
                attachments
        );
    }

}