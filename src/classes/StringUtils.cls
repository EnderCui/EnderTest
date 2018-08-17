/**
    String Utility class.

*/
public with sharing class StringUtils {

    /*
     * Returns empty string if null
     */
    public static String default(Object valueObject)
    {
        return valueObject != null ? String.valueOf(valueObject) : '';
    }

    /*
     * Returns empty string if null and escapes single quotes
     */
    public static String defaultEscapeSingleQuotes(Object valueObject)
    {
        return String.escapeSingleQuotes(default(valueObject));
    }
}