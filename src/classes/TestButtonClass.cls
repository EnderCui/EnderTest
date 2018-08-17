global class TestButtonClass
{
    webservice static void myMethod(String name, Integer age) 
    { 
         System.debug('+++++ endertest: test custom Button call apex method' + name + age);
    }
}