@isTest
public class ProfileInfoPageControllerTest {
    @testSetup
    public static void dataSetup(){
        List<Region__c> regions = new List<Region__c>();
        regions.add(new Region__c(State__c = 'Kherson', Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5));
        regions.add(new Region__c(State__c = 'Lviv', Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5));
        
        insert regions;
        
        User__c user = new User__c(Email__c = 'email@email.com', Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                                   Region__c = regions[0].Id, Manager__c = true, Electricity_Meter_Readings__c = 10);
        insert user;
    }
    
    @isTest
    public static void regionsToSelectOptionListPositiveTest()
    {
        ProfileInfoPageController profileInfoPageController = new ProfileInfoPageController();
        
        Test.startTest();
        List<SelectOption> regionsSelectOptionList = profileInfoPageController.regionsToSelectOptionList();
        Test.stopTest();
        
        System.assertEquals(2, regionsSelectOptionList.size());
    }
    
    @isTest
    public static void authCheckerPositiveTest(){
        ProfileInfoPageController profileInfoPageController = new ProfileInfoPageController();
        
        Test.startTest();
        PageReference pageReference = profileInfoPageController.authChecker();
        Test.stopTest();
        
        System.assertEquals('/apex/LoginPage', pageReference.getUrl());
    }
    
    @isTest
    public static void payPositiveTest(){
        ProfileInfoPageController profileInfoPageController = new ProfileInfoPageController();
        
        Test.startTest();
        PageReference pageReference = profileInfoPageController.pay();
        Test.stopTest();
        
        System.assertEquals('/apex/PaymentPage', pageReference.getUrl());
    }
    
    @isTest
    public static void showHistoryPositiveTest(){
        User__c user = [SELECT Id FROM User__c LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie(tokenManager.generateJWTToken(user.Id), tokenManager.generateRefreshToken(user.Id));
        ProfileInfoPageController profileInfoPageController = new ProfileInfoPageController();
        
        Test.startTest();
        PageReference pageReference = profileInfoPageController.showHistory();
        Test.stopTest();
        
        System.assertEquals('/apex/HistoryPaymentPage?id='+user.Id, pageReference.getUrl());
    }
    
    @isTest
    public static void quicksavePositiveTest(){
        User__c user = [SELECT Id, Electricity_Meter_Readings__c, Region__c FROM User__c LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie(tokenManager.generateJWTToken(user.Id), tokenManager.generateRefreshToken(user.Id));
        ProfileInfoPageController profileInfoPageController = new ProfileInfoPageController();
        profileInfoPageController.electricityMeterReadings = 25;
        
        Test.startTest();        
        profileInfoPageController.quicksave();
        Test.stopTest();
        
        User__c updatedUser = [SELECT Id, Electricity_Meter_Readings__c, Region__c FROM User__c LIMIT 1];
        System.assertEquals(25, updatedUser.Electricity_Meter_Readings__c);
    }
}