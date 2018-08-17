/**
*  @description Wrapper class over 'Attachment' sobjects for related and potentially reusable logic.

*/
public with sharing class AttachmentsService 
{
    /*
    *   @description US119, SCSI-1246. Returns record's attachments.
    */
    public static List<Attachment> getRecordRelatedAttachments(Id recordId, Boolean withBody)
    {
        if (String.isBlank(recordId))
        {
            return new List<Attachment>();
        }

        Integer queryLimit = Limits.getLimitQueryRows() - Limits.getQueryRows();
        String soql = 'SELECT Id, Name' + (withBody ? ',Body' : '') + ' FROM Attachment WHERE ParentId =: recordId ORDER BY LastModifiedDate DESC LIMIT: queryLimit';

        List<Attachment> results = Database.query(soql);

        if(results == null)
        {
            return new List<Attachment>();
        }

        return results;
    }

    /*
    *   @description US119, SCSI-1246. Returns case's and case related emails' attachments.
    */
    public static List<Attachment> getRelatedAttachments(String categoryName, Boolean withBody)
    {

        List<Attachment> caseRelatedAttachs = new List<Attachment>();

        Integer queryLimit = Limits.getLimitQueryRows() - Limits.getQueryRows();

        String soql = 'SELECT Id, Name' + (withBody ? ',Body' : '') + ' FROM Attachment WHERE ParentId IN (SELECT Id FROM Category__c WHERE Name =: categoryName) LIMIT: queryLimit';

        List<Attachment> caseEmailsRelatedAttachs = Database.query(soql);

        caseRelatedAttachs.addAll(caseEmailsRelatedAttachs);
        return caseRelatedAttachs;
    }

    /*
    *   @description US119, SCSI-1246. Wrapps attachments to be able to use them on UI with selection.
    */
    public static List<AttachmentItem> wrapAttachmentsForSelectionOnUI(List<Attachment> attachments)
    {
        List<AttachmentItem> result = new List<AttachmentItem>();
        for (Attachment attach : attachments)
        {
            result.add(
                new AttachmentItem(attach)
            );
        }
        return result;
    }
}