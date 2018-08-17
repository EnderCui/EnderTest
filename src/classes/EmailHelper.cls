/*  
*   @description Class contains some useful methods for email generation and sending.

*/

public class EmailHelper
{
    // https://help.salesforce.com/apex/HTViewSolution?id=000170904&language=en_US
    //static Pattern EMAIL_PATTERN = Pattern.compile('([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})');
    static Pattern EMAIL_PATTERN = Pattern.compile('(?i)^[A-Z0-9._%+-/!#$%&\'*=?^_`{|}~]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$');

    public static Boolean isValidEmailAddress(String emailAddress)
    {
        return EMAIL_PATTERN.matcher(emailAddress).matches();
    }

    /*
    * Handle case when list of comma sepparated emails is supplied
    */
    public static Boolean isValidEmailAddresses(String emailAddresses)
    {
        if(String.isBlank(emailAddresses))
        {
            return false;
        }

        // has multiple emails
        for(String singleEmail : emailAddresses.split(','))
        {
            if(!isValidEmailAddress(singleEmail.trim()))
            {
                return false;
            }
        }

        return true;
    }

    public static String sendEmails (List<Messaging.SingleEmailMessage> theInputMails)
    {
        String errMessage = null;
        try
        {
            List<Messaging.SendEmailResult> aMessagingResults = new List<Messaging.SendEmailResult>();
            // Send Emails
            if(!Test.isRunningTest())
            {
                aMessagingResults = Messaging.sendEmail(theInputMails);
            }
            
            // Error Handling for send email errors
            for (Integer i = 0; i < aMessagingResults.size(); i++)
            {
                if (!aMessagingResults.get(i).isSuccess())
                {
                    System.StatusCode statusCode = aMessagingResults.get(i).getErrors()[0].getStatusCode();
                    errMessage = '';
                    for(Messaging.SendEmailError emailError : aMessagingResults.get(i).getErrors())
                    {
                        errMessage += emailError.getMessage();
                    }
                    
                    String errorMessage = 'StatusCode: ' + statusCode + '  \n' + errMessage;  
                    Logger.error('Error on sending email.', errorMessage, 
                                EmailHelper.class, new Set<Id>(), 'EmailHelper.sendEmails');
                }
            }
            return errMessage;
        }
        catch(Exception e)
        {
            Set<Id> objIds = new Set<Id>();
            for (Messaging.SingleEmailMessage aMail: theInputMails)
            {
                if(aMail.getTargetObjectId() != null)
                {
                    objIds.add(aMail.getTargetObjectId());
                }
            }
            Logger.exception('Error on sending email.', e, objIds, 'EmailHelper.sendEmails');
            errMessage = e.getMessage();
        }
        return errMessage;
    }

    public static String mergeTemplate(Map<String,String> obj, String template){

        return m(template, obj, Pattern.compile('(\\[![A-Za-z_]+!\\])').matcher(template));
    }

    private static String m(String body, Map<String,String> obj, Matcher m){
        while(m.find()){

            String merge_field = m.group(0);
            String field = merge_field.substring(2, merge_field.length() - 2);

            String value;
            try{
                value = (String) obj.get(field);
            }
            catch(Exception e){
                value='';
            }
            if(value!=null){
                body = body.replace(merge_field, value);
            }
            else{
                body = body.replace(merge_field, '');
            }
        }
        return body;
    }
}