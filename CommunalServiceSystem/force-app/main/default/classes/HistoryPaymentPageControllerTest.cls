@isTest
public class HistoryPaymentPageControllerTest {
    
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
        HistoryPaymentPageController historyPaymentPageController = new HistoryPaymentPageController();
        User__c user = [SELECT Id FROM User__c LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie(tokenManager.generateJWTToken(user.Id), tokenManager.generateRefreshToken(user.Id));
        
        Test.startTest();
        PageReference pageReference = historyPaymentPageController.authChecker();
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
        System.assert(historyPaymentPageController.manager);
    }
    
    @isTest
    public static void redirectToProfileInfoPagePositiveTest(){
        HistoryPaymentPageController historyPaymentPageController = new HistoryPaymentPageController();
        
        Test.startTest();
        PageReference pageReference = historyPaymentPageController.redirectToProfileInfoPage();
        Test.stopTest();
        
        System.assertEquals('/apex/ProfileInfoPage', pageReference.getUrl());
    }
}