/*
*   @description AttachmentItem

*/

public class AttachmentItem
{
    public Boolean isChecked {get; set;}
    public Attachment att {get; set;}

    public AttachmentItem (Attachment att)
    {
        this.att = att;
        isChecked = false;
    }
}