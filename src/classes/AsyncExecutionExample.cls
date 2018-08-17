public class AsyncExecutionExample implements Queueable {

    private String testName = '';
    public AsyncExecutionExample(String tName){
        this.testName = tName;
    }
    
    public void execute(QueueableContext context) {
        System.debug('++++++ endertest: Async execute.' + testName );
    }
}