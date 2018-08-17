<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetTextValue</fullName>
        <description>Click Checkbox testing.</description>
        <field>TestText__c</field>
        <formula>&apos;Click Checkbox testing&apos;</formula>
        <name>SetTextValue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CheckboxImpactText</fullName>
        <actions>
            <name>SetTextValue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Test__c.TestCheckbox__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>change checkbox, to change text field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
