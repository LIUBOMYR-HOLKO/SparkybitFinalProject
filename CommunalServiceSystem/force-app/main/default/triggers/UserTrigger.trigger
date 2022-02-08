trigger UserTrigger on User__c (before update, after update) {
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            UserTriggerHandler.updateAllReadings(Trigger.New, Trigger.oldMap);
        }
    }

}