/**
*   @description Wrapper class over 'User' for related and potentially reusable logic.

*/
public with sharing class UserService
{
    public static List<User> getActiveCommunityUserByEmail(List<String> fields, String userLicenseName, String email)
    {
        String query = 'SELECT ';
        query += String.join(fields, ',');
        query += ' FROM User';
        query += ' WHERE isActive = true AND Profile.UserLicense.Name =: userLicenseName AND Email =: email';
        query += ' LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        return (List<User>)Database.query(query);
    }

    public static List<User> getActiveCommunityUsers(List<String> fields, String userLicenseName, List<String> emails)
    {
        String query = 'SELECT ';
        query += String.join(fields, ',');
        query += ' FROM User';
        query += ' WHERE isActive = true AND Profile.UserLicense.Name =: userLicenseName AND Email IN: emails';
        query += ' LIMIT ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());

        return (List<User>)Database.query(query);
    }

    /*
    *   descrition : query user for forwording (originally queue was also in the query but has been removed)
     */
    public static List<UserQueue> searchUserQueue(String searchTerm)
    {
        List<UserQueue> result = new List<UserQueue>();
        string input = '%' + searchTerm + '%';
        User[] users =  [Select Id, Name from User where Name like :input and IsActive = true and Profile.UserLicense.Name = 'Salesforce' order by Name ASC];
        Group[] queues = [select Id, DeveloperName from Group where Name like :input and Type = 'Queue'];

        for(User user : users)
        {
            result.add(new UserQueue(user.Id, user.Name, 'User'));
        }

        for(Group grp : queues)
        {
            result.add(new UserQueue(grp.Id, grp.DeveloperName,  'Queue'));
        }

        return result;
    }

    /*
    *   descrition : query user for forwording
     */
    public static List<UserQueue> searchUser(String searchTerm)
    {
        List<UserQueue> result = new List<UserQueue>();
        string input = '%' + searchTerm + '%';
        User[] users =  [Select Id, Name from User where Name like :input and IsActive = true and Profile.UserLicense.Name = 'Salesforce' order by Name ASC];

        for (User user : users)
        {

            result.add(new UserQueue(user.Id, user.Name, 'User'));
        }

        return result;
    }

}