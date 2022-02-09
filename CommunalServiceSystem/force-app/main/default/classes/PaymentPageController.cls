public class PaymentPageController {
    public String paymentFraction{get;set;} 
    public Decimal deposit{get;set;}
    public Decimal amountForElectricity{get;set;}
    public Decimal amountForGas{get;set;}
    public Decimal amountForWater{get;set;}
    public Decimal amountToPay{get{return (amountForElectricity+ amountForGas+amountForWater)*Decimal.valueOf(paymentFraction);} set;}
    public User__c user{get;set;}
    public Boolean hasAccess{get;set;}
    TokenManagerService tokenManager = new TokenManagerService();

    public PaymentPageController() {
        UserManagerService userManager = new UserManagerService();
        hasAccess = userManager.isAuthenticated();

        if(hasAccess){
            CookieManagerService cookieManager = new CookieManagerService();
            String Id = tokenManager.getUserIdByRefreshToken(cookieManager.getCookie('REFRESH-TOKEN'));
            user = [SELECT Id,Name,Deposit__c,Amount_For_Electricity__c,Amount_For_Gas__c ,Amount_For_Water__c FROM User__c WHERE Id = :Id];

            paymentFraction = '0.25';
            deposit = user.Deposit__c;
            amountForElectricity = user.Amount_For_Electricity__c;
            amountForGas = user.Amount_For_Gas__c;
            amountForWater = user.Amount_For_Water__c;
            amountToPay = (amountForElectricity+ amountForGas+amountForWater)*Decimal.valueOf(paymentFraction);

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
    public List<SelectOption> partOrAllPayment{
        get{
            return new List<SelectOption>{new SelectOption('0.25','25%'), new SelectOption('0.50', '50%'),new SelectOption('0.75','75%'), new SelectOption('1', '100%')};
        }
    }

    public Pagereference pay(){
        PageReference pageReference = new Pagereference('/apex/ProfileInfoPage');
        try{
            if(amountToPay != 0){
            Decimal paymentFractionDecimal = Decimal.valueOf(paymentFraction);
            user.Amount_For_Water__c -= user.Amount_For_Water__c * paymentFractionDecimal;
            user.Amount_For_Gas__c -= user.Amount_For_Gas__c * paymentFractionDecimal;
            user.Amount_For_Electricity__c -= user.Amount_For_Electricity__c *paymentFractionDecimal;
            user.Deposit__c -= amountToPay * paymentFractionDecimal;
            update user;

            Billing__c billing = new Billing__c(Name = user.Name + ' ' +amountToPay.round(), User__c = user.Id, Amount__c = amountToPay, Part_Of_Amount__c =paymentFractionDecimal*100);
            insert billing;
            }
            return pageReference;
        }
        catch(Exception e){
            //pageReference.setRedirect(true);
            System.debug('[PaymentPageController.pay] When you tried pay you got exception'+e);

        }
        
        return null;
    }

}