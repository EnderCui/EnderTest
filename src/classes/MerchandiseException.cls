public class MerchandiseException extends Exception{

    //override constructor, does NOT work
    //public override MerchandiseException (String msg, Exception e){
    //    System.debug('override: String Exception');
    //}


    public MerchandiseException (Exception e, String exceptionType){

        if (e instanceOf DmlException){
            sendNoticeToDmlTeam(e);
        } else if (e instanceOf CalloutException){
            sendNoticeToNetTeam(e);
        }
    }


    public void sendNoticeToDmlTeam(Exception e){
        System.debug('Send to DML admin team:' + e.getMessage());
    
    }
    
    public void sendNoticeToNetTeam(Exception e){
        System.debug('Send to NET admin team:' + e.getMessage());
    
    }
    
    //over load, works fine
    public void sendNoticeToNetTeam(Exception e, String msg){
        System.debug('Send to NET admin team:' + e.getMessage());
    
    }

}