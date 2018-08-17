public class StringArrayTest{
    public static List<String> generateStringArray(Integer counter){
        List<String> result = new List<String>();
        
        
        for(Integer i=0; i<counter; i++){
            result.add('Test ' + i);
        }
        
        return result;
    
    }

}