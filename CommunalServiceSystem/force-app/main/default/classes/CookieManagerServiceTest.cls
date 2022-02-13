@isTest
public class CookieManagerServiceTest {
    
    @isTest
    public static void setAuthenticationCookiePositiveTest(){
        CookieManagerService cookieManager = new CookieManagerService();
        String accessTokenValue = 'access token';
        String refreshTokenValue = 'resfresh token';
        
        Test.startTest();
        cookieManager.setAuthenticationCookie(accessTokenValue, refreshTokenValue);
        Test.stopTest();
        
        String accessTokenFromCookie = apexpages.currentPage().getCookies().get('ACCESS-TOKEN').getValue();
        String refreshTokenFromCookie = apexpages.currentPage().getCookies().get('REFRESH-TOKEN').getValue();
        System.assertEquals(accessTokenValue, accessTokenFromCookie);
        System.assertEquals(refreshTokenValue, refreshTokenFromCookie);
    }
    
    @isTest
    public static void getCookiePositiveTest(){
        CookieManagerService cookieManager = new CookieManagerService();
        Cookie cookie = new Cookie('key', 'value', null, 100, true);
        ApexPages.currentPage().setCookies(new Cookie[] {cookie});
        
        Test.startTest();
        String actualCookie = cookieManager.getCookie('key');
        Test.stopTest();
        
        System.assertEquals('value', actualCookie);
    }
    
    @isTest
    public static void getCookieNegativeTest(){
        CookieManagerService cookieManager = new CookieManagerService();
        Cookie cookie = new Cookie('key', 'value', null, 100, true);
        ApexPages.currentPage().setCookies(new Cookie[] {cookie});
        
        Test.startTest();
        String actualCookie  = cookieManager.getCookie('no_key');
        Test.stopTest();
        
        System.assertEquals(null, actualCookie);
    }
}