trigger MaintenanceRequest on Case (after update) {
     
    //List<Case> casesToEvaluate = new List<Case>();
    Map<Id, Case> casesToEvaluate = new Map<Id, Case>();

    if(Trigger.isAfter && Trigger.isUpdate){
        for(Case maintenance:Trigger.new){
            if((maintenance.Type.contains('Repair') || maintenance.Type.contains('Routine Maintenance')) && maintenance.Status == 'Closed'){
                casesToEvaluate.put(maintenance.Id,maintenance);
            }
        }      
    }
    MaintenanceRequestHelper.updateWorkOrders(casesToEvaluate);
}