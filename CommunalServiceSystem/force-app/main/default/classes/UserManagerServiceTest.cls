@isTest
public class UserManagerServiceTest {
    
    @testSetup
    public static void usersSetup(){
        Region__c region = new Region__c(State__c = 'Kherson', Electricity_Rate__c = 1.00, Gas_Rate__c = 0.85, Water_Rate__c = 2.5);
        insert region;
        List<User__c> users = new List<User__c>();
        
        for(Integer i = 0; i<9; i++){
            users.add(new User__c(Email__c = 'email@gmail.com'+i, Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                                  Region__c = region.Id));
        }
        
        users.add(new User__c(Email__c = 'manager@gmail.com', Password__c = 'e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6',
                              Region__c = region.Id, Manager__c = true));
        
        insert users;
    }
    
    @isTest
    public static void checkPasswordsPositiveTest(){
        User__c user = [SELECT Password__c FROM User__c LIMIT 1];
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        Boolean isPasswordsMatch = userManager.checkPasswords('e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6', '123');
        Test.stopTest();
        
        System.assert(isPasswordsMatch);
    }
    
    @isTest
    public static void checkPasswordsNegativeTest(){
        User__c user = [SELECT Password__c FROM User__c LIMIT 1];
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        Boolean isPasswordsMatch = userManager.checkPasswords('e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6', 'qwerty');
        Test.stopTest();
        
        System.assert(!isPasswordsMatch);
    }
    
    @isTest
    public static void createUserPositiveTest(){
        UserManagerService userManager = new UserManagerService();
        Region__c region = [SELECT Id FROM Region__c LIMIT 1];
        
        Test.startTest();
        User__c user = userManager.createUser(new User__c(Email__c = 'golko04102001@gmail.com', Password__c = '123', Region__c = region.Id));
        Test.stopTest();
        
        System.assertEquals(11,[SELECT count() FROM User__c]);
    }
    
    @isTest
    public static void createUserNegativeTest(){
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        User__c user = userManager.createUser(new User__c(Email__c = 'email@gmail.com0', Password__c = '123'));
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.severity.ERROR));
        System.assertEquals(10,[SELECT count() FROM User__c]);
        System.assertEquals(null, user);
    }  
    
    @isTest
    public static void encryptPositiveTest(){
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        Blob encryptedData = userManager.encrypt('123');
        Test.stopTest();
        
        System.assertEquals('e47e0a6874b69cb17f80f3de47d1706f617d21cbe8b9391cfa7b34f48414bef6', EncodingUtil.convertToHex(encryptedData));
    }  
    
    @isTest
    public static void findUserByEmailPositiveTest(){
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        User__c user = userManager.findUserByEmail('email@gmail.com0');
        Test.stopTest();
        
        System.assertNotEquals(null, user);
    }  
    
    @isTest
    public static void findUserByEmailNegativeTest(){
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        User__c user = userManager.findUserByEmail('non-existed-email@gmail.com');
        Test.stopTest();
        
        System.assertEquals(null, user);
    }  
    
    
    @isTest
    public static void isAuthenticatedPositiveTest(){
        UserManagerService userManager = new UserManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie('eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiJqd3QifQ.eyJzdWIiOiJhMDA3UjAwMDAwejlCdWFRQUUiLCAiaWF0IjogIjIwMjItMDItMTAgMTU6MDM6NDcifQ.LBLckSvywz-IbLEf29EcUNLwZQenKT-TMm46juuijPI', null);
        
        Test.startTest();
        Boolean isAuthenticated = userManager.isAuthenticated();
        Test.stopTest();
        
        System.assertEquals(true, isAuthenticated);
    }  
    
    @isTest
    public static void isAuthenticatedNegativeTest(){
        UserManagerService userManager = new UserManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie('eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiJqd3QifQ.eyJzdWIiOiJhMDA3UjAwMDAwejlCdWFRQUUiLCAiaWF0IjogIjIwMjItMDItMTAgMTU6MDM6NDcifQ.Fake-Signature', null);
        
        Test.startTest();
        Boolean isAuthenticated = userManager.isAuthenticated();
        Test.stopTest();
        
        System.assertEquals(false, isAuthenticated);
    } 
    
    @isTest
    public static void isAuthorizedPositiveTest(){
        UserManagerService userManager = new UserManagerService();
        User__c manager = [SELECT Id, Manager__c FROM User__c WHERE Manager__c = true LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie(tokenManager.generateJWTToken(manager.Id), null);
        
        Test.startTest();
        Boolean isAuthorized = userManager.isAuthorized();
        Test.stopTest();
        
        System.assertEquals(true, isAuthorized);
    }
    
    @isTest
    public static void isAuthorizedNegativeTest(){
        UserManagerService userManager = new UserManagerService();
        User__c notManager = [SELECT Id, Manager__c FROM User__c WHERE Manager__c = false LIMIT 1];
        TokenManagerService tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie(tokenManager.generateJWTToken(notManager.Id), null);
        
        Test.startTest();
        Boolean isAuthorized = userManager.isAuthorized();
        Test.stopTest();
        
        System.assertEquals(false, isAuthorized);
    }
    
    @isTest
    public static void signInPositiveTest(){
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        PageReference pageReference = userManager.signIn('email@gmail.com0','123');
        Test.stopTest();
        
        System.assertEquals('/apex/HomePage', pageReference.getUrl());
    } 
    
    @isTest
    public static void signInWithoutAccountNegativeTest(){
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        PageReference pageReference = userManager.signIn('non-existed-email@gmail.com','123');
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
    } 
    
    @isTest
    public static void signInWithIncorrectPasswordNegativeTest(){
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        PageReference pageReference = userManager.signIn('email@gmail.com0','incorrect_password');
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
    } 
    
    @isTest
    public static void signUpPositiveTest(){
        UserManagerService userManager = new UserManagerService();
        Region__c region = [SELECT Id FROM Region__c LIMIT 1];
        User__c user = new User__c(Email__c = 'unique@email.com', Password__c = '123', Region__c = region.Id);
        
        Test.startTest();
        PageReference pageReference = userManager.signUp(user);
        Test.stopTest();
        
        System.assertEquals('/apex/HomePage', pageReference.getUrl());
    } 
    
    @isTest
    public static void signUpNegativeTest(){
        UserManagerService userManager = new UserManagerService();
        Region__c region = [SELECT Id FROM Region__c LIMIT 1];
        User__c user = new User__c(Email__c = 'email@gmail.com0', Password__c = '123', Region__c = region.Id);
        
        Test.startTest();
        PageReference pageReference = userManager.signUp(user);
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
    } 
    
    @isTest
    public static void updateTokenIfNecessaryWhenUserIsAuthenticatedPositiveTest(){
        UserManagerService userManager = new UserManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        cookieManager.setAuthenticationCookie('eyJhbGciOiAiSFMyNTYiLCJ0eXAiOiJqd3QifQ.eyJzdWIiOiJhMDA3UjAwMDAwejlCdWFRQUUiLCAiaWF0IjogIjIwMjItMDItMTAgMTU6MDM6NDcifQ.LBLckSvywz-IbLEf29EcUNLwZQenKT-TMm46juuijPI', null);
        
        Test.startTest();
        PageReference pageReference = userManager.updateTokenIfNecessary();
        Test.stopTest();
        
        System.assertEquals(null, pageReference);
    }
    
    @isTest
    public static void updateTokenIfNecessaryNegativeTest(){
        UserManagerService userManager = new UserManagerService();
        
        Test.startTest();
        PageReference pageReference = userManager.updateTokenIfNecessary();
        Test.stopTest();
        
        System.assertEquals('/apex/LoginPage', pageReference.getUrl());
    }
}