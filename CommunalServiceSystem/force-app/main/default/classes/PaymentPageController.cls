public class PaymentPageController {
    public String paymentFraction{get;set;} 
    public Decimal amountForElectricity{get;set;}
    public Decimal amountForGas{get;set;}
    public Decimal amountForWater{get;set;}
    public Decimal amountToPay{get;set;}
    public User__c user{get;set;}
    public Boolean hasAccess{get;set;}
    TokenManagerService tokenManager = new TokenManagerService();

    public PaymentPageController() {
        UserManagerService userManager = new UserManagerService();
        hasAccess = userManager.isAuthenticated();
        if(hasAccess){
            CookieManagerService cookieManager = new CookieManagerService();

            String Id = tokenManager.getUserIdByRefreshToken(cookieManager.getCookie('REFRESH-TOKEN'));
            user = [SELECT Id,Amount_For_Electricity__c,Amount_For_Gas__c ,Amount_For_Water__c FROM User__c WHERE Id = :Id];
            amountForElectricity = user.Amount_For_Electricity__c;
            amountForGas = user.Amount_For_Gas__c;
            amountForWater = user.Amount_For_Water__c;
            amountToPay = (amountForElectricity+ amountForGas+amountForWater)*Decimal.valueOf(paymentFraction)/100;
        }
    }

    public PageReference updateTokens(){
        if(!hasAccess){
            PageReference pr = new PageReference(ApexPages.currentPage().getUrl());
            pr.setRedirect(true);
            
            PageReference result = tokenManager.updateTokens();
            if(result == null){
                return pr; 
            }
            return result;
        }
        return null;
    }
    public List<SelectOption> partOrAllPayment{
        get{
            return new List<SelectOption>{new SelectOption('25%','25'), new SelectOption('50%', '50'),new SelectOption('75%','75'), new SelectOption('100%', '100')};
        }
    }

    public Pagereference pay(){
        return null;
    }
}
