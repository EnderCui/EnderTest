/**
    Utility class for sObject field introspection.

*/
public with sharing class FieldUtils {

    public static Map<String, String> polymorphicCastTypes = new Map<String, String>();
    static
    {
        polymorphicCastTypes.put('owner', 'User');
    }

    /*
    *   @Description Validate input values.
    */
    public static void validateInputValues (TextBlock__c tb, Set<String> columnList)
    {
        for(String column : columnList)
        {
            if(String.isNotEmpty(column))
            {
                column = String.escapeSingleQuotes(column);
                System.debug('validating column: ' + column);

                String errorMessage = FieldUtils.validateCaseField(column);
    
                if(String.isNotEmpty(errorMessage))
                {
                    tb.TextContent__c.addError(Label.InvalidfieldError + ' ' + column + ' ' + Label.LabelFor + ' Case');
                }
            }
        }
    }

    /*
    * Gets a String Case field using single field name or dot notation.
    *
    * Ignores the 'Case' prefix
    */
    public static String getFieldValueString(sObject obj, String fieldApiName)
    {
        return defaultString(getFieldValue2(obj, fieldApiName));
    }

    /*
    * Gets a Date Case field using single field name or dot notation.
    *
    * Ignores the 'Case' prefix
    */
    public static String getFieldValueDate(sObject obj, String fieldApiName)
    {
        return defaultDate(getFieldValue2(obj, fieldApiName));
    }

        /*
    * Gets a DateTime Case field using single field name or dot notation.
    *
    * Ignores the 'Case' prefix
    */
    public static String getFieldValueDateTime(sObject obj, String fieldApiName)
    {
        return defaultDateTime(getFieldValue2(obj, fieldApiName));
    }

    /*
    * Gets a Number Case field using single field name or dot notation.
    *
    * Ignores the 'Case' prefix
    */
    public static Double getFieldValueDouble(sObject obj, String fieldApiName)
    {
        return defaultDouble(getFieldValue2(obj, fieldApiName));
    }

    /*
    * Gets a Number Case field using single field name or dot notation.
    *
    * Ignores the 'Case' prefix
    */
    public static Decimal getFieldValueInteger(sObject obj, String fieldApiName)
    {
        return defaultInteger(getFieldValue2(obj, fieldApiName));
    }


    private static Object getFieldValue2(sObject obj, String fieldApiName)
    {
        if(obj == null)
        {
            return '';
        }

        // strip any HTML present in the fieldname
        fieldApiName = fieldApiName.replaceAll('<[^>]*>', '');

        String[] split = fieldApiName.split('\\.');

        System.debug('field name: ' + fieldApiName);
        if(split.size() > 1)
        {
            if(split[0].equals('Case'))
            {
                return getFieldValue2(obj, fieldApiName.substringAfter('.'));
            } else
            {
                return getFieldValue2(obj.getSObject(split[0]), fieldApiName.substringAfter('.'));
            }
        }

        return obj.get(fieldApiName);

    }

    /**
     * SCSI-1308.
     */
    public static String getFieldValue(sObject sobj, String fieldApiName)
    {
        String result = '';
        if(sobj == null)
        {
            return result;
        }

        // strip any HTML present in the fieldname
        fieldApiName = fieldApiName.replaceAll('<[^>]*>', '');
        System.debug('field name: ' + fieldApiName);

        String[] split = fieldApiName.split('\\.');
        if(split[0].equals('Case'))
        {
            split.remove(0);
        }

        if(split.size() > 1)
        {
            fieldApiName = split.remove(split.size() - 1);
            sobj = ReflectionUtils.getRelationShipObject(sobj, split);
        }

        DisplayType fieldType = sobj.getSObjectType().getDescribe().fields.getMap().get(fieldApiName).getDescribe().getType();
        if(DisplayType.DATE == fieldType)
        {
            result = defaultDate(sobj.get(fieldApiName));
        }
        else if(DisplayType.DATETIME == fieldType)
        {
            result = defaultDateTime(sobj.get(fieldApiName));
        }
        else if(DisplayType.DOUBLE == fieldType)
        {
            result = defaultDouble(sobj.get(fieldApiName)) + '';
        }
        else
        {
            result = defaultString(sobj.get(fieldApiName));
        }

        return result;
    }

    public static Boolean hasValue(sObject obj, String fieldName)
    {
        if(obj == null)
        {
            return false;
        }

        String[] split = fieldName.split('\\.');

        //doesn't contain .
        if(split.size() < 2)
        {
            return true;
        }

        if(split.size() > 2 || split[0].equals('Case'))
        {
            return hasValue(obj, fieldName.substringAfter('.'));
        }

        Object base = obj.getSObject(split[0]);

        //try to get from ContactId field
        if(base == null)
        {
            base = obj.get(split[0] + 'Id');
        }

        if(base != null)
        {
            return true;
        }

        return false;

    }

    /*
    * Sets a Case field with a value using single field name or dot notation.
    *
    * Ignores the 'Case' prefix
    */
    public static void setFieldValue(sObject target, String apiName, Object value, Boolean toUpdate)
    {
        if(target == null)
        {
            return;
        }

        String[] split = apiName.split('\\.');

        if(split.size() > 1)
        {
            if(split[0].equals('Case') || split.size() > 2)
            {
                setFieldValue(target, apiName.substringAfter('.'), value, toUpdate);
                return;
            } else
            {
                sObject base = target.getSObject(split[0]);

                if(base != null)
                {
                    base.put(split[1], value);
                    if(toUpdate)
                    {
                        update base;
                    }
                }

                return;
            }
        }

        target.put(apiName, value);
        if(toUpdate)
        {
            update target;
        }
    }




    /*
    *   Get all Visual Force variables from a string.
    */
    public static Set<String> getAllVariables(String toFind){
        
        Set<String> fieldsList = new Set<String>();
        if(toFind == null || String.isEmpty(toFind))
        {
            return fieldsList;
        }
        
        Matcher matcher = Pattern.compile('\\{!([^}]*)\\}').matcher(toFind);

        if(matcher.find()) {
          do {
              // strip any HTML present in the fieldname
              String var = matcher.group(1).replaceAll('<[^>]*>', '');
              fieldsList.add(var.toLowerCase());
          } while(matcher.find());
        }
        
        return fieldsList;
        
    }
    
    public static String removeCasePrefix(String toReplace){
        String replaceToken = '(?i)\\{!Case\\.';
        String replaced = '';
        replaced = toReplace.replaceAll(replaceToken, '{!');
        
        return replaced;
    }

    public static String defaultString(Object obj)
    {
        if(obj == null)
        {
            return '';
        }

        return String.valueOf(obj);
    }

    public static String defaultDate(Object obj)
    {
        if(obj == null)
        {
            return '';
        }

        return DateUtil.valueOf((Date) obj);
    }

    public static String defaultDateTime(Object obj)
    {
        if(obj == null)
        {
            return '';
        }

        return DateUtil.valueOfDateTime((DateTime) obj);
    }

    public static Double defaultDouble(Object obj)
    {
        if(obj == null || String.isEmpty(String.valueOf(obj)))
        {
            return 0;
        }

        return (Double)obj;
    }

    public static Decimal defaultInteger(Object obj)
    {
        if(obj == null || String.isEmpty(String.valueOf(obj)))
        {
            return 0;
        }

        return (Decimal)obj;
    }
/**
    public static Integer getMaxLength(String field)
    {
        if(String.isEmpty(field))
        {
            return null;
        }

        Schema.SObjectField f = new MetadataHelper().getFieldFromDotNotation(field);

        if(f == null)
        {
            return null;
        }

        if(DisplayType.DOUBLE == f.getDescribe().getType())
        {
            return f.getDescribe().getPrecision() + 1;
        }

        return f.getDescribe().getLength();

    }
*/

    /**
    *    @description US109, SCSI-1125. Resets fields by regex patterns on prvided records.
    */
    public static void resetFieldsValuesByPatterns(List<Sobject> records, Set<String> strPatterns)
    {
        Set<Pattern> patterns = new Set<Pattern>();
        for (String strPattern : strPatterns)
        {
            Pattern pt = Pattern.compile(strPattern);
            patterns.add(pt);
        }

        Set<String> fieldsAPIsToBeReseted = new Set<String>();
        if (String.isNotBlank(records.getSobjectType().getDescribe().getName()))
        {
            Map<String, Schema.SObjectField> sobjectFields = ReflectionUtils.getSobjectFields(records.getSobjectType().getDescribe().getName());
            for (String fieldAPI : sobjectFields.keySet())
            {
                if (sobjectFields.get(fieldAPI).getDescribe().isNillable())
                {
                    for (Pattern pt : patterns)
                    {
                        Matcher matcher = pt.matcher(fieldAPI);
                        if (matcher.matches())
                        {
                            fieldsAPIsToBeReseted.add(fieldAPI);
                        }
                    }
                }
            }

            for (String fieldAPI : fieldsAPIsToBeReseted)
            {
                for (Sobject record : records)
                {
                    record.put(fieldAPI, null);
                }
            }
        }
    }

    /**
    *    @description DE105. Fills fields on a sobject record by provided map.
    */
    public static void fillRecordByMap(Sobject record, Map<String,Object> fieldsValues)
    {
        for (String fieldAPI : fieldsValues.keySet())
        {
            record.put(fieldAPI, fieldsValues.get(fieldAPI));
        }
    }

    /*
    * Allows to identify a polymorphic field. Works only on Case and the only one is Owner (Lookup, Queue)
     */
    public static Boolean isPolymorphic(String column)
    {
        for (String key : polymorphicCastTypes.keySet())
        {
            if (column.containsIgnoreCase(key + '.'))
            {
                return true;
            }
        }

        return false;
    }

    /**
     * Returns error message in case of error and empty string if successful
     */
    public static String validateCaseField(String mergeField)
    {
        String errorMessage = '';
        try {
            if(isPolymorphic(mergeField)) {
                String objectName = String.escapeSingleQuotes(mergeField.substringBefore('.'));
                String fieldName = String.escapeSingleQuotes(mergeField.substringAfter('.'));
                String fieldNameType = polymorphicCastTypes.get(objectName.toLowerCase());

                // validate
                if (fieldNameType == null) {
                    System.debug('fieldNameType is null');
                    return 'Field ' + mergeField + ' not in correct format. Please check Case fields API Names.';
                }

                //Query the Lookup object for value
                String lookupValueSql = 'SELECT ' + fieldName + ' FROM ' + fieldNameType + ' LIMIT 1';
                Database.query(lookupValueSql);

            } else
            {
                String sql = 'SELECT ' + mergeField + ' FROM Case LIMIT 1';
                Database.query(sql);
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            return e.getMessage();
        }

        return errorMessage;
    }


}