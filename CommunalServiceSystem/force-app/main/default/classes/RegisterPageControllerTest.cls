@isTest
public class RegisterPageControllerTest {
    @testSetup
    public static void dataSetup(){
        Region__c region = new Region__c(Name = 'Kherson', State__c = 'Kherson',  Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5);
        insert region;
    }
    
    @isTest
    public static void registerPositiveTest(){
        Region__c region = [SELECT Name FROM Region__c LIMIT 1];
        RegisterPageController registerPageController = new RegisterPageController();
        registerPageController.email = 'email@gmail.com';
        registerPageController.password = '123';
        registerPageController.name = 'username';
        registerPageController.regionName = region.Name;
        
        Test.startTest();
        PageReference pageReference = registerPageController.register();
        Test.stopTest();
        
        System.assertEquals('/apex/HomePage', pageReference.getUrl());
    }
    
    @isTest
    public static void regionsToSelectOptionListPositiveTest(){
        RegisterPageController registerPageController = new RegisterPageController();
        
        Test.startTest();
        List<SelectOption> regionsSelectOptionList = registerPageController.regionsToSelectOptionList();
        Test.stopTest();
        
        System.assertEquals(1, regionsSelectOptionList.size());
    }
    
    @isTest
    public static void redirectToLoginPagePositiveTest(){
        RegisterPageController registerPageController = new RegisterPageController();
        
        Test.startTest();
        PageReference pageReference = registerPageController.redirectToLoginPage();
        Test.stopTest();
        
        System.assertEquals('/apex/LoginPage', pageReference.getUrl());
    }
    
    @isTest
    public static void redirectToHomePagePositiveTest(){
        RegisterPageController registerPageController = new RegisterPageController();
        
        Test.startTest();
        PageReference pageReference = registerPageController.redirectToHomePage();
        Test.stopTest();
        
        System.assertEquals('/apex/HomePage', pageReference.getUrl());
    }
}