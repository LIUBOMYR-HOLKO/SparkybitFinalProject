public class TokenManagerService {
    public String generateJWTToken(Id userId){
        String header = '{"alg": "HS256","typ":"jwt"}';
        String payload = '{"sub":"'+userId+'", "iat": "'+Datetime.now()+'"}';
        string jwt =base64URLencode(blob.valueof(header)) + '.' +base64URLencode(blob.valueof(payload));
        
        blob signature = Crypto.generateMac(Constants.ALGORITHM_NAME,Blob.valueof(jwt),Constants.SECRET_KEY);
        
        return jwt+'.'+base64URLencode(signature);
    }
    
    private String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        
        return output;
    }
    
    public String getUserIdByRefreshToken(String prevToken){
        try{
            Refresh_Token__c rt = [SELECT User__c, Token__c FROM Refresh_Token__c WHERE Token__c = :prevToken];
            String userId = rt.User__c;
            return userId;
        }
        catch(Exception e){
            System.debug('[TokenManagerService.getUserIdByRefreshToken] When you tried to find user ID by regresh token you got exception: ' + e);
            return null;
        }
    }
    
    public String getUserIdByAccessToken(String accessToken){
        try{
            if(checkSignatures()){
                String [] separatedJWT = accessToken.split('\\.');
                String payload = EncodingUtil.base64Decode(separatedJWT[1]).toString();
                String userId = payload.substringBetween('sub":"', '"');
				return userId;
            }
            return null;
        }
        catch(Exception e){
            System.debug('[TokenManagerService.getUserIdByAccessToken] When you tried to find user ID by access token you got exception: ' + e);
            return null;
        }
    }
    
    public String generateRefreshToken(String userId){
        String token='';
        for(Integer i = 0; i<40;i++){
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), Constants.CHARS.length());
            token+= Constants.CHARS.substring(idx, idx+1);
        }
        List<Refresh_Token__c> tokens = [SELECT Token__c, User__c FROM Refresh_Token__c WHERE User__c = :userId LIMIT 1];
        
        if(tokens.size() == 1){
            tokens[0].Token__c = token;
            update tokens;
        }
        else{
            tokens.add(new Refresh_Token__c(Token__c = token, User__c = userId));
            insert tokens;
        }
        
        return token;
    }
    
    public Boolean checkSignatures(){
        try{
            String data = apexpages.currentPage().getCookies().get('ACCESS-TOKEN').getValue();
            
            String [] separatedJWT = data.split('\\.');
            String headerAndPayload = separatedJWT[0]+'.'+separatedJWT[1];
            String signatureFromCookie = separatedJWT[2];
            
            blob signatureGenerated = Crypto.generateMac(Constants.ALGORITHM_NAME,Blob.valueof(headerAndPayload),Constants.SECRET_KEY);
            String signature = base64URLencode(signatureGenerated);     
            
            return signature == signatureFromCookie;
        }
        catch(Exception e){
            // likely if client has fake access token OR access token was expired
            System.debug('[TokenManagerService.checkSignatures] When you tried to get ACCESS-TOKEN you got exception: '+ e);
        }
        
        return false;
    }
    
    public PageReference updateTokens(){
        PageReference pageReference = new PageReference('/apex/LoginPage');
        try{
            String prevRefreshToken = apexpages.currentPage().getCookies().get('REFRESH-TOKEN').getValue();
            String userId = getUserIdByRefreshToken(prevRefreshToken);
            if(userId == null){
                // likely if client has fake refresh token
                System.debug('[TokenManagerService.updateTokens] We didn\'t find user with this REFRESH-TOKEN');
                return pageReference;
            }
            String jwtToken = generateJWTToken(userId);
            String refreshToken = generateRefreshToken(userId);
            
            CookieManagerService cookieManager = new CookieManagerService();
            cookieManager.setAuthenticationCookie(jwtToken, refreshToken);
        }
        catch(Exception e){
            // likely if client has fake refresh token
            System.debug('[TokenManagerService.updateTokens] When you tried to get REFRESH-TOKEN you got exception: '+ e);
            return pageReference;
        }
        
        return null;
    }
}