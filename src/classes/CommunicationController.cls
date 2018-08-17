/*

*/

global with sharing class CommunicationController
{
    // ### HOTFIX ###
    // Trying to deploy this class without those properties caused an error on deployment.
    // The property <TYPE> <PROPERTYNAME> is referenced by Visualforce Page in salesforce.com. Remove the usage and try again.
    // See https://success.salesforce.com/issues_view?id=a1p300000008YkUAAU
    // TODO: delete this hotfix properties once deployed to production
    public Boolean isCustomerModus {get; set;}
    public Boolean isThirdLevelModus {get; set;}
    public Boolean isForwardInsuranceModus {get; set;}
    public String defaultEmailAddress {get; set;}
    public String forwardCustomerDefault {get; set;}
    public String forwardInsuranceDefault {get; set;}
    public String forwardSupplierDefault {get; set;}
    public String forwardRDCDefault {get; set;}
    public String forwardBuyerDefault {get; set;}
    public List<System.SelectOption> getDepartments() {return null;}
    public List<System.SelectOption> getServiceCountryCodes() {return null;}
    // ### HOTFIX END ###

    public Boolean isEmailSendModus {get; set;}
    public Boolean isLetterModus {get; set;}
    public Boolean isMainModus {get; set;}
    public Boolean isForwardQAModus {get; set;}
    public Boolean isForwardSupplierModus {get; set;}
    public Boolean isForwardRDCModus {get; set;}
    public Boolean isForwardBuyerModus {get; set;}
    public Boolean isDisplayPdf {get; set;}
    public Boolean isSaveAsName {get; set;}
    public Boolean isUploadAttachment {get; set;}
    public String currentModus {get; set;}

    public Boolean isTextBlocksPanel {get; set;}
    public Boolean isDraftsPanel {get; set;}
    public Boolean isTextSamplesPanel {get; set;}
    public Boolean isBodyPreview {get; set;}

    public static final String SAMPLE_TEXT          = 'Sample Text';
    public static final String FORWARD_OTHERS           = 'forwardOthers';
    public static final String COMMUNICATION_SUPPLIER   = 'communicationSupplier';
    public static final String FORWARD_RDC          = 'forwardRDC';
    public static final String FORWARD_QA               = 'forwardQA';
    public static final String FORWARD_BUYER            = 'forwardBuyer';
    public static final String CUSTOMER                 = 'Customer';
    public static final String CHATTER_ACTION_CONTACT = 'chatterActionContactBase';
    public static final String FORWARD_STORE = 'forwardStore';
    public static final String PRINT_TEMPLATE           = 'LidlPrint';

    public static Map<String, String> polymorphicCastTypes = new Map<String, String>();
    static
    {
        polymorphicCastTypes.put('owner', 'User');
    }

    public String errorMessage {get; set;}
    public String infoMessage {get; set;}

    public ServiceCountryConfiguration__c serviceCountryConfig {get; private set;}
    private final Id pageId;
    private String saveDocumentType;

    public String category {get; set;}
    public String serviceCountryCode {get; set;}
    public String selectedDepartment {get; set;}
    public List<SelectOption> fromAddresses;
    public String selectedFromAddress {get; set;}
    public String email {get; set;}
    public String cc {get; set;}
    public String bcc {get; set;}
    public String subject {get; set;}
    public String subjectRaw {get; set;}
    public String subjectPreview {get; set;}
    public String body {get; set;}
    public String bodyRaw {get; set;}
    public String bodyPreview {get; set;}
    public String documentName {get; set;}
    public String channel {get; set;}

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String street {get; set;}
    public String city {get; set;}
    public String state {get; set;}
    public String zip {get; set;}
    public String country {get; set;}

    public String selectedforwardReason {get; set;}
    public String selectedQuickCode {get; set;}
    public String selectedDraftId {get; set;}
    public String selectedTextBlockId {get; set;}
    public String openPanel {get; set;}
    public String contentSearch {get; set;}
    public String commPage {get; set;}
    public Attachment attachment
    {
        get
        {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    public Boolean isDisableForwardQADefault
    {
        get
        {
            return selectedforwardReason == 'Submit for Attention';
        }
        set;
    }
    public Boolean canClose
    {
        get {
            return String.isEmpty(this.errorMessage) && !isDisableForwardQADefault;
        }
        set;
    }
    public String toDeleteDraftId {get; set;}
    public String editedDraft {get; set;}
    public Attachment pdfDoc {get; set;}
    public String pdf
    {
        get
        {
            return EncodingUtil.Base64Encode(pdfDoc.body);
        }
    }
    public String forwardQADefault {get; set;}

    public Contact defaultContact {get; set;}
    public String defaultOwnerName {get; set;}
    public Id defaultOwnerId {get; set;}

    //SCSI-916, we should be able to show a recipient details section by default(Email,Assignment) even if Chatter Action Contact has no recipient.
    public Boolean isAssignment {get; set;}

    public String configurableSampleTextId {get; set;}
    public ComunicationService service {get; private set;}
    public Boolean showApprovalButton {set;
    get{
        return showApprovalButton();
    }
                                      }
    public String printSize {get; set;}

    public PageReference reloadLeftPanel()
    {
        return null;
    }

    public PageReference reloadEditor()
    {
        return null;
    }

    public List<DraftTemplate__c> draftTemplateList
    {
        get
        {
            //SCSI-831 US77
            return DraftTemplatesService.getRelatedDraftTemplatesByLng(new Set<String>(), this.selectedLanguageId, true);
        }
        set;
    }

    public List<TextBlock__c> textBlocks {get; set;}
    public List<TextBlock__c> textSamples {get; set;}
    public List<AttachmentItem> attachments {get; set;}
    public String activeTextSampleId {get; set;}
    public String activeDraftId {get; set;}
    public String rdcSampleTextId {get; set;}
    public String buyerSampleTextId {get; set;}
    public String supplierSampleTextId {get; set;}

    //From which page an end user came.
    private String previousPage;

    //To be able to controll some parts of functionality in generic way, configurable via custom metadata type.
    //Currently only lefst side section label is configurable.
    private static final String CHATTER_ACTION_META_QUILIFIER = 'ChatterActionConfiguration__mdt';
    public ChatterActionConfiguration__mdt chatterActionConfiguration {get; set;}

    //Chatter action handler interface to be able to inject any particular implementation in configurable way.
    @TestVisible
    private IChatterActionsHandler chatterActionHandler;

    //Indicator - whether it's a configurable with standard UI chater action.
    public Boolean isChatterActionContactConfigurableAction {get; set;}

    public ErrorLog__c initializationErrorLog;

    //If related text block takes place, then we should switch to a preview mode at once.
    public TextBlock__c initTextBlock {get; set;}

    //To be able to hadover work to separate cmps dynamically
    private static Map<String, String> handlersMpping = new Map<String, String>
    {
        CHATTER_ACTION_CONTACT => 'ChatterActionContactBaseHandler',
        FORWARD_RDC => 'RDCChatterActionHandler',
        COMMUNICATION_SUPPLIER => 'SupplierChatterActionHandler',
        FORWARD_STORE => 'StoreChatterActionHandler'
    };

    //SCSI-933, if an user has read-only access, then we don't show the interface and replace it with an appropriated msg.
    public Boolean isReadOnlyAccess {get; set;}

    //US75, SCSI-1196. If it's configured, for example on a chatter action contact record, we should close a context tab after an action.
    public Boolean isTabShouldBeClosed {get; set;}

    //SCSI-831 US77. To be able to change shown items.
    public Id selectedLanguageId {get; set;}

    //SCSI-831 US77. To be able to update a draft template record.
    public Id draftTemplateSelectedLanguageId {get; set;}

    public CommunicationController(ApexPages.StandardController apexController)
    {
        this.service = new ComunicationService();

        //By default it's false.
        this.isChatterActionContactConfigurableAction = false;

        //By default we assume that it isn't an assignment action.
        this.isAssignment = false;

        //By default we assume that an user has edit permissions on a record.
        this.isReadOnlyAccess = false;

        //US75, SCSI-1196. By default it's false.
        this.isTabShouldBeClosed = false;

        isEmailSendModus = true;
        isLetterModus = false;
        isMainModus = true;
        selectedDepartment = 'All';
        this.isTextBlocksPanel = true;
        this.isDraftsPanel = false;
        this.isTextSamplesPanel = false;
        this.subjectPreview = '';
        this.subjectRaw = '';
        this.body = '';
        this.bodyPreview = '';
        this.selectedQuickCode = '';
        this.selectedDraftId = '';
        this.selectedTextBlockId = '';
        this.openPanel = 'TextBlocks';
        this.contentSearch = '';
        this.commPage = apexpages.currentpage().getparameters().get('commpage') != null ? apexpages.currentpage().getparameters().get('commpage') : '';

        this.previousPage = apexpages.currentpage().getparameters().get('previousPage');

        if (apexController.getRecord() != null && apexController.getRecord().Id != null)
        {

            //SCSI-933, if an user has read-only access, then we don't show the interface and replace it with an appropriated msg.
            this.isReadOnlyAccess = !DatabaseUtils.isUserHasEditAccessOnRecord(UserInfo.getUserId(), apexController.getRecord().Id);
            if (isReadOnlyAccess)
            {
                this.errorMessage = Label.CommunicationInterfaceInsufficientPrivileges;
                return;
            }

            this.pageId = apexpages.currentpage().getparameters().get('page');

            this.bodyRaw = this.body;//TODO need this?
            this.subjectRaw = this.subject;
            this.isForwardQAModus = FORWARD_QA.equals(this.commPage) ? true : false;

            this.serviceCountryConfig =  null;

            //Try to initialize a particular handler for an action.
            if (String.isNotBlank(this.commPage))
            {
                String handlerApiName;
                //If is just defined via map.
                if (handlersMpping.containsKey(this.commPage))
                {
                    handlerApiName = handlersMpping.get(this.commPage);
                    //If it's an action which is configurable via Chatter Action Contact sobject.
                }
                else
                {
                    //Configurable via standard UI.
                    handlerApiName = handlersMpping.get(this.commPage);

                    
                }

                System.debug('!!!!!Handler API name: ' + handlerApiName);
                if (String.isNotBlank(handlerApiName))
                {
                    try
                    {
                        System.debug('-->handlerApiName:' + handlerApiName);
                        this.chatterActionHandler = (IChatterActionsHandler)Type.forName(handlerApiName).newInstance();
                    }
                    catch (Exception e)
                    {
                        this.errorMessage = e.getMessage();
                    }
                }
            }

        }
        loadTextBlock();
        loadAttachments();
        //If related text block takes place, then we should switch to a preview mode at once.
        if (String.isBlank(this.errorMessage) && initTextBlock != null)
        {
            this.body = String.isBlank(initTextBlock.TextContent__c) ? '' : initTextBlock.TextContent__c;
            this.subject = String.isBlank(initTextBlock.EmailSubject__c) ? '' : initTextBlock.EmailSubject__c;
            this.doContinue();
        }
    }


    public void setPreviewMode()
    {
        System.debug('++++++:setPreviewMode');
        //save raw text
        this.bodyRaw = this.body;
        this.subjectRaw = this.subject;
        this.bodyPreview = this.body;
        this.subjectPreview = this.subject;

        mergeFields();
        if (this.bodyPreview != null && this.bodyPreview.length() > 0)
        {
            this.body = this.bodyPreview;
        }
        if (this.subjectPreview != null && this.subjectPreview.length() > 0)
        {
            this.subject = this.subjectPreview;
        }
    }

    public void setRawMode()
    {
        this.body = this.bodyRaw;
        this.subject = this.subjectRaw;
    }

    public PageReference loadTextBlock ()
    {
        this.resetActiveDraftTemplateId();

        textBlocks = new List<TextBlock__c>();
        textSamples = new List<TextBlock__c>();

        //SCSI-831 US77. A language should be used as a criteria too.
        List<TextBlockItem__c> textBlockItems = TextBlocksService.getActiveCategoryAndCountryCodeRelatedTextBlockItemsByLng(
                new Set<String>(),
                this.serviceCountryCode,
                this.selectedLanguageId,
                true);

         System.debug('++++++:textBlockItems '+textBlockItems.size());
        for (TextBlockItem__c tbi : textBlockItems)
        {
            //Ignores text blocks on which an end user doesn't have permissions.
            String currentUserProfileId = String.valueOf(UserInfo.getProfileId());
            if (String.isNotBlank(tbi.TextBlock__r.AvailableForProfiles__c) && !tbi.TextBlock__r.AvailableForProfiles__c.contains(currentUserProfileId))
            {
                continue;
            }

            Boolean isQuickCode = String.isEmpty(this.selectedQuickCode) || (!String.isEmpty(this.selectedQuickCode) && tbi.TextBlock__r.QuickCode__c == this.selectedQuickCode);
            Boolean isContentSearch = String.isEmpty(this.contentSearch) || (!String.isEmpty(this.contentSearch) && tbi.TextBlock__r.TextContent__c != null && tbi.TextBlock__r.TextContent__c.containsIgnoreCase(this.contentSearch));

            //SCSI-924. 'ForwardTo' condition was removed.
            if (isQuickCode && isContentSearch)
            {
                TextBlock__c tb = new TextBlock__c(Id = tbi.TextBlock__c, TextBlockName__c = tbi.TextBlock__r.TextBlockName__c, TextContent__c = tbi.TextBlock__r.TextContent__c);

                if (tbi.TextBlock__r.Type__c != SAMPLE_TEXT)
                {
                    textBlocks.add(tb);

                }
                else if (tbi.TextBlock__r.Type__c == SAMPLE_TEXT)
                {
                    textSamples.add(tb);
                }
            }
            System.debug('++++++:textBlocks '+textBlocks.size());
            System.debug('++++++:textSamples '+textSamples.size());
        }
        return null;
    }

    private Boolean isForwardQAPage()
    {
        return !FORWARD_QA.equals(this.commPage);
    }

    /*
    * Select all manually created attachments and inbound emails attachments
     */
    public void loadAttachments ()
    {
        this.attachments = AttachmentsService.wrapAttachmentsForSelectionOnUI(AttachmentsService.getRelatedAttachments('CAT001', false));
        
    }

    public PageReference emailModus ()
    {
        isEmailSendModus = true;
        isLetterModus = false;
        return null;
    }

    public PageReference letterModus ()
    {
        isEmailSendModus = false;
        isLetterModus = true;
        return null;
    }

    public List<SelectOption> getForwardReason ()
    {
        List<SelectOption> result = new List<SelectOption>();
        return result;
    }

    @RemoteAction
    global static List<TextBlock__c> searchQuickCodes(String searchTerm)
    {
        string input = '%' + searchTerm + '%';
        return [Select  QuickCode__c from TextBlock__c where QuickCode__c like :input order by Name ASC];
    }

    /*
    *   descrition : query user for forwording (originally queue was also in the query but has been removed)
     */
    @RemoteAction
    global static List<UserQueue> searchUserQueue(String searchTerm)
    {
        return UserService.searchUserQueue(searchTerm);
    }

    /*
    *   descrition : query user for forwording
     */
    @RemoteAction
    global static List<UserQueue> searchUser(String searchTerm)
    {
        return UserService.searchUser(searchTerm);
    }

    @RemoteAction
    global static List<Contact> searchContact(String searchTerm)
    {
        List<Contact> result = new List<Contact>();
        string input = '%' + searchTerm + '%';
        Contact[] contacts =  [Select Id, FirstName, LastName, OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, Fullname__c, Email
                               from Contact where Fullname__c like :input order by Fullname__c ASC];

        for (Contact contact : contacts)
        {

            result.add(contact);
        }

        return result;
    }

    public PageReference submitForApproval()
    {
        clearMessages();

        if (String.isEmpty(email))
        {
            errorMessage = Label.InvalidEmailAddress;
            return null;
        }

        if (String.isEmpty(subject))
        {
            errorMessage = Label.MissingSubjectError;
            return null;
        }

        // Set the Organization-Wide Email Address
        String fromAddress = '';
        if (String.isNotEmpty(selectedFromAddress) && selectedFromAddress != '-')
        {
            OrgWideEmailAddress[] fromAddresses = [select Id, Address from OrgWideEmailAddress where Id = :selectedFromAddress];
            if (fromAddresses != null && fromAddresses.size() == 1)
            {
                fromAddress = fromAddresses[0].Address;
            }
        }

        MessageInApproval__c mia = new MessageInApproval__c(
            TextContent__c = body,
            From__c = fromAddress,
            To__c = email,
            Cc__c = cc,
            Bcc__c = bcc,
            Subject__c = subject,
            Status__c = 'Waiting for Approval',
            IsCustomerCommunication__c = this.commPage == CUSTOMER ? true : false
        );

        insert mia;

        //US119, SCSI-1246. Related attachments have to be preserved for future usage, after an approve.
        //DE89. We have to retrieve attachments with Body.

        List<Attachment> relatedAttachmentsToBeMovedOnMia = AttachmentsService.getRelatedAttachments('CAT001', true);
        if (relatedAttachmentsToBeMovedOnMia.size() > 0)
        {
            relatedAttachmentsToBeMovedOnMia = relatedAttachmentsToBeMovedOnMia.deepClone(false, false, false);
            for (Attachment attach : relatedAttachmentsToBeMovedOnMia)
            {
                attach.ParentId = mia.Id;
            }
            insert relatedAttachmentsToBeMovedOnMia;
        }


        this.infoMessage = Label.MessageSubmitForApproval;

        return null;
    }

    @TestVisible
    private Boolean showApprovalButton()
    {
        Set<String> serviceAgentProfiles = new Set<String>();
        //for (ProfileGroupConfiguration__mdt profileMetadata : [select ServiceAgentProfileName__c from ProfileGroupConfiguration__mdt])
        //{
        //    serviceAgentProfiles.add(profileMetadata.ServiceAgentProfileName__c);
        //}

        Profile currentProfile = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];

        if (serviceAgentProfiles.contains(currentProfile.Name))
        {
            return true;
        }

        return false;

    }

    public PageReference send()
    {
        System.debug('Enter main send method');
        errorMessage = null;
        infoMessage = null;

        //If a particular chatter action handler takes place, delegates sending related actions to it.
        if (this.chatterActionHandler != null)
        {
            if (!this.validateBeforeSendAction())
            {
                return null;
            }
            this.chatterActionHandler.handleNotification();
            //Otherwise to maintain the old logic.
        }
        else
        {
            setPreviewMode();

            this.sendEmail();
        }

        return null;
    }

    /**
    *    @description
    *    @param commCtrl a parent controller instance.
    */
    private Boolean validateBeforeSendAction()
    {
        Boolean result = true;

        if (this.isAssignment && String.isBlank(this.defaultOwnerId))
        {
            errorMessage = Label.MissingAsigneeError;
            result = false;
        }
        else if (!this.isAssignment)
        {
            if (!EmailHelper.isValidEmailAddresses(this.email))
            {
                errorMessage = Label.InvalidEmailAddress;
                result = false;
            }

            if (String.isEmpty(this.subject))
            {
                errorMessage = Label.MissingSubjectError;
                result = false;
            }
        }

        return result;
    }

    public void sendEmail()
    {
        System.debug('#### entering sendEmail()');
        //validate mandatory fields
        if (!this.validateBeforeSendAction())
        {
            return;
        }

        System.debug('#### get Templates');

        //System.debug('#### templateAsHtml: '+templateAsHtml);

        System.debug('#### send Email per service');

        System.debug('selectedFromAddress ' + this.selectedFromAddress);

        List<AttachmentItem> attachmentsWithBody = AttachmentsService.wrapAttachmentsForSelectionOnUI(AttachmentsService.getRelatedAttachments('CAT001', true));
        
        //Fix for ignoring the unchecked attachments
        Set<id> selectedAttachmentsSet = new Set<id>();
        for(AttachmentItem ai : attachments){
            if(ai.isChecked){
                selectedAttachmentsSet.add(ai.att.id);
            }
        }

        List<AttachmentItem> selectedAttachmentsWithBody = new List<AttachmentItem>();
        for(AttachmentItem attach : attachmentsWithBody){
            if(selectedAttachmentsSet.contains(attach.att.id)){
                selectedAttachmentsWithBody.add(attach);
            }
        }
        
        Message sendingMessage = service.sendEmail(this.email, this.cc, this.bcc, this.subject, this.body, selectedAttachmentsWithBody);
        
        errorMessage = sendingMessage.errorMessage;
        infoMessage = sendingMessage.infoMessage;

    }

    public PageReference doContinue ()
    {
        ApexPages.getMessages().clear();
        errorMessage = null;
        infoMessage = null;
        isMainModus = false;

        /**
        if (!isForwardQAModus)
        {
            setEmailSubject();
        }
        */

        setPreviewMode();
        return null;
    }

    public void setEmailSubject()
    {
        System.debug('++++++:setEmailSubject');
        if (!String.isEmpty(this.selectedTextBlockId) && (this.openPanel == 'TextSamples'))
        {

            TextBlockItem__c[] selectedTbi = [
                                                 Select TextBlock__r.EmailSubject__c
                                                 From TextBlockItem__c
                                                 where Category__r.Name = :category
                                                         and TextBlock__c = :selectedTextBlockId
                                                                 and TextBlock__r.Type__c = 'Sample Text'
                                             ];
            if (selectedTbi.size() == 1)
            {
                this.subject = selectedTbi[0].TextBlock__r.EmailSubject__c;
            }
        }
    }

    public PageReference setEmailOrLetterModus ()
    {
        currentModus = (String)System.currentPagereference().getParameters().get('modus');
        return null;
    }

    public PageReference setCategoryFilter ()
    {
        category = (String)System.currentPagereference().getParameters().get('category');
        loadTextBlock();
        return null;
    }

    public PageReference setCategoryFilterId ()
    {
        String categoryId = (String)System.currentPagereference().getParameters().get('categoryId');
        Category__c[] categories = [select Name from Category__c where Id = :categoryId];
        if (categories != null && categories.size() == 1)
        {
            loadTextBlock();
        }

        return null;
    }

    public PageReference setQuickCodesFilter ()
    {
        this.selectedQuickCode = (String)System.currentPagereference().getParameters().get('quickCodes');
        loadTextBlock();
        return null;
    }

    public PageReference setContentSearchFilter ()
    {
        this.contentSearch = (String)System.currentPagereference().getParameters().get('contentSearch');
        loadTextBlock();
        return null;
    }

    public PageReference setCurrentDraft ()
    {
        this.selectedDraftId = (String)System.currentPagereference().getParameters().get('currentDraft');

        return null;
    }

    public PageReference setActiveDraftId ()
    {
        //SCSI-831 US77. Resets previously selected draft item.
        this.resetActiveDraftTemplateId();

        this.activeDraftId = (String)System.currentPagereference().getParameters().get('activeDraftId');

        return null;
    }

    public PageReference setActiveTextSampleId ()
    {
        this.activeTextSampleId = (String)System.currentPagereference().getParameters().get('activeTextSampleId');

        return null;
    }


    public PageReference deleteDraft ()
    {
        //SCSI-831 US77. Resets previously selected draft item.
        this.resetActiveDraftTemplateId();

        String toDeleteDraftId = (String)System.currentPagereference().getParameters().get('toDeleteDraftId');

        List<DraftTemplate__c> drafts = [select id from DraftTemplate__c where id = :toDeleteDraftId];
        if (drafts.size() > 0 && Schema.sObjectType.DraftTemplate__c.isDeletable())
        {
            delete drafts[0];
        }

        return null;
    }

    /**
    *   @description SCSI-831 US77. Resets previously selected draft item.
    */
    private void resetActiveDraftTemplateId()
    {
        if (String.isNotBlank(this.editedDraft))
        {
            this.editedDraft = null;
        }

        if (String.isNotBlank(this.draftTemplateSelectedLanguageId))
        {
            this.draftTemplateSelectedLanguageId = null;
        }

        if (String.isNotBlank(this.activeDraftId))
        {
            this.activeDraftId = null;
        }
    }

    public PageReference setEditedDraft ()
    {
        this.editedDraft = (String)System.currentPagereference().getParameters().get('editedDraft');

        //SCSI-831 US77. Related draft item language.
        String activeDraftLanguageStr = (String)System.currentPagereference().getParameters().get('editDraftLanguage');
        if (String.isNotBlank(activeDraftLanguageStr))
        {
            this.draftTemplateSelectedLanguageId = Id.valueOf(activeDraftLanguageStr);
        }

        return null;
    }

    public PageReference doSaveDraft ()
    {
        //SCSI-831 US77. Context items should be reloaded.
        this.selectedLanguageId = this.draftTemplateSelectedLanguageId;

        String saveDraftId = (String)System.currentPagereference().getParameters().get('saveDraftId');
        String newContent = (String)System.currentPagereference().getParameters().get('newContent');
        try
        {
            //SCSI-831 US77. A language should be used for an update as well.
            DraftTemplatesService.updateRecord(saveDraftId, newContent, this.selectedLanguageId);
            this.infoMessage = Label.DraftSaved;
             this.loadTextBlock();
        }
        catch (Exception ex)
        {
            this.errorMessage = ex.getMessage();
        }
        return null;
    }

    public PageReference doPrint ()
    {
        errorMessage = null;
        infoMessage = null;
        isDisplayPdf = true;

        this.pdfDoc = new Attachment();
        this.pdfDoc.Name = 'CommunicationPdf';

        this.printSize = serviceCountryConfig.LetterFormat__c;

        return null;
    }

    public PageReference doCreate ()
    {
        isSaveAsName = true;
        saveDocumentType = 'Letter';

        return null;
    }

    public PageReference upload ()
    {
        attachment.OwnerId = UserInfo.getUserId();
        List<Category__c> catLst = [SELECT ID FROM Category__c WHERE Name='CAT001' LIMIT 1];

        attachment.ParentId = catLst[0].ID;
        attachment.IsPrivate = true;

        System.debug('!!!!!Attachment: ' + attachment);

        if (String.isBlank(attachment.Name))
        {
            errorMessage = System.Label.AttachmentNameMaxLength;
            isUploadAttachment = false;
            return null;
        }

        /*//DE89. Maximum name length is 80.
        attachment.Name = attachment.Name.abbreviate(80);*/

        try
        {
            insert attachment;
            infoMessage = Label.FileUploadedInfo;
            loadAttachments();

        }
        catch (DMLException e)
        {
            errorMessage = e.getMessage();
            return null;
        }
        finally
        {
            attachment = new Attachment();
            isUploadAttachment = false;
        }

        return null;

    }

    public PageReference create ()
    {
        if (String.isEmpty(documentName) || String.isEmpty(this.body))
        {
            errorMessage = Label.MissingValueField;
            return null;
        }
        errorMessage = null;
        infoMessage = null;

        if (saveDocumentType == 'Letter')
        {
            createLetter();
        }
        else if (saveDocumentType == 'Draft')
        {
            createDraft();
        }

        isSaveAsName = false;
        if (errorMessage == null)
        {
            isDisplayPdf = false;
            isMainModus = true;
        }

        loadAttachments();

        return null;
    }

    public void createLetter ()
    {
        try
        {
            ApexPages.Pagereference savePDF = Page.CommunicationPdf2;
            //savePDF.getParameters().put('id', this.newcase.Id);
            savePDF.getParameters().put('printsize', this.printSize);

            //service.postFileToChatter(documentName, savePDF.getContentAsPDF(), this.newcase.Id);

            infoMessage = Label.DocumentPostedToChatter;
        }
        catch (Exception e)
        {
            errorMessage = e.getMessage();
            System.debug(e);
        }
    }

    public PageReference doCancel ()
    {
        ApexPages.getMessages().clear();
        errorMessage = null;
        infoMessage = null;

        isSaveAsName = false;
        isUploadAttachment = false;
        isDisplayPdf = false;
        isMainModus = true;
        setRawMode();

        return null;
    }

    public PageReference uploadAttachment ()
    {
        errorMessage = null;
        infoMessage = null;
        isUploadAttachment = true;

        return null;
    }


    public PageReference saveDraft ()
    {
        errorMessage = null;
        infoMessage = null;
        isSaveAsName = true;
        saveDocumentType = 'Draft';

        return null;
    }

    public void createDraft ()
    {
        try
        {
            //SCSI-831 US77. A language should be used for a create as well.
            DraftTemplatesService.createRecord(documentName, this.body, this.channel);
            infoMessage = Label.DraftCreatedInfo;
        }
        catch (DmlException e)
        {
            this.errorMessage = e.getMessage();
        }
    }

    public void showTextBlocksPanel()
    {
        this.isTextBlocksPanel = true;
        this.isDraftsPanel = false;
        this.isTextSamplesPanel = false;
        this.openPanel = 'TextBlocks';
    }

    public void showDraftsPanel()
    {
        this.isTextBlocksPanel = false;
        this.isDraftsPanel = true;
        this.isTextSamplesPanel = false;
        this.openPanel = 'Drafts';
    }

    public void showTextSamplesPanel()
    {
        this.isTextBlocksPanel = false;
        this.isDraftsPanel = false;
        this.isTextSamplesPanel = true;
        this.openPanel = 'TextSamples';
    }

    public void mergeFields()
    {
        System.debug('++++++:mergeFields');
        String content = this.body;
        String subject = this.subject == null ? '' : this.subject;

        this.bodyRaw = content;
        this.subjectRaw = subject;
        Set<String> fieldsList = FieldUtils.getAllVariables(content);
        Set<String> subjectList = FieldUtils.getAllVariables(subject);
        fieldsList.addAll(subjectList);

        if (fieldsList.size() == 0)
        {
            return;
        }

    }

    private String replaceIgnoreCase(String fromString, String what, String with)
    {
        String replaceToken = '(?i)' + what;
        return fromString.replaceAll(replaceToken, with);
    }

    public PageReference setIsSelectedToFalse ()
    {
        infoMessage = null;
        return null;
    }

    public PageReference backToPreviousPage()
    {
        if (String.isBlank(this.previousPage))
        {
            return null;
        }

        PageReference previousPageRef = new PageReference('/' + this.previousPage);
        //previousPageRef.getParameters().put('id', newcase.Id);
        return previousPageRef.setRedirect(true);
    }

    //Method called at VF page initialization to allow to save the error log created in the constructor
    public PageReference persistErrorLog()
    {
        if (this.initializationErrorLog != null)
        {
            insert initializationErrorLog;
            initializationErrorLog = null;
        }

        return null;
    }

    private void clearMessages()
    {
        errorMessage = null;
        infoMessage = null;
    }

    @TestVisible
    private Boolean isPolymorphic(String column)
    {
        for (String key : polymorphicCastTypes.keySet())
        {
            if (column.containsIgnoreCase(key + '.'))
            {
                return true;
            }
        }

        return false;
    }

    private String getPolymorphicValue(String column, String id)
    {
        System.debug('polymorphic key found ' + column);
        String columnEscaped = String.escapeSingleQuotes(column.substringAfter('.'));
        String tableEscaped = polymorphicCastTypes.get(column.substringBefore('.'));
        String query = 'select ' + columnEscaped + ' from ' + tableEscaped + ' where Id = :id LIMIT 1';
        System.debug('query ' + query);
        SObject[] queriedObject = Database.query(query);


        if (queriedObject != null && queriedObject.size() == 1)
        {
            return StringUtils.default(queriedObject[0].get(column.substringAfter('.')));
        }

        return '';
    }

    public List<SelectOption> getFromAddresses()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-', UserInfo.getUserEmail()));
        this.selectedfromAddress = UserInfo.getUserEmail();

        for (OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress ORDER BY Address])
        {
            options.add(new SelectOption(owa.Id, owa.Address));
        }

        return options;
    }

}