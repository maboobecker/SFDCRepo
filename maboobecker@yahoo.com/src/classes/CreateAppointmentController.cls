public class CreateAppointmentController {
    @AuraEnabled
    public static string getEvents(String leadId){
        system.debug('leadId'+leadId);
        TimeZone tzone = UserInfo.getTimeZone();
        decimal off = tzone.getOffset(system.now()) / (1000 * 3600 * 24.0);
        system.debug('offset==>'+off);
        Lead currentLead = [Select ownerId from Lead Where Id =: leadId];
        List<Event> appoinments = [SELECT AccountId,EndDateTime,Id,StartDateTime,Subject FROM Event WHERE OwnerId =: currentLead.ownerId];
        List<EventWrapper> EventWrapperList = new List<EventWrapper>();
        for(Event evt : appoinments) {
            //system.debug('Evt==>'+evt.Subject+'  '+tzone.getOffset(evt.EndDateTime) / (1000 * 3600 * 24.0));
            EventWrapper wrapper = new EventWrapper();
            wrapper.eventId = evt.Id;
        	wrapper.EndDateTime = evt.EndDateTime+(off);
        	wrapper.StartDateTime = evt.StartDateTime+(off);
        	wrapper.Subject = evt.Subject;
            EventWrapperList.add(wrapper);
        }
        return JSON.serialize(EventWrapperList);
    }
    @auraEnabled
    public static Lead getCustomerInfo(String leadId) {
        return [select Id, FirstName, LastName, Address, Street, City, State, PostalCode, Phone, Owner.FirstName, Owner.LastName, Owner.Email FROM Lead WHERE Id =: leadId];
    }
    @auraEnabled
    public static boolean checkAvailablity(Event newEvt, String startTime, string endTime, string eventDate) {
        Date appDate = date.valueOf(eventDate);
        List<string> startList = startTime.split(':');
        List<string> endList = endTime.split(':');
        system.debug('startList==>'+startList);
        Datetime start = Datetime.newInstance(appDate.year(), appDate.month(), appDate.day(), Integer.valueOf(startList[0]), Integer.valueOf(startList[1]), 0);
        Datetime endT = Datetime.newInstance(appDate.year(), appDate.month(), appDate.day(), Integer.valueOf(endList[0]), Integer.valueOf(endList[1]), 0);
        Lead currentLead = [Select Id, ownerId, isConverted From Lead Where Id =: newEvt.WhoId];
        List<Event> existingApp = [Select Id From Event Where StartDateTime <=: start AND EndDateTime >=: endT AND OwnerId =: currentLead.OwnerId];
        if(existingApp.size() > 0) {
            return false;
        }
        else
            return true;
    }
    @auraEnabled
    public static string saveEvent(Event newEvt, String startTime, string endTime, string eventDate) {
        MessaageWrapper wrapper = new MessaageWrapper();
        wrapper.hasErrors = false;
        wrapper.messages = new List<string>();
        try {    	
            Date appDate = date.valueOf(eventDate);
            List<string> startList = startTime.split(':');
        	List<string> endList = endTime.split(':');
        	system.debug('startList==>'+startList);
        	Datetime start = Datetime.newInstance(appDate.year(), appDate.month(), appDate.day(), Integer.valueOf(startList[0]), Integer.valueOf(startList[1]), 0);
        	Datetime endT = Datetime.newInstance(appDate.year(), appDate.month(), appDate.day(), Integer.valueOf(endList[0]), Integer.valueOf(endList[1]), 0);
        	Lead currentLead = [Select Id, ownerId, city, isConverted from Lead Where Id =: newEvt.WhoId];
            Event newEvent = new Event(WhoId = newEvt.WhoId, Subject = newEvt.Subject, StartDateTime = start, EndDateTime = endT, OwnerId = currentLead.ownerId, location = currentLead.city);        
            insert newEvent;        	 
            
            If(!currentLead.isConverted) {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(currentLead.id);
                
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                lc.setConvertedStatus(convertStatus.MasterLabel);
                
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                wrapper.oppId = lcr.getOpportunityId();
            }
            return JSON.serialize(wrapper); 
        }
        catch (System.DmlException e) {
        	system.debug('Exception Occured==>'+e.getMessage()+' :: '+e.getStackTraceString());
        	wrapper.hasErrors = true;  
        	for (Integer i = 0; i < e.getNumDml(); i++) {
        		if(e.getDmlType(0) == StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION || e.getDmlType(0) == StatusCode.REQUIRED_FIELD_MISSING || e.getDmlType(0) == StatusCode.FIELD_INTEGRITY_EXCEPTION)
        			wrapper.messages.add(e.getDmlMessage(i));
        		else
        			wrapper.messages.add('Problem while processing your request.Please try after some time');
        	}      
        	return JSON.serialize(wrapper);  	
        }        
        catch(Exception e) {
        	system.debug('Exception Occured==>'+e.getMessage()+' :: '+e.getStackTraceString());
        	wrapper.hasErrors = true;  
        	wrapper.messages.add('Problem while processing your request.Please try after some time');
        	return JSON.serialize(wrapper);
        }
	}     
    public class MessaageWrapper {
        public boolean hasErrors;
        public List<string> messages;
        public string oppId;
    }
    public class EventWrapper {
        Public String eventId;
        public Datetime EndDateTime;
        public DateTime StartDateTime;
        Public string Subject;
    }
}