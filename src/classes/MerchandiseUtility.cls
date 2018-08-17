public class MerchandiseUtility {

    public static void insertContact(){
    
        try {
            Contact c = new Contact();
            insert c;
        
        } catch(DmlException e) {
            throw new MerchandiseException(e, 'DML exception');
        } catch(CalloutException e){
            throw new MerchandiseException(e, 'Callout exception');
        } catch(Exception e){
            throw new MerchandiseException(e, 'Other Exception');
        }
    
    }

    public static void processContact(){
    
        try {
            insertContact();
        
        } catch (MerchandiseException me) {
            System.debug('Merchandise Exception:' + me.getMessage());
        }
    
    }

}