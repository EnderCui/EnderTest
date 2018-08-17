public with sharing class ProvinceCityController {
    
    public List<SelectOption> provinceOptionList{get;set;}
    
    public String provinceId{get;set;}
    
    public static String cityId{get;set;}
    
    public ProvinceCityController() {
        List<Province_City__c> provinceList = [select Id, Name, ID__c from Province_City__c where Parent_Id__c = '0' order by Order_Number__c asc];
        if(provinceList == null) {
            provinceList = new List<Province_City__c>();
        }
        provinceOptionList = new List<SelectOption>();
        for(Province_City__c province : provinceList) {
            provinceOptionList.add(new SelectOption(province.ID__c,province.Name));
        }
    }
    
    @RemoteAction
    public static List<Province_City__c> getCityListByProvince(String provinceId) {
        List<Province_City__c> cityList;
        if(provinceId != null && provinceId.length() > 0) {
            cityList = [select Id,Name,ID__c from Province_City__c where Parent_Id__c = :provinceId  order by Order_Number__c asc];
        } 
        if(cityList == null) {
            cityId = null;
            cityList = new List<Province_City__c>();
        }
        return cityList;
    }
}