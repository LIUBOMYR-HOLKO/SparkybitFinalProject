@isTest
public class CustomUserTriggerHandlerTest {
    
    @testSetup
    public static void dataSetup(){
        Region__c region = new Region__c(State__c = 'Kherson', Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5);
        insert region;
        
        User__c user = new User__c(Email__c = 'user@email.com', Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                                   Region__c = region.Id, Electricity_Meter_Readings__c = 10, Gas_Meter_Readings__c = 10, Water_Meter_Readings__c = 10);
        insert user;
    }
    
    @isTest
    public static void checkThatNewValueIsGreaterOrEqualThanPreviousNegativeTest(){
        User__c user = [SELECT Electricity_Meter_Readings__c, Gas_Meter_Readings__c, Water_Meter_Readings__c FROM User__c];
        user.Electricity_Meter_Readings__c = 1;
        user.Water_Meter_Readings__c = 1;
        user.Gas_Meter_Readings__c = 1;
        
        
        Test.startTest();
        Database.SaveResult resultOfUpdate = Database.update(user, false);
        Test.stopTest();
        
        System.assertEquals(false, resultOfUpdate.isSuccess());
        System.assertEquals(1, resultOfUpdate.getErrors().size());
    }
}