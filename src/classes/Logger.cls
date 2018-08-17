/**
*   @description Logger object that stores the log messages as a record of Logger object.

*/

public without sharing class Logger
{
    // Set the max percent of Salesforce limits.
    private static Decimal MAX_SALESFORCE_LIMIT_PERCENT = 90;
    
    /*
    *   @description        Log INFO message.
    *
    *   @param comment      Comment about the class and method call
    *   @param thisClass    Class object
    *   @param objectId     Object in trigger
    *   @param errorCode    'ClassName.MethodName'
    */
    public static void info (String comment, String logMessage, Object thisClass, Id objectId, String errorCode)
    {
        if(thisClass != null)
        {
            String className = String.valueOf(thisClass);
            logMessage = className + ' : ' + logMessage;
        }

        System.debug(Logginglevel.INFO, 'exception: ' + logMessage);
        createLog(comment, logMessage, logMessage, 'INFO', new Set<Id> {objectId}, errorCode, null);
    }

    /*
    *   @description        Log ERROR message.
    *
    *   @param comment      Comment about the class and method call
    *   @param logMessage   Error message
    *   @param thisClass    Class object
    *   @param objectId     Object in trigger
    *   @param errorCode    'ClassName.MethodName'
    */
    public static void error (String comment, String logMessage, Object thisClass, Id objectId, String errorCode)
    {
        error(comment, logMessage, thisClass, new Set<Id> {objectId}, errorCode);
    }
        
    /*
    *   @description        Log ERROR message.
    *
    *   @param comment      Comment about the class and method call
    *   @param logMessage   Error message
    *   @param thisClass    Class object
    *   @param objectId     Object in trigger
    *   @param errorCode    'ClassName.MethodName'
    */
    public static void error (String comment, String logMessage, Object thisClass, Set<Id> objects, String errorCode)
    {
        if(thisClass != null)
        {
            String className = String.valueOf(thisClass);
            logMessage = className + ' : ' + logMessage;
        }
        
        System.debug(Logginglevel.ERROR, 'exception: ' + logMessage);
        createLog(comment, logMessage, logMessage, 'ERROR', objects, errorCode, null);
    }

    /*
    *   @description        Log exception.
    *
    *   @param comment      Comment about the class and method call
    *   @param ex           Exception object
    *   @param objects      List of objects in trigger
    *   @param errorCode    'ClassName.MethodName'
    */
    public static void exception (String comment, Exception ex, Set<Id> objects, String errorCode)
    {
        String logMessage = getMessageByException(ex);
        System.debug(Logginglevel.ERROR, 'exception: ' + logMessage);
        
        // Add a new Log record.
        createLog(comment, ex.getMessage(), logMessage, 'ERROR', objects, errorCode, null);
    }

    /*
    *   @description Parse exception to String message.
    *
    *   @param ex   Exception object
    */
    private static String getMessageByException (Exception ex)
    {
        String logMessage = 'Type: ' + ex.getTypeName() + '\n' + 'Cause: ' + ex.getCause() + '\n' + 'Message: ' + ex.getMessage() + '\n' + 
                            'Line #: ' + ex.getLineNumber() + '\n' + ex.getStackTraceString();
        if(ex instanceOf System.DmlException)
        {
            for (Integer i = 0; i < ex.getNumDml(); i++)
            {
                logMessage += '\n' + ex.getDmlMessage(i);
            }
        }
        return logMessage;
    }

    /*
    *   @description Validate if Salesforce limits are reached and log an limit exception.
    *
    *   @param comment      Comment about the class and method call
    *   @param objects      List of objects in trigger
    */
    public static void limits (Set<Id> objects, String comment, String errorLocation)
    {
        logLimitReached(errorLocation, 'CpuTime', Limits.getLimitCpuTime(), Limits.getCpuTime(), objects, comment);
        logLimitReached(errorLocation, 'Callouts', Limits.getLimitCallouts(), Limits.getCallouts(), objects, comment);
        logLimitReached(errorLocation, 'EmailInvocations', Limits.getLimitEmailInvocations(), Limits.getEmailInvocations(), objects, comment);
        logLimitReached(errorLocation, 'FutureCalls', Limits.getLimitFutureCalls(), Limits.getFutureCalls(), objects, comment);
        logLimitReached(errorLocation, 'HeapSize', Limits.getLimitHeapSize(), Limits.getHeapSize(), objects, comment);
        logLimitReached(errorLocation, 'Queries', Limits.getLimitQueries(), Limits.getQueries(), objects, comment);
    }
    
    /*
    *   @description Create an ErrorLog entry if percent of the limit is reached.
    */
    private static void logLimitReached (String errorLocation, String limitName, Decimal maxLimit, Decimal currentLimit, Set<Id> objects, String comment)
    {
        Decimal percentLimit = maxLimit * MAX_SALESFORCE_LIMIT_PERCENT / 100;
        if((currentLimit >= percentLimit && maxLimit > 0) || Test.isRunningTest())
        {
            String logMessage = 'Critical limit is reached: ' + percentLimit + ' %';
            
            createLog(  comment, logMessage, logMessage, 'WARN', objects, errorLocation, 
                        getLimituserFiendly(limitName, maxLimit, currentLimit));
        }
    }
    
    /*
    *   @description Create an ErrorLog entry.
    */
    private static void createLog (String comment, String logMessage, String stackTrace, String logLevel, Set<Id> objects, 
                                    String errorCode, String criticalLimit)
    {                   
        ErrorLog__c log = new ErrorLog__c();
        log.Status__c = 'New';
        log.Comment__c = getSubstring (comment, 32768);
        log.FullStackTrace__c = getSubstring (stackTrace, 32768);
        log.ErrorMessage__c = getSubstring (logMessage, 254);
        log.User__c = UserInfo.getUserId();
        if(errorCode != null)
        {
            log.ErrorLocation__c = getSubstring (errorCode, 199);
        }

        if(objects != null)
        {
            log.Objects__c = listToString(objects);
            for(Id objId : objects)
            {
                log.ObjectId__c = objId;
                break;
            }
        }
        insert log;
    }
    
    /*
    *   @description Cut string value to defined length.
    */
    private static String getSubstring (String value, Integer valueLeng)
    {
        if(value != null && value.length() > valueLeng)
        {
            return value.substring(0, valueLeng - 1);
        }
        return value;
    }
    
    /*
    *   @description Convert Set<Id> to String.
    */
    private static String listToString (Set<Id> objects)
    {
        String result = '';
        Boolean isFirst = true;
        for(Id objId : objects)
        {
            if(isFirst)
            {
                isFirst = false;
                result += objId + ' ';
            }
            else
            {
                result += ',' + objId + ' ';
            }
        }
        return result;
    }
    
    /*
    *   @description Return the current state of the Salesforce limits as string.
    */
    public static String getSalesforceLimits ()
    {
        String sfLimits = getLimituserFiendly('CpuTime',    Limits.getLimitCpuTime(), Limits.getCpuTime());
        sfLimits += getLimituserFiendly('Callouts',         Limits.getLimitCallouts(), Limits.getCallouts());
        sfLimits += getLimituserFiendly('EmailInvocations', Limits.getLimitEmailInvocations(), Limits.getEmailInvocations());
        sfLimits += getLimituserFiendly('FutureCalls',      Limits.getLimitFutureCalls(), Limits.getFutureCalls());
        sfLimits += getLimituserFiendly('HeapSize',         Limits.getLimitHeapSize(), Limits.getHeapSize());
        sfLimits += getLimituserFiendly('Queries',          Limits.getLimitQueries(), Limits.getQueries());
        return sfLimits;
    }
    
    /*
    *   @description Prepare limits to user friendly view.
    */
    private static String getLimituserFiendly (String limitName, Decimal maxLimit, Decimal currentLimit)
    {
        return limitName + ' (limit ' + maxLimit + '): ' + currentLimit + '\n';
    }
}