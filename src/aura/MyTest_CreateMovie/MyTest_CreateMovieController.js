({
	AddToList : function(component, event, helper) {
        var validExpense = component.find('MovieForm').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(validExpense){
            var movie = component.get("v.movie");
            console.log("++++++Input Values:" + JSON.stringify(movie));
            
            helper.createMovie(component, movie);
            component.set("v.movie", {
                'sobjectType':'Movie__c',
                'Name':'',
                'Director__c':'',
                'ToStar__c':'',
                'ShowTime__c':'',
                'Number__c':0,
                'Flag__c':false
            });
        }
	}
})