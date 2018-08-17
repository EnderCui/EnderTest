public class AccountHandler{

    public static Account insertNewAccount(String name){
        
        Account a = new Account();
        
        try{
            a.Name = name;
            insert a;
        
        }catch (Exception e){
            System.debug('++++++ exception:' + e);
            return null;
        }
        
        return a;

    
    }


}