public without sharing class TreeUtil {

    // map to hold roles with Id as the key
    private static Map <Id, Tree__c> treeMap;

    // map to hold child roles with parentRoleId as the key
    private static Map <Id, List<Tree__c>> parentNodeToChildNodeMap;


    private static List<NodeWrapper> nodes{get;set;}

    private static JSONGenerator gen {get; set;}

    private static Tree__c rootNode{get;set;}

    static {
        initTreeDatas();
    }

    public static void initTreeDatas() {
        treeMap = new Map<Id,Tree__c>([SELECT IsLeafNode__c, ParentNode__c, Id, Name FROM Tree__c order by ParentNode__c]);
        parentNodeToChildNodeMap = new Map<Id,List<Tree__c>>();
        for(Tree__c tree : treeMap.values()) {
            List<Tree__c> tempList;
            if(parentNodeToChildNodeMap.containsKey(tree.ParentNode__c)) {
                 tempList = parentNodeToChildNodeMap.get(tree.ParentNode__c);
                 tempList.add(tree);
                 parentNodeToChildNodeMap.put(tree.ParentNode__c,tempList);
             } else {
                 tempList = new List<Tree__c>();
                 tempList.add(tree);
                 if(tree.ParentNode__c != null) {
                     parentNodeToChildNodeMap.put(tree.ParentNode__c,tempList);  
                 } else {
                    rootNode = tree;
                 }              
             }
        }
    } 


    private static void convertNodeToJSON(NodeWrapper nw){
        gen.writeStartObject();
        if(!nw.isLeafNode) {
            gen.writeStringField('title', nw.nodeName);
            gen.writeStringField('key', nw.nodeId);
            gen.writeBooleanField('unselectable', false);
            gen.writeBooleanField('expand', true);
            gen.writeBooleanField('isFolder', true);
            if (nw.hasChildNodes) {
                gen.writeFieldName('children');
                gen.writeStartArray();    
                for (NodeWrapper r : nw.childNodes) {
                    convertNodeToJSON(r);
                }
                gen.writeEndArray();                   
            }
        } else {
            gen.writeStringField('title', nw.nodeName);
            gen.writeStringField('key', nw.nodeId);
        }
        gen.writeEndObject();
    }

    public static NodeWrapper createNode(Tree__c tree) {
        NodeWrapper n = new NodeWrapper();
        n.nodeName = tree.Name;
        n.nodeId = tree.Id;
        n.parentNodeId = tree.ParentNode__c;
        
        if(tree.IsLeafNode__c) {
            n.isLeafNode = true;
            n.hasChildNodes = false;
        } else {
            List<NodeWrapper> nwList = new List<NodeWrapper>();
            if(parentNodeToChildNodeMap.get(tree.Id) != null) {
                n.hasChildNodes = true;
                n.isLeafNode = false;
                for(Tree__c tempTree : parentNodeToChildNodeMap.get(tree.Id)) {
                    nwList.add(createNode(tempTree));
                }
                n.childNodes = nwList;
            }
            
        }
        return n;
    }


    public static String getTreeAndSubTrees() {
        gen = JSON.createGenerator(true);
        NodeWrapper node = createNode(rootNode);
        gen.writeStartArray();
        convertNodeToJSON(node);
        gen.writeEndArray();
        return gen.getAsString();
    }


    public class NodeWrapper {

        //current node name
        public String nodeName{get;set;}

        //current node id
        public String nodeId{get;set;}

        //if current node isn't root,set it's parent parentNodeId
        public String parentNodeId{get;set;}

        //if this node set as a parent node,does it has child node
        public Boolean hasChildNodes{get;set;}

        //if current node is leaf node,set to true
        public Boolean isLeafNode{get;set;}


        //all of child nodes of current node
        public List<NodeWrapper> childNodes{get;set;}

        public NodeWrapper() {
            hasChildNodes = false;
        }
    }

}