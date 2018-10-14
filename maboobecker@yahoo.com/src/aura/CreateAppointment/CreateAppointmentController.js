({
    afterScriptsLoaded: function(component,evt,helper){
        console.log('recordId'+component.get("v.recordId"));
        var events = component.get("v.events");
        var action = component.get("c.getCustomerInfo"); 
        var self = this;
        action.setParams({
            "leadId" : component.get("v.recordId")
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                component.set("v.leadDetails", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
        
        if(!events.length)
        {
            helper.fetchEvents(component);
        }
    }, 
    closePopup : function(component, event, helper) {
        component.set("v.openEvent", false);
    },
    closeConflict : function(component, event, helper) {
        component.set("v.confirmation", false);
    },
    checkAvailablityCall : function(component, event, helper) {
        var app = component.get("v.appoinment"); 
    	var checkAvailablityAction = component.get("c.checkAvailablity");  
        checkAvailablityAction.setParams({"newEvt" : app,                                  
                                   "startTime" : component.get("v.startTime"),
                                   "endTime" : component.get("v.endTime"),
                                   "eventDate" : component.get("v.eventDate")});
    	checkAvailablityAction.setCallback(this,function(response){
            var state = response.getState();            
            if(state === 'SUCCESS'){
                if(!response.getReturnValue()) {
                    component.set("v.confirmation", true);
                }
                else
                    helper.saveEventCall(component, event, helper);
            }
            else 
                helper.saveEventCall(component, event, helper);
        });
        $A.enqueueAction(checkAvailablityAction);
    },
    saveAction : function(component, event, helper) {
    	helper.saveEventCall(component, event, helper);
	}
    

})