public with sharing class UserTriggerHandler {
    public static void updateAllReadings(List<User__c> newUsersData, Map<Id,User__c> oldUsersData){
        // Map<Id,Region__c> regionsMap = new Map<Id,Region__c>([SELECT Id,State__c, Gas_Rate__c, Water_Rate__c, Electricity_Rate__c FROM Region__c]);//regionsMap.get(newUser.State__c).Electricity_Rate__c;
        List<Region__c> regions = [SELECT Id,State__c, Gas_Rate__c, Water_Rate__c, Electricity_Rate__c FROM Region__c];
        for(User__c newUser: newUsersData){
            User__c oldUser = oldUsersData.get(newUser.Id);
            if(newUser.Water_Meter_Readings__c == oldUser.Water_Meter_Readings__c && 
                    newUser.Gas_Meter_Readings__c == oldUser.Gas_Meter_Readings__c && 
                    newUser.Electricity_Meter_Readings__c == oldUser.Electricity_Meter_Readings__c)
            {
            }
            else{
                if(newUser.Water_Meter_Readings__c != oldUser.Water_Meter_Readings__c && 
                newUser.Gas_Meter_Readings__c != oldUser.Gas_Meter_Readings__c && 
                newUser.Electricity_Meter_Readings__c != oldUser.Electricity_Meter_Readings__c)
                {
                    for(Region__c region : regions){
                        if(region.State__c == newUser.State__c){
                            newUser.Amount_For_Electricity__c += (newUser.Electricity_Meter_Readings__c - oldUser.Electricity_Meter_Readings__c) * region.Electricity_Rate__c;
                            newUser.Amount_For_Gas__c += (newUser.Amount_For_Gas__c - oldUser.Amount_For_Gas__c) * region.Gas_Rate__c;
                            newUser.Amount_For_Water__c += (newUser.Amount_For_Water__c - oldUser.Amount_For_Water__c) * region.Water_Rate__c;
                            newUser.Submitted_New_Readings__c = true;
                        }
                    }
                    
                }else{
                    newUser.addError('You should update all readings');
                }
            }
        }
    }
}
