/**
*   @description Utils class for working with Apex reflection possibilities.

*/
global with sharing class ReflectionUtils
{
    /**
    *    @description Returns a picklist field default value.
    */
    public static String getPicklistFieldDefaultValue(String sobjectAPI, String fieldAPI)
    {
        String defaultValue = '';

        List<Schema.PicklistEntry> picklistEntries = ReflectionUtils.getPicklistEntries(sobjectAPI, fieldAPI);
        if (picklistEntries.size() > 0)
        {
            defaultValue = picklistEntries.get(0).getValue();
            for (Schema.PicklistEntry entry : picklistEntries)
            {
                if (entry.isDefaultValue())
                {
                    defaultValue = entry.getValue();
                    break;
                }
            }
        }

        return defaultValue;
    }

    /**
    *    @description Returns picklist entries.
    */
    public static List<Schema.PicklistEntry> getPicklistEntries(String sobjectApi, String fieldApi)
    {
        Map<String, Schema.SObjectField> sobjectFields = getSobjectFields(sobjectApi);
        return sobjectFields.get(fieldApi).getDescribe().getPicklistValues();
    }

    /**
    *    @description Returns picklist field labels.
    *    @param sobjectApi target sobject type name.
    *    @param fieldApi target field api name.
    *    @return List<String> labels.
    *    @author ypa
    */
    public static List<String> getPicklistValues(String sobjectApi, String fieldApi)
    {
        List<String> picklistLabels = new List<String>();

        List<Schema.PicklistEntry> picklistEntries = getPicklistEntries(sobjectApi, fieldApi);
        for (Schema.PicklistEntry picklistEntry : picklistEntries)
        {
            picklistLabels.add(picklistEntry.getLabel());
        }

        return picklistLabels;
    }

    /**
    *    @description Returns name of child relationship.
    *    @param sobjectTypeName target sobject type name.
    *    @param childSobjectTypeName child sobject type name, relationship name of which we would like to find.
    *    @return String.
    *    @author ypa
    */
    public static String getChildRelationshipName(String sobjectTypeName, String childSobjectTypeName)
    {
        String result = '';

        Schema.SObjectType sobjType = Schema.getGlobalDescribe().get(sobjectTypeName);
        if (sobjType == null)
        {
            return result;
        }

        List<Schema.ChildRelationship> childRelationships = sobjType.getDescribe().getChildRelationships();
        for (Schema.ChildRelationship childRelationship : childRelationships)
        {
            if (childRelationship.getChildSObject().getDescribe().getName() == childSobjectTypeName)
            {
                result = childRelationship.getRelationshipName();
                break;
            }
        }

        return result;
    }

    /**
    *    @description Returns sobject type describe by it's name.
    *    @param sobjectTypeName target sobject type name.
    *    @return Schema.DescribeSObjectResult.
    *    @author ypa
    */
    public static Schema.DescribeSObjectResult getSobjectDescribe(String sobjectTypeName)
    {
        Schema.DescribeSObjectResult sobjectDescribe = null;
        Schema.SObjectType sobjType = Schema.getGlobalDescribe().get(sobjectTypeName);
        if (sobjType != null)
        {
            sobjectDescribe = sobjType.getDescribe();
        }

        return sobjectDescribe;
    }

    /**
    *    @description Returns sobject type key prefix.
    *    @param sobjectTypeName target sobject type name.
    *    @return String.
    *    @author ypa
    */
    public static String getKeyPrefix(String sobjectTypeName)
    {
        String keyPrefix = '';
        Schema.DescribeSObjectResult sobjectDescribe = getSobjectDescribe(sobjectTypeName);
        if (sobjectDescribe != null)
        {
            keyPrefix = sobjectDescribe.getKeyPrefix();
        }

        return keyPrefix;
    }

    /**
    *    @description Checks whether field id formula.
    *    @param sobjectTypeName target sobject type name.
    *    @param fieldApiName field api name to check.
    *    @return Boolean.
    *    @author ypa
    */
    public static Boolean isFormulaField(String sobjectTypeName, String fieldApiName)
    {
        Map<String, Schema.SObjectField> fields = getSobjectFields(sobjectTypeName);
        //System.debug('!!!!!Field: \'' + fieldApiName + '\', Field: ' + fields.get(fieldApiName) + ', Sobject type name: ' + sobjectTypeName);
        Schema.DescribeFieldResult fieldDescribe = fields.get(fieldApiName).getDescribe();
        return fieldDescribe.isCalculated();
    }
    
    /**
    *    @description Return name of sobject type to which field is related.
    *    @param sobjectTypeName target sobject type name.
    *    @param fieldName target field name.
    *    @return String name of the first relationship name.
    *    @author ypa
    */
    public static String getFirstRelatinshipName(String sobjectTypeName, String fieldName)
    {
        Map<String, Schema.SObjectField> sObjectFieldsMap = getSobjectFields(sobjectTypeName);
        if (!isReference(sobjectTypeName, fieldName))
        {
            return null;
        }

        return sObjectFieldsMap.get(fieldName).getDescribe().getReferenceTo().get(0).getDescribe().getName();
    }

    /**
    *    @description Checks if target field is reference.
    *    @param sobjectTypeName target sobject type name.
    *    @param fieldName target field name.
    *    @return Boolean flag which indicates whether it is relationship field.
    *    @author ypa
    */
    public static Boolean isReference(String sobjectTypeName, String fieldName)
    {
        Map<String, Schema.SObjectField> sObjectFieldsMap = getSobjectFields(sobjectTypeName);
        return (sObjectFieldsMap.get(fieldName) != null &&
                sObjectFieldsMap.get(fieldName).getDescribe() != null &&
                sObjectFieldsMap.get(fieldName).getDescribe().getReferenceTo().size() > 0);
    }

    /**
    *    @description Checks if target field is reference.
    *    @param relationshipObjType to which sobject field should point to.
    *    @return List<String> api names
    *    @author ypa
    */
    public static List<String> findRelationshipFieldApi(String currentSobjType, String relationshipObjType)
    {
        List<String> result = new List<String>();

        Map<String, Schema.SObjectField> sObjectFieldsMap = getSobjectFields(currentSobjType);
        for (String fieldApi : sObjectFieldsMap.keySet())
        {
            if (isReference(currentSobjType, fieldApi))
            {
                List<Schema.sObjectType> sobjTypes = sObjectFieldsMap.get(fieldApi).getDescribe().getReferenceTo();
                for (Schema.sObjectType sobjType : sobjTypes)
                {
                    if (sobjType.getDescribe().getName() == relationshipObjType)
                    {
                        result.add(fieldApi);
                    }
                }
            }
        }
        return result;
    }

    /**
    *    @description Creates new instance of sobject by name.
    *    @param sobjName name of type of target sobject.
    *    @return Sobject new sobject instance.
    *    @author ypa
    */
    public static Sobject newInstance(String sobjName)
    {
        return Schema.getGlobalDescribe().get(sobjName).newSObject();
    }

    /**
    *    @description Return name of type of target sobject.
    *    @param sobj sobject of target type.
    *    @return String name of sobject ype.
    *    @author ypa
    */
    public static String getSobjectTypeName(Sobject sobj)
    {
        return sobj.getSObjectType().getDescribe().getName();
    }

    /**
    *    @description Return sobject record types by names.
    *    @param sobj sobject of target type.
    *    @return Map<Id, Schema.RecordTypeInfo> record type name to record type info.
    *    @author ypa
    */
    public static Map<String, Schema.RecordTypeInfo> getRecordTypesByName(Sobject sobj)
    {
        return sobj.getSObjectType().getDescribe().getRecordTypeInfosByName();
    }

    /**
    *    @description Return sobject record types by ids.
    *    @param sobj sobject of target type.
    *    @return Map<Id, Schema.RecordTypeInfo> record type id to record type info.
    *    @author ypa
    */
    public static Map<Id, Schema.RecordTypeInfo> getRecordTypesById(Sobject sobj)
    {
        return sobj.getSObjectType().getDescribe().getRecordTypeInfosById();
    }

    /**
    *    @description Retrieve sobject's fields describe.
    *    @param sobjectName name of sobject.
    *    @author ypa
    */
    public static Map<String, Schema.SObjectField> getSobjectFields(String sobjectName)
    {
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sobjectName);
        if(sObjectType == null)
        {
            throw new SobjectReflectionException('Error: sobject not found: ' + sobjectName);
        }

        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectType.getDescribe();
        if (describeSObjectResultObj == null || !describeSObjectResultObj.isAccessible())
        {
            throw new SobjectReflectionException('Error: User has not access to sobject: ' + sobjectName);
        }

        Map<String, Schema.SObjectField> sObjectFields = describeSObjectResultObj.fields.getMap();

        return sObjectFields;
    }

    /**
    *    @description Parse sobject's fields to retrieve only custom ones.
    *    @param sobjectName name of sobject.
    *    @return Set<String> of custom fields only.
    *    @author ypa
    */
    public static Set<String> getCustomFieldsNames(String sobjectName)
    {
        Map<String, Schema.SObjectField> fields = getSobjectFields(sobjectName);

        Set<String> customFields = new Set<String>();
        for (String fieldName : fields.keySet())
        {
            Schema.SObjectField sObjectField = fields.get(fieldName);
            Schema.DescribeFieldResult sObjectFieldDescribe = sObjectField.getDescribe();
            if (sObjectFieldDescribe.isAccessible() && sObjectFieldDescribe.isCustom())
            {
                customFields.add(sObjectFieldDescribe.getName());
            }
        }

        return customFields;
    }

    /**
    *    @description Collects names of required fields.
    *    @param sobjectName - name of target sobject.
    *    @return List<String> names of required fields.
    *    @author ypa
    */
    public static List<String> getRequiredFieldsNames(String sobjectName) 
    {
        Boolean areRequiredFieldsPopulated = true;

        Map<String, Schema.SObjectField> fields = getSobjectFields(sobjectName);
        
        //Define required fields
        List<String> requiredFields = new List<String>();

        for (String field : fields.keyset())
        {
            Schema.DescribeFieldResult describeResult = fields.get(field).getDescribe();
            
            //If field is creatable and is not nillable and is not defaulted on create then its required
            Boolean isRequired = (describeResult.isCreateable() && !describeResult.isNillable() && !describeResult.isDefaultedOnCreate());
            if (isRequired) 
            {
                requiredFields.add(describeResult.getName());
            }

        }

        return requiredFields;

    }

    /**
    *    @description Retrieve and return field type.
    *    @param sobjectName name of sobject.
    *    @param fieldApiName.
    *    @return String representation of type.
    *    @author ypa
    */
    public static String getFieldType(String sobjectName, String fieldApiName)
    {
        Map<String, Schema.SObjectField> fields = getSobjectFields(sobjectName);

        return fields.containsKey(fieldApiName) ? fields.get(fieldApiName).getDescribe().getType().name() : '';
    }

    /**
    *    @description Retrieve metadata type by type and qualifier.
    *    @param sobjectName.
    *    @return Boolean indicator.
    *    @author ypa
    */
    public static Boolean isCustomSobject(String sobjectName)
    {

        Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(sobjectName);
        if (sobjectType == null)
        {
            throw new SobjectReflectionException('Error: There is no such sobject \'' + sobjectName + '\' in the system.');
        }

        return sobjectType.getDescribe().isCustom();
        
    }

    /**
    *    @description Retrieve metadata type by type and qualifier.
    *    @param sobjectName.
    *    @param sobjectField - api name.
    *    @return Boolean indicator.
    *    @author ypa
    */
    public static Boolean isCustomField(String sobjectName, String sobjectField)
    {
        Schema.SObjectField describeField = getSobjectFields(sobjectName).get(sobjectField);
        if (describeField == null)
        {
            throw new SobjectReflectionException('Error: There is no such field \'' + sobjectField + '\' in the \'' + sobjectName +'\' sobject.');
        }

        return describeField.getDescribe().isCustom();
        
    }

    /**
    *    @description If target field is relatinship - recursively go to target value.
    */
    public static Object getRelationShipValue(SObject sobj, String fieldPath)
    {
        List<String> splitted = fieldPath.split('\\.');
        String apiFiled = splitted.get(splitted.size() - 1);
        splitted.remove(splitted.size() - 1);

        SObject obj;

        if (splitted.size() > 0)
        {
            obj = getRelationShipObject(sobj, splitted);
        } else 
        {
            obj = sobj;
        }

        return obj == null ? obj : obj.get(apiFiled);
    }

    /**
    *    @description Recursively go through sobject relationships.
    */
    public static SObject getRelationShipObject(SObject s, List<String> l) 
    {
        if (s == null )
        {
            return null;
        }
    
        if (l.isEmpty()) 
        {
            return s;
        } else 
        {
            String currentField = l.remove(0);
            SObject s1 = s.getSObject(currentField);
            return getRelationShipObject(s1, l);
        }
    }

    public class SobjectReflectionException extends Exception {}
}