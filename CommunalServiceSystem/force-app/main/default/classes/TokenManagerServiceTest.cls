@isTest
public class TokenManagerServiceTest {
    @testSetup
    public static void dataSetup(){
        Region__c region = new Region__c(State__c = 'Kherson', Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5);
        insert region;
        
        User__c user = new User__c(Email__c = 'email@email.com', Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                                   Region__c = region.Id, Manager__c = true);
        insert user;
    }
    
    @isTest
    public static void getUserIdByRefreshTokenPositiveTest(){
        User__c user = [SELECT Id FROM User__c LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        String refreshToken = tokenManager.generateRefreshToken(user.Id);
        
        Test.startTest();
        String userId = tokenManager.getUserIdByRefreshToken(refreshToken);
        Test.stopTest();
        
        System.assertEquals(userId, user.Id);
    }
    
    @isTest
    public static void getUserIdByRefreshTokenNegativeTest(){
        User__c user = [SELECT Id FROM User__c LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        String refreshToken = tokenManager.generateRefreshToken(user.Id);
        
        Test.startTest();
        String userId = tokenManager.getUserIdByRefreshToken('not previous refresh token');
        Test.stopTest();
        
        System.assertEquals(null, userId);
    }
}