/**
*   @description Wrapper class over 'TextBlock__c' and 'TextBlockItem__c' sobjects for related and potentially reusable logic.

*/
public with sharing class TextBlocksService 
{
    public static Set<String> getTextBlockItemBaseFieldsApis()
    {
        return new Set<String>{
            'TextBlock__r.TextBlockName__c', 'TextBlock__r.TextContent__c', 'TextBlock__c, Category__r.Name',
            'Category__c', 'TextBlock__r.ServiceCountry__c', 'TextBlock__r.Type__c', 'TextBlock__r.QuickCode__c',
            'TextBlock__r.AvailableForProfiles__c'
        };
    }

    /**
    *    @description Returns 'TextBlockItem__c' records by category, country code and language criteria.
    */
    public static List<TextBlockItem__c> getActiveCategoryAndCountryCodeRelatedTextBlockItemsByLng(Set<String> fields, String serviceCountryCode, Id lngId, Boolean includeWithoutLng)
    {
        Set<String> targetFields = getTextBlockItemBaseFieldsApis();
        targetFields.addAll(fields);
        targetFields.add('Id');

        String query = 'SELECT ';
        query += String.join(new List<String>(targetFields), ',');
        query += ' FROM TextBlockItem__c';
        query += ' WHERE Category__r.IsActive__c = true';
        if (String.isNotBlank(lngId))
        {
            query += ' AND ';
            if (includeWithoutLng != null && includeWithoutLng)
            {
                query += '(TextBlock__r.Language__c = NULL OR ';
            }
            query += 'TextBlock__r.Language__c =: lngId';
            query += includeWithoutLng != null && includeWithoutLng ? ')' : '';
        }
        query += ' LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        System.debug('++++++:query '+query);
        return (List<TextBlockItem__c>)Database.query(query);
    }
}