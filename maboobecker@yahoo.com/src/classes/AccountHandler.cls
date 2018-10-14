//The Apex class must be called 'AccountHandler' and be in the public scope.
public class AccountHandler {

    //Apex class must have a public static method called 'insertNewAccount'
    //The 'insertNewAccount' method must accept an incoming string as a parameter.
    //Name the account after the parameter, insert it into the system and then return the account record.
    //     
    //QUESTION: What's the different between the two lines below?
    //public static List<Account> insertNewAccount(String AccountName){
    //public static Account insertNewAccount(String AccountName){
    
    public static Account insertNewAccount(String AccountName){        
     
        try{
        //Insert the Account and include Country because of Validation Rule
        Account acct = new Account(Name = AccountName);
       // acct.BillingCountry = 'USA';
        insert acct;
        	return acct;
        }
                                        
        		//The 'insertNewAccount' method must also accept an empty string, catch the failed DML and return null.
        		//DML Statement Exception for errors, use Try...Catch blocks
       	
        catch (DmlException e){
        System.debug('A DML exception has ocurred: ' + e.getMessage());
            return (NULL);
        }        
    }
}