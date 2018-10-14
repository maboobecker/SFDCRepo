({
    loadDataToCalendar :function(component, data){   
        console.log('data==>'+data);
        $('#calendar').fullCalendar({
            header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month, agendaWeekDays, agendaWeek, agendaDay' //, prevSP, nextSP'
        },
        buttonText: {
            today: 'Today',
            multiResourceWeek:'week',
            multiResourceWeekDays: 'weekdays',
            agendaWeekDays: 'weekdays'
        },
        businessHours: {          
          dow: [ 1, 2, 3, 4, 5], 
        
          start: '06:00', 
          end: '20:00', 
        },
        editable: true,
        droppable: true,
        selectable: true,
        selectHelper: true,
        height: 400,
        minTime: '06:00:00',
        maxTime: '20:00:00',
        eventOverlap: true,
        firstDay: 0,
        defaultDate: moment().subtract(moment().day(), 'days'),
        slotDuration: '00:60:00',
        slotLabelInterval: '00:60:00',
        eventLimit: true,
        timezone: 'America/Los_Angeles',
        nowIndicator: true,
       // now: moment().tzn(savedTimeZoneVal || timeZoneValNew).format(),
        views: {                       
            agendaWeek:{
            	//titleFormat: calendarLocaleTitleFormat[dateFormatLocale].agendaWeek
            },
            agendaWeekDays:{
                type: 'agendaWeek',
                duration: { days: 7 },
                //titleFormat: calendarLocaleTitleFormat[dateFormatLocale].agendaWeek,
                //columnFormat: calendarLocaleTitleFormat[dateFormatLocale].columnFormat,
                hiddenDays: [0, 6] // Hide Sunday and Saturday?
            }
        },
        defaultView:'agendaWeek',

        handleWindowResize: true,
        allDaySlot: false,

        /*
        selectOverlap: function(event) {
            return event.rendering != 'background';
        },
        */
        eventDrop: function(event, delta, revertFunc) {
            alert('eventDrop');
        },
        dayClick: function(date, jsEvent, view) {
            //alert('dayClick'+date);
        },
        eventClick: function(event, jsEvent, view) {
            alert('eventClick');
        },
        select: function(start, end, jsEvent, view) {
            console.log('select'+start.format("YYYY-MM-DD HH:mm:ss")+' :: '+end);
            var newEvent = component.get("v.appoinment");            										
            //newEvent.StartDateTime = start.format("YYYY-MM-DD HH:mm:ss");
            //newEvent.EndDateTime = end.format("YYYY-MM-DD HH:mm:ss");
            var selectedStartDate = new Date(start.format("YYYY-MM-DD HH:mm:ss"));
            var selectedEndDate = new Date(end.format("YYYY-MM-DD HH:mm:ss"));
            var startTime = selectedStartDate.getHours() +':'+selectedStartDate.getMinutes();
            var endTime = selectedEndDate.getHours() +':'+selectedEndDate.getMinutes();
            console.log('startTime==>'+startTime);
            component.set("v.startTime", startTime);
            component.set("v.endTime", endTime);
            component.set("v.eventDate", start.format("YYYY-MM-DD HH:mm:ss"));
            newEvent.WhoId = component.get("v.recordId");
            newEvent.Location = component.get("v.leadDetails").Address;
            component.set("v.appoinment", newEvent);
            component.set("v.openEvent", true);
        },
        eventRender: function(event, el) {
            // render the timezone offset below the event title
            /*el.find('.fc-title').after(
                $('<div class="primarySp">+'+event.primarySPName+'</div><div class="appointmentType">'+event.appointmentName+'</div>')
            );          */  
        },
        eventAfterRender: function(event, element) {
            //eventAfterRenderHandler(event, element);
        },
        resourceRender: function(resourceObj, labelTds, bodyTds) {
            //var title = resourceObj.fullname;
            //labelTds.attr('title', title);
        },
        resources: [],
        events:data            
        });
    },

    tranformToFullCalendarFormat : function(component,events) {
        var eventArr = [];
        for(var i = 0;i < events.length;i++){
            eventArr.push({
                'id':events[i].eventId,
                'start':events[i].StartDateTime,
                'end':events[i].EndDateTime,
                'title':events[i].Subject
            });
        }
        return eventArr;
    },

    fetchEvents : function(component) {
        var action = component.get("c.getEvents"); 
        var self = this;
        action.setParams({
            "leadId" : component.get("v.recordId")
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){

                var eventArr = self.tranformToFullCalendarFormat(component,JSON.parse(response.getReturnValue()));
                self.loadDataToCalendar(component, eventArr);
                component.set("v.events",eventArr);
            }
        });

        $A.enqueueAction(action); 
    },
    saveEventCall : function(component, event, helper) {
        
               /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                "title": 'Success!',
                "message": 'Appoinment Created Successfully',
                "type": 'success',
                "mode" : 'dismissible'        
                });
                toastEvent.fire();

            	this.closePopup(component, event, helper);    */
        var app = component.get("v.appoinment");          
        var saveEventAction = component.get("c.saveEvent");
        saveEventAction.setParams({"newEvt" : app,                                  
                                   "startTime" : component.get("v.startTime"),
                                   "endTime" : component.get("v.endTime"),
                                   "eventDate" : component.get("v.eventDate")});
    	saveEventAction.setCallback(this,function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var eventResponse = JSON.parse(response.getReturnValue()); 
                console.log('==>'+response.getReturnValue()); 
                if(eventResponse.hasErrors == false) {              
                    if(!component.get("v.classic")) {
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                          "recordId": eventResponse.oppId,
                          "slideDevName": "related"
                        });
                        navEvt.fire();                  
                    	component.set("v.openEvent", false);
                    }
                    else {

                        location.replace("/"+eventResponse.oppId)                    
                    }
                }                 
	            else {
	            	var validationErrors = 'Errors.\n'
	            	for(var i=0; i<eventResponse.messages.length; i++) {
	            		validationErrors +=  i+1 +'.'+eventResponse.messages[i]+'\n';
	            	}
	            	var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    "title": 'Error!',
                    "message": validationErrors,
                    "type": 'error',
                    "mode" : 'dismissible'        
                    });
                    toastEvent.fire();
                    }  
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                "title": 'Error!',
                "message": 'Problem while saving your appoinment',
                "type": 'error',
                "mode" : 'dismissible'        
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(saveEventAction);
	}
})