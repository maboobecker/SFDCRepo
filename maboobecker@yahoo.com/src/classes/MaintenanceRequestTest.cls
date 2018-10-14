@IsTest
public class MaintenanceRequestTest {

	@IsTest
	static void TestPositiveSingle() {
		//Test Repair maintance request
		testMaintenanceRequestAutomation('Repair', 1, 'Closed');
		
		//Test Routin Maintenance request
		testMaintenanceRequestAutomation('Routine Maintenance', 1, 'Closed');
	}

	@IsTest
	static void TestNegativeSingle() {

		//Test Other maintance request
		testMaintenanceRequestAutomation('Other', 1, 'Closed');
		
		//Test Repair maintance request
		testMaintenanceRequestAutomation('Repair', 1, 'Working');
				
		//Test Routin Maintenance request
		testMaintenanceRequestAutomation('Routine Maintenance', 1, 'Escalated');
	}

	@IsTest
	static void TestPositiveBulk() {
		//Test Repair maintance request
		testMaintenanceRequestAutomation('Routine Maintenance', 300, 'Closed');
	
		//Test Repair maintance request
		testMaintenanceRequestAutomation('Repair', 300, 'Closed');
	}

	@IsTest
	static void TestNegativeBulk() {

		//Test Other maintance request
		testMaintenanceRequestAutomation('Other', 300, 'Closed');
		
		//Test Repair maintance request
		testMaintenanceRequestAutomation('Repair', 300, 'Working');
				
		//Test Routin Maintenance request
		testMaintenanceRequestAutomation('Routine Maintenance', 300, 'Escalated');
	}

	private	static void testMaintenanceRequestAutomation(string requestType, integer totalCount, string newStatus) {
		//Test Repair maintance request
		List<Case> testRequests = TestDataFactory.createMaintenanceRequest(requestType, totalCount);
		for (Case tr: testRequests) {
			tr.Status = newStatus;
		}
		update testRequests;

		List<Case> newFollowupRequests = [SELECT id, Type, Status, Vehicle__c, Equipment__c, Subject, Origin, Date_Reported__c, Date_Due__c
										FROM Case WHERE ParentId IN: testRequests 
											AND Status = 'New'];

		integer expectedTotal = 0;
		if(newStatus == 'Closed' && (requestType =='Repair' || requestType == 'Routine Maintenance')) {
			expectedTotal = totalCount;
		}
		System.assertEquals(expectedTotal,newFollowupRequests.size());

		if (expectedTotal>0) {
			for (Case newFollowupRequest: newFollowupRequests) {
				System.assertEquals('Routine Maintenance', newFollowupRequest.Type);
				System.assertEquals('System Generated Routine Maintenance', newFollowupRequest.Subject);
				System.assertEquals('System', newFollowupRequest.Origin);
				System.assertEquals(Date.today(), newFollowupRequest.Date_Reported__c);
				System.assertEquals(Date.today().addDays(30), newFollowupRequest.Date_Due__c);
			}
		}
	}
}