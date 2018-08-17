public class TreeController {
    
    public Boolean selectable {get; set;}
    
    public String selectNodeKeys {get; set;}

    public TreeController(){
        selectable = false;
        selectNodeKeys = 'No value selected';
    }
    
    public String JsonData {get; set;}
    
    public String getJsonString() {
        if (JsonData == null){
            JsonData = TreeUtil.getTreeAndSubTrees();
        }
        return JsonData;
    }

}