@isTest
public class CreateAppointmentControllerTest {
    @testSetup static void methodName() {
    	Lead newLead = new Lead();
        newLead.FirstName = 'Test';
        newLead.LastName = 'LastName';
        newLead.Email = 'test@email.com';
        newLead.City = 'Pune';
        newLead.Company = 'My company'; 
        insert newLead;
        Event newEvent = new Event(WhoId = newLead.Id, Subject = 'Test Subject', StartDateTime = system.now(), EndDateTime = system.now().addMinutes(60), location = newLead.city);        
        insert newEvent;
    }
    public static testMethod void testGetCustomerDetails() {   
        Lead currentLead = [Select Id From Lead Limit 1];
        Test.startTest();
        	Lead lead = CreateAppointmentController.getCustomerInfo(currentLead.Id);
        	system.assertEquals(lead.FirstName, 'Test');
        Test.stopTest();
    }
    public static testMethod void testGetEvent() {   
        Lead currentLead = [Select Id From Lead Limit 1];
        Test.startTest();
        	CreateAppointmentController.getEvents(currentLead.Id);        	
        Test.stopTest();
    }
    public static testMethod void testCheckAvailability() {   
        Lead currentLead = [Select Id From Lead Limit 1];
        Event newEvt = new Event(WhoId = currentLead.Id);
        Test.startTest();
        	CreateAppointmentController.checkAvailablity(newEvt, '11:0', '12:0', string.valueOf(system.Now()));        	
        Test.stopTest();
    }
    public static testMethod void testsaveEvent() {   
        Lead currentLead = [Select Id From Lead Limit 1];
        Event newEvt = new Event(WhoId = currentLead.Id, subject = 'Appoinment1');
        Test.startTest();
        	CreateAppointmentController.saveEvent(newEvt, '11:0', '12:0', string.valueOf(system.Now()));        	
        Test.stopTest();
    }
    public static testMethod void testsaveEventNegative() {   
        Lead currentLead = [Select Id From Lead Limit 1];
        Event newEvt = new Event(WhoId = currentLead.Id, subject = 'Appoinment1');
        Test.startTest();
        	CreateAppointmentController.saveEvent(newEvt, '12:0', '11:0', string.valueOf(system.Now()));        	
        Test.stopTest();
    }
     public static testMethod void testsaveEventNegativeException() {   
        Lead currentLead = [Select Id From Lead Limit 1];
        Event newEvt = new Event(WhoId = currentLead.Id, subject = 'Appoinment1');
        Test.startTest();
        	CreateAppointmentController.saveEvent(newEvt, '12:0', '11:0', 'Test');        	
        Test.stopTest();
    }
}