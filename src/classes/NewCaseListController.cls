public class NewCaseListController{

    public List<Case> getNewCases(){
    
        List<case> caseLst = [SELECT ID, CaseNumber FROM Case WHERE Status = 'New'];
        
        return caseLst;
    
    }
    
    public void printName(){
        System.debug('++++++ endertest, printName.' );
    }

}