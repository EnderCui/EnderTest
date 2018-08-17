/**
*   @description General utility functionality.

*/
global with sharing class Utils
{
    /**
    *    @description Merges several lists into one.
    */
    public static List<Sobject> mergeSobjectsLists(List<List<Sobject>> sobjectsList)
    {
        List<Sobject> result = new List<Sobject>();
        while (sobjectsList.size() > 0)
        {
            for (Integer i = sobjectsList.size() - 1; i >= 0; i--)
            {
                List<Sobject> sobjects = sobjectsList.get(i);
                if (sobjects.size() == 0)
                {
                    sobjectsList.remove(i);
                }
                else
                {
                    Sobject sobj = sobjects.remove(0);
                    result.add(sobj);
                }
            }
        }

        return result;
    }

    /**
    *    @description Generates a random string.
    */
    public static String generateRandomString(Integer len)
    {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len)
        {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx + 1);
        }
        return randStr;
    }

    /**
    *    @description Transform gmt now into local now.
    */
    public static Datetime localNow()
    {
        Datetime current = System.now();
        Date currDate = current.date();
        Time currTime = current.time();
        return Datetime.newInstance(currDate, currTime);
    }

    /*
        Get Id set of parent object by field.
    */
    public static Set<Id> getParentIdSet(String parentField, List<sObject> objectsList)
    {
        Set<Id> parentIds = new Set<Id>();
        for (sObject obj : objectsList)
        {
            parentIds.add((Id)obj.get(parentField));
        }
        parentIds.remove(null);
        return parentIds;
    }

    /**
    *   @description  Makes chunks from a list, implemented within SCSI-922, US78.
    */
    public static List<List<Object>> splitList(List<Object> elements, Integer splitSize)
    {
        List<List<Object>> result = new List<List<Object>>();
        Integer numberOfRecords = elements.size();
        Boolean isParametersValid = !(elements == null || elements.size() == 0 || splitSize == null || splitSize < 0);

        if (isParametersValid)
        {
            Integer numberOfChunks;
            if (Math.mod(numberOfRecords, splitSize) > 0)
            {
                numberOfChunks = Math.round(numberOfRecords / splitSize) + 1;
            }
            else
            {
                numberOfChunks = Math.round(numberOfRecords / splitSize);
            }
            for (Integer i = 1; i <= numberOfChunks; i++)
            {
                List<Object> subResult = new List<Object>();
                for (Integer j = splitSize * (i - 1); j < numberOfRecords && j < splitSize * i; j++)
                {
                    subResult.add(elements.get(j));
                }
                result.add(subResult);
            }
        }

        return result;
    }

    /**
     * @description Converts list of records to map with key as specified field.
     */
    public static Map<Object, SObject> convertToMap(List<SObject> records, String keyFieldName)
    {
        Map<Object, SObject> recordsMap = new Map<Object, SObject>();
        for ( SObject record : records )
        {
            recordsMap.put(record.get(keyFieldName), record);
        }
        return recordsMap;
    }

    /**
     * @description Returns set of strings specified field.
     */
    public static Set<String> getSpecifieldStringSet(List<SObject> records, String specifiedField)
    {
        Set<String> valuesSet = new Set<String>();

        for ( SObject record : records )
        {
            String value = (String)record.get(specifiedField);
            if (value != null && String.isNotBlank(value))
            {
                valuesSet.add(value);
            }
        }
        return valuesSet;
    }
}