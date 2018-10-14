public class MaintenanceRequestHelper {

    public static void updateWorkOrders(Map<Id, Case>  cases){
        List<Case> maintenance_routineList = new List<Case>();
 
        List<Product2> listProduct = [select Id, Maintenance_Cycle__c from Product2]; 
        Map<Id,decimal> mapProduct = new Map<Id, decimal>();
         
        for (Product2 p : listProduct) {
            if (p != null) {
                if(p.Maintenance_Cycle__c != null){
                    mapProduct.put(p.Id, p.Maintenance_Cycle__c);
                }              
            }
        }

        System.debug('### product: '+mapProduct);
 
        for(Case maintenance:cases.values()){
            Case maintenanceNew = new Case();
            maintenanceNew.Subject = 'Routine Maintenance';
            System.debug('### Second: '+mapProduct.get(maintenance.Equipment__c));
            if (mapProduct.get(maintenance.Equipment__c) != null) {
                 maintenanceNew.Date_Due__c = Date.today().addDays(Integer.valueOf(mapProduct.get(maintenance.Equipment__c)));
            }
            
            maintenanceNew.Vehicle__c = maintenance.Vehicle__c;
            maintenanceNew.Product__c = maintenance.Product__c;
            maintenanceNew.ContactId = maintenance.ContactId;
            maintenanceNew.AccountId = maintenance.AccountId;
            maintenanceNew.AssetId   = maintenance.AssetId;
            maintenanceNew.Type      = 'Routine Maintenance';
            maintenanceNew.Status    = 'New';
            maintenanceNew.Equipment__c = maintenance.Equipment__c;
            maintenanceNew.Date_Reported__c = Date.today();
            maintenance_routineList.add(maintenanceNew);
        }
 
        insert maintenance_routineList;
    }
}