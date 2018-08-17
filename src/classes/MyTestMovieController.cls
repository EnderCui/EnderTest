public class MyTestMovieController {
    
    @AuraEnabled
    public static List<Movie__c> GetAll(){
        List<Movie__c> movieList = new List<Movie__c>();
        movieList = [SELECT ShowTime__c, ToStar__c, Theme__c, Director__c, Name 
                    FROM Movie__c LIMIT 100];
        
        return movieList;
    }

}