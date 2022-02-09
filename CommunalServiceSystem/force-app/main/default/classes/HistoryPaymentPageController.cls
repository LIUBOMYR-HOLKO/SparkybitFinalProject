public class HistoryPaymentPageController {
    public List<Billing__c> billings{get;set;}
    public Boolean hasAccess{get;set;}
    TokenManagerService tokenManager = new TokenManagerService();
    
   // public List<
    
    public HistoryPaymentPageController() {
        UserManagerService userManager = new UserManagerService();
        hasAccess = userManager.isAuthenticated();

        if(hasAccess){
            CookieManagerService cookieManager = new CookieManagerService();
            String Id = tokenManager.getUserIdByRefreshToken(cookieManager.getCookie('REFRESH-TOKEN'));
			billings = [SELECT User__r.Id, User__r.Name, Part_Of_Amount__c, Amount__c, CreatedDate FROM Billing__c WHERE User__r.Id = :Id];


        }
        
    }
    
    public PageReference updateTokens(){
        if(!hasAccess){
            PageReference pageReference = new PageReference(ApexPages.currentPage().getUrl());
            pageReference.setRedirect(true);
            
            PageReference result = tokenManager.updateTokens();
            if(result == null){
                return pageReference; 
            }
            return result;
        }
        return null;
    }
}