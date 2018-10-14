public class NewCaseListController {

    public  List<Case> getNewCases()
    {
        List<Case> caseList = new List<Case>();
        for(Case ct: [Select Id, CaseNumber FROM Case WHERE Status = 'New'])
            caseList.add(ct);

        return caseList;
    }
}