public class ContactAndLeadSearch {

    public static List<List< SObject>> searchContactsAndLeads(String nameContains){

        List<List< SObject>> resultLst = [FIND :nameContains IN NAME FIELDS RETURNING Contact(Name), Lead(Name)];
        
        return resultLst;
    
    }

}