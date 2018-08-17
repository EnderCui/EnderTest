/*
*   @description Comunication Service
*/
public with sharing class ComunicationService
{

    public Message message = new Message();
    private static final String ORG_WIDE_INSUFFICIENT_PRIVILEGES = 'INSUFFICIENT_ACCESS_OR_READONLY';
    private static final String ORG_WIDE_UNVERIFIED = 'UNVERIFIED_SENDER_ADDRESS';
    public IClockService clockService = new ClockService();
   
    public void assign(Case newCase, String targetUser)
    {
        //check is username has value
        if (String.isEmpty(targetUser))
        {
            return;
        }

        //Assign case
        User[] resultUser =  [select Id from User where Name = :targetUser];
        Group[] resultQueue =  [select Id from Group where DeveloperName = :targetUser and Type = 'Queue' ];
        System.debug('resultQueue ' + resultQueue);
        if (resultUser.size() == 1)
        {
            newCase.OwnerId = resultUser[0].Id;
            update newCase;

        }
        else if (resultQueue.size() == 1)
        {
            newCase.OwnerId = resultQueue[0].Id;
            update newCase;
        }
        else
        {
            message.errorMessage = Label.NoUserOrQueue;
        }
    }

    public void postToChatter(String body,  List<AttachmentItem> attachments, Id caseId, Set<Id> optionalMentiones)
    {

        // Replace unrecognized tags by Chatter
        body = ChatterUtil.replaceUnrecognizedTags(body);

        String links = '';
        for (AttachmentItem inv : attachments)
        {
            if (inv.isChecked)
            {
                links += '<p>https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.FileDownload?file=' + inv.att.Id + '</p>';
            }
        }

        if (String.isNotEmpty(links))
        {
            body += '<p>Attached file(s): </p>' + links;
        }

        if (optionalMentiones.size() > 0)
        {
            body = '{' + String.join(new List<Id>(optionalMentiones), '}, {') + '} ' + body;
        }

        System.debug('!!!!!body: ' + body);
        ConnectApiHelper.postFeedItemWithRichText(Network.getNetworkId(), caseId, body);

        message.infoMessage = Label.ChatterMessagePosted;
    }

    public void postFileToChatter(String title, Blob content, Id caseId)
    {
        // Upload the file
        ContentVersion version = new ContentVersion();
        version.Title = title;
        version.PathOnClient = 'C:\\' + title + '.pdf';
        version.VersionData = content;
        insert version;

        // Insert a simple post
        FeedItem post = new FeedITem();
        post.body = title;
        post.ParentID = caseId;
        insert post;

        // Associate the file with the post
        FeedAttachment postAttachment = new FeedAttachment();
        postAttachment.FeedEntityId = post.id;
        postAttachment.Type = 'Content';
        postAttachment.RecordId = version.id;
        insert postAttachment;
    }

    public void assignCaseToUserOrQueue(String targetUser, Boolean disableAssign, List<AttachmentItem> attachments, Case newCase, String body)
    {
        Message message = new Message();

        if (String.isEmpty(targetUser))
        {
            message.errorMessage = Label.NoUserOrQueue;
        }

        try
        {
            if (!disableAssign)
            {
                assign(newCase, targetUser);
            }

            postToChatter(body, attachments, newCase.Id, new Set<Id>());

        }
        catch (Exception e)
        {
            message.errorMessage = Label.Error;
            System.debug(e);
        }
    }

    public void changeCaseStatus(Case newCase, String newStatus, Boolean withPersist)
    {
        if (String.isNotEmpty(newStatus))
        {
            newCase.Status = newStatus;

            if (withPersist)
            {
                update newCase;
            }
        }
    }

    public void setFollowUpDate(Case newCase, String durationStr, Boolean withPersist)
    {
        if (String.isNotEmpty(durationStr))
        {
            Decimal duration = Decimal.valueOf(durationStr);
            Integer days = Integer.valueOf(duration.round(System.RoundingMode.DOWN));
            Integer hours = Integer.valueOf(Math.ceil(24 * (duration - days)));

            Datetime myDateTime = clockService.now();
            //newCase.FollowUpDueDate__c = myDateTime
            //                             .addDays(days)
            //                             .addHours(hours);

            if (withPersist)
            {
                update newCase;
            }
        }
    }

    public void setContact(Case thisCase, Contact contact)
    {
        if (contact != null)
        {
            thisCase.Contact = contact;
            update thisCase;
        }
    }

    public Message sendEmail(String email, String cc, String bcc, String subject, String body, List<AttachmentItem> attachments)
    {

        System.debug('#### entering sendEmail with email: ' + email);

        String templateAsHtml = getTemplateAsHtml(CommunicationController.FORWARD_OTHERS);
        Message returnMessage = new Message();

        if (String.isEmpty(email))
        {
            returnMessage.errorMessage = Label.InvalidEmailAddress;

            return returnMessage;
        }

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = email.split(',');

        if (String.isNotEmpty(cc))
        {
            message.ccAddresses = cc.split(',');
        }

        if (String.isNotEmpty(bcc))
        {
            message.bccAddresses = bcc.split(',');
        }
        message.optOutPolicy = 'FILTER';
        message.subject = subject;
        final String footer = 'footer'; //String.isNotEmpty(newCase.CaseThreadID__c) ? newCase.CaseThreadID__c : '';

        if (templateAsHtml != null && String.isNotEmpty(templateAsHtml))
        {
            Map<String, String> varsMap = new Map<String, String>();
            varsMap.put('EMAIL_TEXT', body);
            varsMap.put('CURRENT_TIME', Datetime.now().format('MMM d, yyyy'));
            varsMap.put('EMAIL_FOOTER', footer);

            message.htmlBody = EmailHelper.mergeTemplate(varsMap, templateAsHtml);
        }
        else
        {
            message.htmlBody = '<html><head></head><body>' + body + '<br><br>' + footer + '</body></html>';
        }
        System.debug('#### before addAttachments');

        // Add Attachments
        List<Messaging.Emailfileattachment> emailAttachmentList = new List<Messaging.Emailfileattachment>();
        for (AttachmentItem ai : attachments)
        {
            Messaging.Emailfileattachment emailAttachment = new Messaging.Emailfileattachment();
            emailAttachment.setFileName(ai.att.Name);
            emailAttachment.setBody(ai.att.Body);
            emailAttachmentList.add(emailAttachment);
        }
        message.setFileAttachments(emailAttachmentList);
        String errMesg = EmailHelper.sendEmails(new List<Messaging.SingleEmailMessage> { message });
        System.debug('#### errorMessage: ' + errMesg);
        if (errMesg != null)
        {

            if (errMesg.contains(ORG_WIDE_INSUFFICIENT_PRIVILEGES))
            {
                errMesg = Label.OrgWideEmailAddressNotAllowed;
            }
            else if (errMesg.contains(ORG_WIDE_UNVERIFIED))
            {
                errMesg = Label.OrgWideEmailAddressUnverified;
            }

            returnMessage.errorMessage = errMesg;
        }
        else
        {
            returnMessage.infoMessage = Label.EmailSendMsg;

            //create also EmailMessage object
            EmailMessage em = new EmailMessage(
                CcAddress =  cc,
                BccAddress = bcc,
                ToAddress = email,
                HtmlBody = body
            );
            insert em;

        }

        return returnMessage;
    }

    public String getTemplateAsHtml(String page)
    {
        String template = null;

        EmailTemplateConfig__mdt[] rows = [select TemplateDeveloperName__c from EmailTemplateConfig__mdt where DeveloperName = :page];
        if (rows != null && rows.size() == 1)
        {
            EmailTemplate[] tmpls = [select Id from EmailTemplate where developername = :rows[0].TemplateDeveloperName__c];
            if (tmpls != null && tmpls.size() == 1)
            {
                template = Messaging.renderStoredEmailTemplate(tmpls[0].Id, null, null).HtmlBody;
            }
        }

        return template;
    }

}