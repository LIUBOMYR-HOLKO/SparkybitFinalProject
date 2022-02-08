public with sharing class Constants {
    //PasswordHandler
    public static final Blob MY_KEY = Blob.valueOf('LIUBOMYR HOLKO');
    public static final String ALGORITHM_NAME = 'HMACSHA256';
    //LoginPageController
    public static final Integer EXPIRATION_COOKIE_TIME_ACCESS_TOKEN = 900;//15 minutes
    public static final Integer EXPIRATION_COOKIE_TIME_REFRESH_TOKEN = 604800;//7days
    //JWTHandler & AuthenticationHandler
    public static final Blob SECRET_KEY = blob.valueof('secret key value');
    //AuthenticationHandler
    public static final String CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
}