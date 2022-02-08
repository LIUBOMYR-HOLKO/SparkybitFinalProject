public with sharing class CookieManagerService {
    public void setAuthenticationCookie(String accessToken, String refreshToken){
        Cookie accessCookie = new Cookie('ACCESS-TOKEN', accessToken, null, Constants.EXPIRATION_COOKIE_TIME_ACCESS_TOKEN, true);
        Cookie refreshCookie = new Cookie('REFRESH-TOKEN', refreshToken, null, Constants.EXPIRATION_COOKIE_TIME_REFRESH_TOKEN, true);
        ApexPages.currentPage().setCookies(new Cookie[] {accessCookie,refreshCookie});
    }
    
    public String getCookie(String cookieKey){
        try{
            return apexpages.currentPage().getCookies().get(cookieKey).getValue();
        }
        catch(Exception e){
            System.debug('[CookieManagerService.getCookie] When you tried to get cookie you got exception');
        }
        return null;
    }
    
}