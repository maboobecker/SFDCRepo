public class RandomContactFactory {

    public Static List<Contact> generateRandomContacts(Integer NumberOfContact, String LnameOfContact){
        List<Contact> con=new List<Contact>();
        for(Integer i=0;i<NumberOfContact;i++){
            Contact c=new Contact(FirstName='Test '+i,LastName=LnameOfContact);
            con.add(c);
        }
        
        return con;
    }
}