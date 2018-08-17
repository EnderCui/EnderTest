@RestResource(urlMapping='/SoapMessage')
global with sharing class RESTController {

  @HttpPost  
  global static String inboundSoap() {     
      RestRequest req = RestContext.request;
      
      DataCapture__c dc = new DataCapture__c();
      dc.Data__c = req.requestBody.toString();
      insert dc;
      
      return 'Done ' + dc.Id;
  }
}