public without sharing class U_PrimitiveHelper {

    public static Primitive getPrimitiveTypeByField(String sObjectName,String fieldName) {
        Schema.DisplayType fieldType = getFieldDisplayType(sObjectName,fieldName);
        if(fieldType == Schema.Displaytype.BOOLEAN){
            return Primitive.TYPE_BOOLEAN;
        }
        else if(fieldType == Schema.Displaytype.BASE64 || fieldType == Schema.Displaytype.COMBOBOX || fieldType == Schema.Displaytype.EMAIL ||
                fieldType == Schema.Displaytype.ENCRYPTEDSTRING || fieldType == Schema.Displaytype.ID || fieldType == Schema.Displaytype.MULTIPICKLIST ||
                fieldType == Schema.Displaytype.PHONE || fieldType == Schema.Displaytype.PICKLIST || fieldType == Schema.Displaytype.REFERENCE ||
                fieldType == Schema.Displaytype.STRING || fieldType == Schema.Displaytype.TEXTAREA || fieldType == Schema.Displaytype.URL){
            return Primitive.TYPE_STRING;
        }
        else if(fieldType == Schema.Displaytype.CURRENCY || fieldType == Schema.Displaytype.DOUBLE || fieldType == Schema.Displaytype.PERCENT){
            return Primitive.TYPE_DOUBLE;                       
        }
        else if(fieldType == Schema.Displaytype.INTEGER){
            return Primitive.TYPE_INTEGER;                      
        }
        else if(fieldType == Schema.Displaytype.DATE){
            return Primitive.TYPE_DATE;
        }
        else if(fieldType == Schema.Displaytype.DATETIME){
            return Primitive.TYPE_DATETIME;
        }
        else {
            throw new MyException('无对应的基础类型');
        }
    }
    
    
    private static Schema.DisplayType getFieldDisplayType(String sObjectName,String fieldName) {
        List<Schema.DescribeSObjectResult> sObjectTypes = Schema.describeSObjects(new String[]{sObjectName});
        if(sObjectTypes == null || sObjectTypes.size() == 0) {
            throw new MyException('无此Object Name');
        }
        Schema.DescribeSObjectResult sObjectDescribeResult = sObjectTypes.get(0);
        Map<String,Schema.SObjectField> objectFieldMap = sObjectDescribeResult.fields.getMap();
        Schema.SObjectField objectField = objectFieldMap.get(fieldName);
        if(objectField == null) {
            throw new MyException('无此Field Name');
        }
        Schema.DescribeFieldResult fieldResult = objectField.getDescribe();
        
        return fieldResult.getType();
    }
    
    private class MyException extends Exception{}
}