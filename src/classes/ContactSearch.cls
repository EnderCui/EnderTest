public class ContactSearch{

    public static List<Contact> searchForContacts(String lastName , String postCode){
    
        //find any contact that has a last name matching the first, and mailing postal code matching the second string
        
        List<Contact> resultLst = [select ID, Name, FirstName, LastName from Contact where (LastName = :lastName and MailingPostalCode = : postCode)];
        
        return resultLst;
    
    }

}