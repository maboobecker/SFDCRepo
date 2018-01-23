@istest
private class RestrictContactByName {
    @isTest Static void TestRestictedname(){
        List<contact> testcontacts = New List<contact>();
        contact c0 = new contact(LastName = 'Testcontact');
        testcontacts.add(c0);
        Contact c1 = new contact(LastName = 'INVALIDNAME');
        testcontacts.add(c1);
        Test.startTest(); 
        Database.SaveResult[] srList = Database.insert(testcontacts, false); 
        Test.stopTest();
        Database.SaveResult R0 = srlist[0];
        Database.SaveResult R1 = srlist[1];
        System.assertequals(r1.getErrors()[0].getmessage(),'The Last Name "INVALIDNAME" is not allowed for DML');
        System.assert(r0.isSuccess());
        System.assert(!r1.isSuccess());
                      
                      }
                      }