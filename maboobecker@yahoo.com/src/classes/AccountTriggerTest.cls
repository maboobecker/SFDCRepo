@isTest
private class AccountTriggerTest {
static testMethod void testUpdateShippingState() {
    //Arrange
    List<Account> newAccounts = new List<Account>();
    for(integer i = 0; i < 200; i++) {
        Account acct = new Account(Name='Test Account' + i, BillingState='CA');
        newAccounts.add(acct);
    }

    //Act
    Test.startTest();
    insert newAccounts;
    Test.stopTest();
    //Assert
    List<Account> updatedAccounts = [SELECT Name, BillingState, ShippingState FROM Account WHERE BillingState = 'CA'];
    for(Account acct : updatedAccounts) {
        System.assertEquals('CA', acct.ShippingState, 'Whoops! The states are not the same!');
    }
}
}