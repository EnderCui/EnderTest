/*
*   @description MessageInApprovalTrigger
*/
trigger MessageInApprovalTrigger on MessageInApproval__c (before insert, before update, after insert, after update)
{
	new TriggerTemplateV2.TriggerManager(null, new MessageInApprovalAfterHandler()).runHandlers();
}