({
	GetMovie : function(component, event) {
		var action = component.get("c.GetAll");
        action.setCallback(this, function(response){
            var state = response.getState();
        if (state == "SUCCESS"){
            var movieList = response.getReturnValue();
            if (movieList == 0){
                component.set("v.message", true);
            }else{
                component.set("v.message", false);
            }
            
            component.set("v.results", movieList);
            component.set("v.count", movieList.length);
        }
        });
        
        $A.enqueueAction(action);
	}
})