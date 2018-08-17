/**
*   @description Wrapper class over 'User' or 'Queue'

*/
global with sharing class UserQueue
{
    public Id id {get; set;}
    public String name {get; set;}
    public String type {get; set;}

    public UserQueue(Id id, String name, String type)
    {
        this.id = id;
        this.name = name;
        this.type = type;
    }
}