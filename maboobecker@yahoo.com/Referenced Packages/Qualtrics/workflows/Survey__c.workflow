<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetSentDate</fullName>
        <field>Sent_Date__c</field>
        <formula>NOW()</formula>
        <name>SetSentDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>SetSentDate</fullName>
        <actions>
            <name>SetSentDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey__c.Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
