/**
*   @description Wrapper class over 'DraftTemplate__c' sobject for related and potentially reusable logic.

*/
public with sharing class DraftTemplatesService 
{
    public static final String CONTEXT_SOBJECT_API = 'DraftTemplate__c';

    public static Set<String> getBaseFieldsApis()
    {
        //return new Set<String>{'Name', 'TextContent__c', 'ServiceCountry__c', 'Language__c'};
        return new Set<String>{'Name', 'TextContent__c', 'Language__c'};
    }

    /**
    *    @description Returns 'DraftTemplate__c' records by case and language criteria.
    */
    public static List<DraftTemplate__c> getRelatedDraftTemplatesByLng(Set<String> fields, Id lngId, Boolean includeWithoutLng)
    {
        Set<String> targetFields = getBaseFieldsApis();
        targetFields.addAll(fields);
        targetFields.add('Id');

        String query = 'SELECT ';
        query += String.join(new List<String>(targetFields), ',');
        query += ' FROM ' + CONTEXT_SOBJECT_API;
        //query += ' WHERE Case__c =: caseId';
        if (String.isNotBlank(lngId))
        {
            query += ' AND ';
            if (includeWithoutLng != null && includeWithoutLng)
            {
                query += '(Language__c = NULL OR ';
            }
            query += 'Language__c =: lngId';
            query += includeWithoutLng != null && includeWithoutLng ? ')' : '';
        }
        query += ' LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        System.debug('++++++ draftTemplate query: ' + query);
        return (List<DraftTemplate__c>)Database.query(query);
    }

    /**
    *    @description Updates 'DraftTemplate__c' record witn new contact or language.
    */
    public static void updateRecord(String draftItemId, String content, Id lngId)
    {
        List<DraftTemplate__c> drafts = [select Id, TextContent__c from DraftTemplate__c where Id = :draftItemId];
        if (drafts.size() > 0)
        {
            drafts[0].TextContent__c = content;
            drafts[0].Language__c = lngId;
            update drafts[0];
        }
    }

    /**
    *    @description Creates 'DraftTemplate__c' record.
    */
    public static void createRecord(String documentName, String content, String channel)
    {
        System.debug('++++++:documentName' + documentName);
        System.debug('++++++:content' + content);
        System.debug('++++++:channel' + channel);
        insert new DraftTemplate__c
        (
            Name = documentName,
            TextContent__c = content,
            Channel__c = channel
        );
    }
}