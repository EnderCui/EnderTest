/**
*   @description To be able to provide common interface of interaction with chatter actions related functionality.

*/
public interface IChatterActionsHandler 
{
    void handleInitialization(CommunicationController commCtrl);

    /**
     *  US123, SCSI-1076. Intermmediate logic.
     */
    void doAdditionalActionsBeforePersist(List<Case> cases);

    /**
     * Logic executed after the initialization
     */
    void postInitialization();
    void handleNotification();

    //DE32
    String getActionDefinedCaseStatus();
}