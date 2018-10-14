/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SendSurveyBatch implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global Boolean contactOptOutAccessible;
    global Map<String,Boolean> contactOptOutsAccessible;
    global Boolean leadOptOutAccessible;
    global Map<String,Boolean> leadOptOutsAccessible;
    global String panelId;
    global Integer recordsNullEmail {
        get;
        set;
    }
    global Integer recordsOptOut {
        get;
        set;
    }
    global Integer recordsTotal {
        get;
        set;
    }
    global Id surveyId;
    global Integer validMemberCount;
    global SendSurveyBatch() {

    }
    global void execute(Database.BatchableContext BC, List<CampaignMember> cms) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}
