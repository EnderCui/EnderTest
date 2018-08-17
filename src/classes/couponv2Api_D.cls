//Generated by wsdl2apex

public class couponv2Api_D {
    public class PayXGetYCouponInformation {
        public Integer buyAmount;
        public Integer getAmount;
        public api_D.LabelValueData[] includedItems;
        public api_D.LabelValueData[] includedItemGroups;
        private String[] buyAmount_type_info = new String[]{'buyAmount','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] getAmount_type_info = new String[]{'getAmount','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] includedItems_type_info = new String[]{'includedItems','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] includedItemGroups_type_info = new String[]{'includedItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://couponv2.api.extension.management.valuephone.com','false','false'};
        private String[] field_order_type_info = new String[]{'buyAmount','getAmount','includedItems','includedItemGroups'};
    }
    public class CommonCouponInformation {
        public api_D.ApiIdentifier id;
        public String unitType;
        public String briefInfo;
        public String longInfo;
        public String shortTitle;
        public Boolean alwaysConsumable;
        public Integer maxUserInstancesCount;
        public Integer maxReceiptUsagesCount;
        public DateTime validFrom;
        public DateTime validTill;
        public DateTime showFrom;
        public DateTime showTill;
        public String specialOfferHeadline;
        public String retailerSupplier;
        public Boolean forAllStores;
        public Integer maxCouponCount;
        public String loyaltyProviderName;
        public wsinterfaceApi_D.ImageInformation[] images;
        public String deliveryType;
        public String deliveryTypeDependentParameter;
        public String targetGroup;
        public Boolean directCustomerAssignment;
        public String couponTaxHandlingType;
        public String processingType;
        public Boolean activationByUser;
        public shopinterfaceApi_D.ShopIdentifier[] retailerStores;
        public Double minProductValue;
        public Double maxProductValue;
        public Double minReceiptValue;
        public Double maxReceiptValue;
        public Integer interval;
        public Boolean autoActivation;
        public Double minProductUnitValue;
        public Double maxProductUnitValue;
        public String instanceCreationConditionType;
        public Integer posProcessingSequence;
        public Integer posProcessingResolution;
        private String[] id_type_info = new String[]{'id','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] unitType_type_info = new String[]{'unitType','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] briefInfo_type_info = new String[]{'briefInfo','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] longInfo_type_info = new String[]{'longInfo','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] shortTitle_type_info = new String[]{'shortTitle','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] alwaysConsumable_type_info = new String[]{'alwaysConsumable','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] maxUserInstancesCount_type_info = new String[]{'maxUserInstancesCount','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] maxReceiptUsagesCount_type_info = new String[]{'maxReceiptUsagesCount','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] validFrom_type_info = new String[]{'validFrom','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] validTill_type_info = new String[]{'validTill','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] showFrom_type_info = new String[]{'showFrom','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] showTill_type_info = new String[]{'showTill','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] specialOfferHeadline_type_info = new String[]{'specialOfferHeadline','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] retailerSupplier_type_info = new String[]{'retailerSupplier','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] forAllStores_type_info = new String[]{'forAllStores','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] maxCouponCount_type_info = new String[]{'maxCouponCount','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] loyaltyProviderName_type_info = new String[]{'loyaltyProviderName','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] images_type_info = new String[]{'images','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] deliveryType_type_info = new String[]{'deliveryType','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] deliveryTypeDependentParameter_type_info = new String[]{'deliveryTypeDependentParameter','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] targetGroup_type_info = new String[]{'targetGroup','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] directCustomerAssignment_type_info = new String[]{'directCustomerAssignment','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] couponTaxHandlingType_type_info = new String[]{'couponTaxHandlingType','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] processingType_type_info = new String[]{'processingType','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] activationByUser_type_info = new String[]{'activationByUser','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] retailerStores_type_info = new String[]{'retailerStores','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] minProductValue_type_info = new String[]{'minProductValue','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] maxProductValue_type_info = new String[]{'maxProductValue','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] minReceiptValue_type_info = new String[]{'minReceiptValue','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] maxReceiptValue_type_info = new String[]{'maxReceiptValue','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] interval_type_info = new String[]{'interval','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] autoActivation_type_info = new String[]{'autoActivation','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] minProductUnitValue_type_info = new String[]{'minProductUnitValue','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] maxProductUnitValue_type_info = new String[]{'maxProductUnitValue','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] instanceCreationConditionType_type_info = new String[]{'instanceCreationConditionType','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] posProcessingSequence_type_info = new String[]{'posProcessingSequence','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] posProcessingResolution_type_info = new String[]{'posProcessingResolution','http://couponv2.api.extension.management.valuephone.com',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://couponv2.api.extension.management.valuephone.com','false','false'};
        private String[] field_order_type_info = new String[]{'id','unitType','briefInfo','longInfo','shortTitle','alwaysConsumable','maxUserInstancesCount','maxReceiptUsagesCount','validFrom','validTill','showFrom','showTill','specialOfferHeadline','retailerSupplier','forAllStores','maxCouponCount','loyaltyProviderName','images','deliveryType','deliveryTypeDependentParameter','targetGroup','directCustomerAssignment','couponTaxHandlingType','processingType','activationByUser','retailerStores','minProductValue','maxProductValue','minReceiptValue','maxReceiptValue','interval','autoActivation','minProductUnitValue','maxProductUnitValue','instanceCreationConditionType','posProcessingSequence','posProcessingResolution'};
    }
    public class CompoundCouponDefinition {
        public String couponType;
        public Integer buyAmount;
        public Integer getAmount;
        public Double value;
        public String currencyAlpha3;
        public String articleId;
        public DateTime createdOn;
        public shopinterfaceApi_D.ShopIdentifier[] retailerStores;
        public api_D.LabelValueData[] exclusionItems;
        public api_D.LabelValueData[] exclusionItemGroups;
        public api_D.LabelValueAmountData[] includedItems;
        public api_D.LabelValueAmountData[] includedItemGroups;
        public api_D.LabelValueData[] affectedItems;
        public api_D.LabelValueData[] affectedItemGroups;
        public api_D.LabelValueData[] activationItems;
        private String[] couponType_type_info = new String[]{'couponType','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] buyAmount_type_info = new String[]{'buyAmount','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] getAmount_type_info = new String[]{'getAmount','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] currencyAlpha3_type_info = new String[]{'currencyAlpha3','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] articleId_type_info = new String[]{'articleId','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] createdOn_type_info = new String[]{'createdOn','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] retailerStores_type_info = new String[]{'retailerStores','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] exclusionItems_type_info = new String[]{'exclusionItems','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] exclusionItemGroups_type_info = new String[]{'exclusionItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] includedItems_type_info = new String[]{'includedItems','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] includedItemGroups_type_info = new String[]{'includedItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] affectedItems_type_info = new String[]{'affectedItems','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] affectedItemGroups_type_info = new String[]{'affectedItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] activationItems_type_info = new String[]{'activationItems','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://couponv2.api.extension.management.valuephone.com','false','false'};
        private String[] field_order_type_info = new String[]{'couponType','buyAmount','getAmount','value','currencyAlpha3','articleId','createdOn','retailerStores','exclusionItems','exclusionItemGroups','includedItems','includedItemGroups','affectedItems','affectedItemGroups','activationItems'};
    }
    public class CouponV2Definition {
        public api_D.LabelValueData[] exclusionItems;
        public api_D.LabelValueData[] exclusionItemGroups;
        public api_D.LabelValueData[] activationItems;
        private String[] exclusionItems_type_info = new String[]{'exclusionItems','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] exclusionItemGroups_type_info = new String[]{'exclusionItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] activationItems_type_info = new String[]{'activationItems','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://couponv2.api.extension.management.valuephone.com','false','false'};
        private String[] field_order_type_info = new String[]{'exclusionItems','exclusionItemGroups','activationItems'};
    }
    public class WeightCouponInformation {
        public Double value;
        public String currencyAlpha3;
        public api_D.LabelValueAmountData[] includedItems;
        public api_D.LabelValueAmountData[] includedItemGroups;
        private String[] value_type_info = new String[]{'value','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] currencyAlpha3_type_info = new String[]{'currencyAlpha3','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] includedItems_type_info = new String[]{'includedItems','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] includedItemGroups_type_info = new String[]{'includedItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://couponv2.api.extension.management.valuephone.com','false','false'};
        private String[] field_order_type_info = new String[]{'value','currencyAlpha3','includedItems','includedItemGroups'};
    }
    public class BuyXGetDiscountCouponInformation {
        public Integer buyAmount;
        public Double value;
        public String currencyAlpha3;
        public api_D.LabelValueData[] includedItems;
        public api_D.LabelValueData[] includedItemGroups;
        private String[] buyAmount_type_info = new String[]{'buyAmount','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] currencyAlpha3_type_info = new String[]{'currencyAlpha3','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] includedItems_type_info = new String[]{'includedItems','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] includedItemGroups_type_info = new String[]{'includedItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://couponv2.api.extension.management.valuephone.com','false','false'};
        private String[] field_order_type_info = new String[]{'buyAmount','value','currencyAlpha3','includedItems','includedItemGroups'};
    }
    public class StandardCouponInformation {
        public Double value;
        public String currencyAlpha3;
        public api_D.LabelValueData[] includedItems;
        public api_D.LabelValueData[] includedItemGroups;
        private String[] value_type_info = new String[]{'value','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] currencyAlpha3_type_info = new String[]{'currencyAlpha3','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] includedItems_type_info = new String[]{'includedItems','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] includedItemGroups_type_info = new String[]{'includedItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://couponv2.api.extension.management.valuephone.com','false','false'};
        private String[] field_order_type_info = new String[]{'value','currencyAlpha3','includedItems','includedItemGroups'};
    }
    public class BuyItemAGetDiscountOnItemBCouponInformation {
        public Double value;
        public String currencyAlpha3;
        public api_D.LabelValueData[] affectedItems;
        public api_D.LabelValueData[] affectedItemGroups;
        public api_D.LabelValueData[] includedItems;
        public api_D.LabelValueData[] includedItemGroups;
        private String[] value_type_info = new String[]{'value','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] currencyAlpha3_type_info = new String[]{'currencyAlpha3','http://couponv2.api.extension.management.valuephone.com',null,'1','1','false'};
        private String[] affectedItems_type_info = new String[]{'affectedItems','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] affectedItemGroups_type_info = new String[]{'affectedItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] includedItems_type_info = new String[]{'includedItems','http://couponv2.api.extension.management.valuephone.com',null,'1','-1','false'};
        private String[] includedItemGroups_type_info = new String[]{'includedItemGroups','http://couponv2.api.extension.management.valuephone.com',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://couponv2.api.extension.management.valuephone.com','false','false'};
        private String[] field_order_type_info = new String[]{'value','currencyAlpha3','affectedItems','affectedItemGroups','includedItems','includedItemGroups'};
    }
}