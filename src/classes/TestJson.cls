public class TestJson{
    public static void testJsonParse(){
        String JSONContent = '[{"name": "Tester", "skills": ["JavaScript", "Java", "Python", "Lisp"]}]';
        Object testList = JSON.deserialize(JSONContent, List<TempJsonObj>.class);
        List<TempJsonObj> peopleList = (List<TempJsonObj>) testList;
        
        for(TempJsonObj tj : peopleList){
            System.debug('++++++ tester skills:' + tj.skills);
        }
    }
    public class TempJsonObj{
        public String Name;
        public List<String> skills{get;set;}
    }
}