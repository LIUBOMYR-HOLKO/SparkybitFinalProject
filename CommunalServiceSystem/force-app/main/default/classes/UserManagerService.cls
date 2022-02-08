public with sharing class UserManagerService {
    
    public Boolean checkPasswords(String passwordInDatabase, String inputtedPassword){
        Blob encryptedInputtedPassword = encrypt(inputtedPassword);
        return passwordInDatabase == EncodingUtil.convertToHex(encryptedInputtedPassword);
    }
    
    public User__c createUser(User__c user){                
        try{
            String encryptedPassword = EncodingUtil.convertToHex(encrypt(user.Password__c));
            User__c userInDB = new User__c(Email__c = user.Email__c, Password__c = encryptedPassword, 
                                           Name = user.Name, State__c = user.State__c);

            insert userInDB;
            System.debug('[UserManagerService.createUser] User successfully registered');
            return user;
        }
        catch(DmlException insertException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'A user with this email already exists'));
            System.debug('[UserManagerService.createUser] When you tried to create user you got exception: ' + insertException);
        }
        return null;
    }
    
    public Blob encrypt(String valueToEncrypt){
        Blob valueToEncryptInBlobFormat = Blob.valueOf(valueToEncrypt);
        Blob result = Crypto.generateMac(Constants.ALGORITHM_NAME, valueToEncryptInBlobFormat, Constants.MY_KEY);
        
        return result;
    }
    
    public User__c findUserByEmail(String email){
        try{
            User__c user = [SELECT Id, Email__c, Password__c FROM User__c WHERE Email__c = :email];
            System.debug('[UserManagerService.findUserByEmail] Found user '+user);
            return user;
        }
        catch(Exception e){
            System.debug('[UserManagerService.findUserByEmail] When you tried to find user by email you got exception: ' + e);
        }
        return null;
    }
    
    public Boolean isAuthenticated(){
        TokenManagerService tokenManager = new TokenManagerService();
        if(tokenManager.checkSignatures()){
            return true;
        }
        return false;
    }  
    
    public PageReference signIn(String email, String password){
        User__c user = findUserByEmail(email);
        if(user == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'First, you must register'));
        }
        else{
            Boolean isPasswordMatches = checkPasswords(user.Password__c, password);
            if(isPasswordMatches){
                TokenManagerService tokenManager = new TokenManagerService();
                String jwtToken = tokenManager.generateJWTToken(user.Id);
                String refreshToken = tokenManager.generateRefreshToken(user.Id);
                
                CookieManagerService cookieManager = new CookieManagerService();
                cookieManager.setAuthenticationCookie(jwtToken, refreshToken);
                System.debug('[UserManagerService.signIn] Cookies were setted');
                return new PageReference('/apex/HomePage');
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Password doesn\'t match'));
                System.debug('[UserManagerService.signIn] Password doesn\'t match');
            }
        }
        return null;
    }
    
    public PageReference signUp(User__c user){
        try{
            System.debug(user);
            User__c createdUser = createUser(user);
            System.debug(createdUser);
            EmailManagerService emailManager = new EmailManagerService();
            emailManager.sendEmail(new List<String>{user.Email__c}, 'You have successfully registered on the site', 'Welcome to the site');
            return signIn(createdUser.Email__c, user.Password__c);
        }
        catch(Exception e){
            System.debug('[UserManagerService.signUp] When you tried to sign up you got exception: '+e);
        }
        return null;
    }
}