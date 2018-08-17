/**
    Wrapper for MessageInApproval__c sObject.

    @author mto
    @copyright PARX
*/
public with sharing class MessageInApprovalWrapper {

    private MessageInApproval__c mia;
    private static final String CR = '<br/>';
    private static final String SPACE = ' ';

    public MessageInApprovalWrapper(MessageInApproval__c mia)
    {
        this.mia = mia;
    }

    public override String toString()
    {
        return '<h3 style="display: inline-block;">' + Label.EmailFieldSubject + ': </h3>' + StringUtils.default(mia.Subject__c) +
                '<h3>' + Label.EmailFieldBody + ': </h3>' + '<p>' + StringUtils.default(mia.TextContent__c) + '</p>' + CR +
                '<h3>' + Label.EmailFieldFrom + ': </h3>' + (mia.From__c == null ? UserInfo.getUserEmail() : mia.From__c);
    }
}