global class LeadProcessor implements Database.Batchable<sObject>{
    //START METHOD
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }
    //EXECUTE METHOD
    global void execute (Database.BatchableContext bc, List<Lead> l_lst){
        List<lead> l_lst_new = new List<lead>();
        for(lead l: l_lst){
            l.leadsource ='Dreamforce';
        }
        update l_lst_new;
    }
    //FINISH METHOD
    global void finish(Database.BatchableContext bc){
        Id job = bc.getJobId();
        System.debug(job);
    }
}