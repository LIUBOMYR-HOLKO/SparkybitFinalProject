@isTest
public class EditMonthlyPaymentPageControllerTest {
    
    @testSetup
    public static void dataSetup(){
        Region__c region = new Region__c(State__c = 'Kherson', Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5);
        insert region;
        
        User__c user = new User__c(Email__c = 'email@email.com', Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                                   Region__c = region.Id, Manager__c = true);
        insert user;
    }
    
    @isTest
    public static void authCheckerPositiveTest(){
        User__c user = [SELECT Id FROM User__c LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie(tokenManager.generateJWTToken(user.Id), tokenManager.generateRefreshToken(user.Id));
        ApexPages.currentPage().getParameters().put('id', user.Id);
        EditMonthlyPaymentPageController editMonthlyPaymentPageController = new EditMonthlyPaymentPageController();
        
        Test.startTest();
        PageReference pageReference = editMonthlyPaymentPageController.authChecker();
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
    }
    
    @isTest
    public static void authCheckerNegativeTest(){
        EditMonthlyPaymentPageController editMonthlyPaymentPageController = new EditMonthlyPaymentPageController();
        
        Test.startTest();
        PageReference pageReference = editMonthlyPaymentPageController.authChecker();
        Test.stopTest();
        
        System.assertEquals('/apex/HomePage', pageReference.getUrl());
    }
    
    
    @isTest
    public static void quicksavePositiveTest(){
        User__c user = [SELECT Id,Amount_For_Electricity__c FROM User__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', user.Id);
        EditMonthlyPaymentPageController editMonthlyPaymentPageController = new EditMonthlyPaymentPageController();
        editMonthlyPaymentPageController.amountForElectricity = 999;
        
        Test.startTest();
        PageReference pageReference = editMonthlyPaymentPageController.quicksave();
        Test.stopTest();
        
        User__c userAfterUpdate = [SELECT Id,Amount_For_Electricity__c FROM User__c WHERE Id = :user.Id];
        System.assertNotEquals(user.Amount_For_Electricity__c, userAfterUpdate.Amount_For_Electricity__c);
    }
}