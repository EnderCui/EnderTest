({
	createMovie : function(component, movie) {
        var action = component.get("c.saveMovie");
        action.setParams({
            "movie": movie
        })
		
        action.setCallback(this, function(response){
            var state = response.getState();
        if(state === "SUCCESS"){
            var movieList = component.get("v.movieList");
            movieList.push(response.getReturnValue());
            component.set("v.movieList", movie);
        }
        });
        
        var movie = component.get("v.movie");
        $A.enqueueAction(action);
	}
})