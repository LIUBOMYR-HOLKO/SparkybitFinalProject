public class ShowUsersPageController {
    public User__c manager{get;set;}
    public List<User__c> users{get;set;}
    public String userId{get;set;}
    public Boolean hasAccess{get;set;}
    public Boolean isManager {get;set;}
    TokenManagerService tokenManager = new TokenManagerService();
    UserManagerService userManager = new UserManagerService();

    public ShowUsersPageController() {

        hasAccess = userManager.isAuthenticated();
        isManager = userManager.isAuthorized();

        if(hasAccess && isManager){
                CookieManagerService cookieManager = new CookieManagerService();
                String Id = tokenManager.getUserIdByRefreshToken(cookieManager.getCookie('REFRESH-TOKEN'));

                manager = [SELECT Id, Region__c FROM User__c WHERE Id = :Id];
                users = [SELECT Id, Name, Email__c, Region__c, Manager__c FROM User__c WHERE Region__c = :manager.Region__c AND Manager__c = false];
        }
        
    }
    public PageReference updateTokens(){
        if(!hasAccess){
            PageReference pageReference = new PageReference(ApexPages.currentPage().getUrl());

            pageReference.setRedirect(true);
            PageReference result = tokenManager.updateTokens();

            if(result == null){
                if(isManager){
                    return pageReference; 
                }
            }
            return result;
        }else{
            if(!isManager){
                PageReference pageReference =new Pagereference('/apex/HomePage');
                pageReference.setRedirect(true);
                return pageReference;
            }
        }
        return null;
    }

    public Pagereference seeHistory(){
        Pagereference pageReference = new Pagereference('/apex/HistoryPaymentPage?id='+userId);
        return pageReference;
    }

    public Pagereference editMonthlyPayment(){
        Pagereference pageReference = new Pagereference('/apex/EditMonthlyPaymentPage?id='+userId);
        return pageReference;
    }
    
}