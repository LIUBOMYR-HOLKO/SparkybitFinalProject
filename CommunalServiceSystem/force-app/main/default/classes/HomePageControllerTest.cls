@isTest
public class HomePageControllerTest {
    @testSetup
    public static void dataSetup(){
        Region__c region = new Region__c(State__c = 'Kherson', Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5);
        insert region;
        
        List<User__c> users = new List<User__c>();
        users.add(new User__c(Email__c = 'manager@email.com', Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                              Region__c = region.Id, Manager__c = true));
        users.add(new User__c(Email__c = 'user@email.com', Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                              Region__c = region.Id, Manager__c = false));
        insert users;
    }
    
    @isTest
    public static void authCheckerIfManagerPositiveTest(){
        HomePageController homePageController = new HomePageController();
        User__c user = [SELECT Id FROM User__c WHERE Manager__c = true LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie(tokenManager.generateJWTToken(user.Id), tokenManager.generateRefreshToken(user.Id));
        
        Test.startTest();
        PageReference pageReference = homePageController.authChecker();
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
        System.assertEquals(true, homePageController.manager);
    }
    
    @isTest
    public static void authCheckerIfUserPositiveTest(){
        HomePageController homePageController = new HomePageController();
        User__c user = [SELECT Id FROM User__c WHERE Manager__c = false LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie(tokenManager.generateJWTToken(user.Id), tokenManager.generateRefreshToken(user.Id));
        
        Test.startTest();
        PageReference pageReference = homePageController.authChecker();
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
        System.assertEquals(true, homePageController.user);
    }
    
    @isTest
    public static void authCheckerIfGuestPositiveTest(){
        HomePageController homePageController = new HomePageController();
        
        Test.startTest();
        PageReference pageReference = homePageController.authChecker();
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
        System.assertEquals(true, homePageController.guest);
    }
    
    
    @isTest
    public static void redirectToLoginPagePositiveTest(){
        HomePageController homePageController = new HomePageController();
        
        Test.startTest();
        PageReference pageReference = homePageController.redirectToLoginPage();
        Test.stopTest();
        
        System.assertEquals('/apex/LoginPage', pageReference.getUrl());
    }
    
    @isTest
    public static void redirectToProfileInfoPagePositiveTest(){
        HomePageController homePageController = new HomePageController();
        
        Test.startTest();
        PageReference pageReference = homePageController.redirectToProfileInfoPage();
        Test.stopTest();
        
        System.assertEquals('/apex/ProfileInfoPage', pageReference.getUrl());
    }
    
    @isTest
    public static void redirectToRegisterPagePositiveTest(){
        HomePageController homePageController = new HomePageController();
        
        Test.startTest();
        PageReference pageReference = homePageController.redirectToRegisterPage();
        Test.stopTest();
        
        System.assertEquals('/apex/RegisterPage', pageReference.getUrl());
    }
    
    @isTest
    public static void redirectToShowUsersPagePositiveTest(){
        HomePageController homePageController = new HomePageController();
        
        Test.startTest();
        PageReference pageReference = homePageController.redirectToShowUsersPage();
        Test.stopTest();
        
        System.assertEquals('/apex/ShowUsersPage', pageReference.getUrl());
    }
    
    @isTest
    public static void redirectToHomePagePositiveTest(){
        HomePageController homePageController = new HomePageController();
        
        Test.startTest();
        PageReference pageReference = homePageController.redirectToHomePage();
        Test.stopTest();
        
        System.assertEquals('/apex/HomePage', pageReference.getUrl());
        System.assertEquals(true, pageReference.getRedirect());
    }
    
     @isTest
    public static void redirectToRegionRatesPagePositiveTest(){
        HomePageController homePageController = new HomePageController();
        
        Test.startTest();
        PageReference pageReference = homePageController.redirectToRegionRatesPage();
        Test.stopTest();
        
        System.assertEquals('/apex/RegionRatesPage', pageReference.getUrl());
    }
}