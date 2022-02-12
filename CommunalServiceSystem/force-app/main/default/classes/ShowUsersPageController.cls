public class ShowUsersPageController {
    public User__c manager{get;set;}
    public List<User__c> users{get;set;}
    public String userId{get;set;}
    
    
    
    public ShowUsersPageController() {
        try{
            TokenManagerService tokenManager = new TokenManagerService();
            CookieManagerService cookieManager = new CookieManagerService();
            String Id = tokenManager.getUserIdByAccessToken(cookieManager.getCookie('ACCESS-TOKEN'));
            manager = [SELECT Id, Region__c FROM User__c WHERE Id = :Id AND Manager__c = true];
            users = [SELECT Id, Name, Email__c, Region__c, Manager__c FROM User__c WHERE Region__c = :manager.Region__c AND Manager__c = false];
        }
        catch(Exception e){
            System.debug('constructor of controller '+ e);
        }
        
    }
    
    public Pagereference authChecker(){
        UserManagerService userManager = new UserManagerService();
        PageReference pageReference = userManager.updateTokenIfNecessary();
        if(userManager.isAuthorized()){
            return pageReference;
        }
        return new PageReference('/apex/HomePage');
    }
    
    
    public Pagereference seeHistory(){
        Pagereference pageReference = new Pagereference('/apex/HistoryPaymentPage?id='+userId);
        return pageReference;
    }
    
    public Pagereference editMonthlyPayment(){
        Pagereference pageReference = new Pagereference('/apex/EditMonthlyPaymentPage?id='+userId);
        return pageReference;
    }
    
    public Pagereference redirectToHomePage(){
        return new PageReference('/apex/HomePage');
    }
}