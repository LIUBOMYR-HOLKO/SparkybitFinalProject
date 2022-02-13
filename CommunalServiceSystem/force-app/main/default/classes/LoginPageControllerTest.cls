@isTest
public class LoginPageControllerTest {
    @testSetup
    public static void dataSetup(){
        Region__c region = new Region__c(State__c = 'Kherson', Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5);
        insert region;
        
        User__c user = new User__c(Email__c = 'email@email.com', Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                                   Region__c = region.Id);
        insert user;
    }
    
    @isTest
    public static void loginPositiveTest(){
        LoginPageController loginPageController = new LoginPageController();
        loginPageController.email = 'email@email.com';
        loginPageController.password = '123';
        
        Test.startTest();
        PageReference pageReference = loginPageController.login();
        Test.stopTest();
        
        System.assertEquals('/apex/HomePage', pageReference.getUrl());
    }
    
    @isTest
    public static void redirectToRegisterPagePositiveTest(){
        LoginPageController loginPageController = new LoginPageController();
        
        Test.startTest();
        PageReference pageReference = loginPageController.redirectToRegisterPage();
        Test.stopTest();
        
        System.assertEquals('/apex/RegisterPage', pageReference.getUrl());
    }
    
    @isTest
    public static void redirectToHomePagePositiveTest(){
        LoginPageController loginPageController = new LoginPageController();
        
        Test.startTest();
        PageReference pageReference = loginPageController.redirectToHomePage();
        Test.stopTest();
        
        System.assertEquals('/apex/HomePage', pageReference.getUrl());
    }
}