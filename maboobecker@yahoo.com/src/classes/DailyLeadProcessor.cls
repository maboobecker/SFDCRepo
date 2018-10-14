global class DailyLeadProcessor implements Schedulable{

    global void execute(SchedulableContext ctx){
        List<Lead> lList = [SELECT LeadSource FROM Lead WHERE LeadSource = null];
        if(!lList.isEmpty()){
            for(Lead l: lList){
                l.LeadSource = 'Dreamforce';
            }
            update lList;
        }
    }
}