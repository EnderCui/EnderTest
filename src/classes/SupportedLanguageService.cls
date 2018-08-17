/*
*   @description SupportedLanguageService functionality.
*/
public class SupportedLanguageService
{
    public static final List<String> uniqueFieldWithAndCondition = new List<String>
    {
        'ServiceCountry__c',
        'Language__c'
    };

    /**
    *  @description SCSI-1159 US70 Prevention of creation duplicates
    */

    public static void verifyDefaultUniqueness(List<SupportedLanguage__c> supportedLanguages)
    {
        Set<Id> serviceCountryIds = Utils.getParentIdSet('ServiceCountry__c', supportedLanguages);
        Set<Id> serviceCountryIdsWithDefaultSet = getServiceCountriesWithDefaultLngSet(serviceCountryIds);
        verifyDuplicatedDefault(supportedLanguages, serviceCountryIdsWithDefaultSet);
    }

    private static void verifyDuplicatedDefault(List<SupportedLanguage__c> supportedLanguages, Set<Id> serviceCountryIdsWithDefaultSet)
    {
        Set<Id> newSupportedLanguagesDefaultsSet = new Set<Id>();
        for (SupportedLanguage__c suppLng : supportedLanguages)
        {

        }
    }

    /**
    *  @description SCSI-1159 US70 Returns records based on Default__c field
    */
    private static Set<Id> getServiceCountriesWithDefaultLngSet(Set<Id> serviceCountryIds)
    {
        List<SupportedLanguage__c> serviceCountryWithDefaultLng = [SELECT ServiceCountry__c FROM SupportedLanguage__c WHERE Default__c = true];
        return Utils.getParentIdSet('ServiceCountry__c', serviceCountryWithDefaultLng);
    }

    /**
    *  @description SCSI-1160 US71 Returns records based on provided country code string
    */
    public static List<SupportedLanguage__c> getRecordsByServiceCountryCode(String code)
    {
        List<SupportedLanguage__c> result = new List<SupportedLanguage__c>();



        return result;
    }


    /**
    *  @description SCSI-1160 US71 Wrapper over a case related(it's country code string) languages and over a default value
    */
    public class ServiceCountryConfigRelatedLanguagesWrapper
    {
        public List<SelectOption> languages {get; set;}
        public Id defaultLanguageId {get; set;}

        public ServiceCountryConfigRelatedLanguagesWrapper()
        {
            this.languages = new List<SelectOption>();
        }

        public ServiceCountryConfigRelatedLanguagesWrapper(List<SupportedLanguage__c> supportedLanguages)
        {
            this();
            for (SupportedLanguage__c supportedLanguage : supportedLanguages)
            {
                SelectOption selectOption = new SelectOption(supportedLanguage.Language__c, supportedLanguage.Language__r.Name);
                this.languages.add(selectOption);
                if (String.isBlank(this.defaultLanguageId) && supportedLanguage.Default__c != null && supportedLanguage.Default__c)
                {
                    defaultLanguageId = supportedLanguage.Language__c;
                }
            }
        }

        public void tryToPutNewLng(Id languageId, String languageName)
        {
            Boolean isListContainsProvidedLng = false;
            for (SelectOption option : this.languages)
            {
                if (Id.valueOf(option.getValue()) == languageId)
                {
                    isListContainsProvidedLng = true;
                    break;
                }
            }

            if (!isListContainsProvidedLng)
            {
                SelectOption newLng = new SelectOption(languageId, languageName);
                this.languages.add(newLng);
            }
        }
    }
}