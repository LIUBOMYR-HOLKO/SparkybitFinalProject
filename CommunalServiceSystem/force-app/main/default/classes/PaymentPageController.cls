public class PaymentPageController {
    public String paymentFraction{get;set;} 
    public Decimal deposit{get;set;}
    public Decimal amountForElectricity{get;set;}
    public Decimal amountForGas{get;set;}
    public Decimal amountForWater{get;set;}
    public Decimal amountToPay{get{return (amountForElectricity+ amountForGas+amountForWater)*Decimal.valueOf(paymentFraction);} set;}
    public User__c user{get;set;}
    
    TokenManagerService tokenManager = new TokenManagerService();
    
    public PaymentPageController() {
        CookieManagerService cookieManager = new CookieManagerService();
        String Id = tokenManager.getUserIdByAccessToken(cookieManager.getCookie('ACCESS-TOKEN'));
        user = [SELECT Id,Name,Email__c,Deposit__c,Amount_For_Electricity__c,Amount_For_Gas__c ,Amount_For_Water__c FROM User__c WHERE Id = :Id];
        
        paymentFraction = '0.25';
        deposit = user.Deposit__c;
        amountForElectricity = user.Amount_For_Electricity__c;
        amountForGas = user.Amount_For_Gas__c;
        amountForWater = user.Amount_For_Water__c;
        amountToPay = (amountForElectricity+ amountForGas+amountForWater)*Decimal.valueOf(paymentFraction);
    }
    
    public Pagereference authChecker(){
        UserManagerService userManager = new UserManagerService();
        return userManager.updateTokenIfNecessary();
    }
    
    public List<SelectOption> partOrAllPayment{
        get{
            return new List<SelectOption>{new SelectOption('0.25','25%'), new SelectOption('0.50', '50%'),new SelectOption('0.75','75%'), new SelectOption('1', '100%')};
            }
        set;
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

                EmailManagerService emailManager = new EmailManagerService();
                Messaging.EmailFileAttachment billInPDF =  emailManager.generatePDF(user.Name, paymentFractionDecimal, amountToPay, Datetime.now());
                //emailManager.sendEmailWithAttachments(new List<String>{user.Email__c}, 'Hi, ' + user.Name + '!\nYou successfully pay for services.',
                  //           'Bill', new List<Messaging.EmailFileAttachment>{billInPDF});
            }
            return pageReference;
        }
        catch(Exception e){
            System.debug('[PaymentPageController.pay] When you tried pay you got exception'+e);
        }
        
        return null;
    }
    
    public Pagereference redirectToProfileInfoPage(){
        return new Pagereference('/apex/ProfileInfoPage');
    }
    
}