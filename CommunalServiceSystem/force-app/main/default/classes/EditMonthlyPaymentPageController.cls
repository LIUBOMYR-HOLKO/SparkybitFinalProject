public class EditMonthlyPaymentPageController {
    
    
    TokenManagerService tokenManager = new TokenManagerService();
    UserManagerService userManager = new UserManagerService();
    
    public String name{get;set;}
    public Decimal amountForElectricity{get;set;}
    public Decimal amountForGas{get;set;}
    public Decimal amountForWater{get;set;}
    
    public User__c user{get;set;}
    
    public EditMonthlyPaymentPageController() {
        try{
            String Id = apexpages.currentpage().getparameters().get('id');
            user = [SELECT Id, Name, Amount_For_Electricity__c, Amount_For_Gas__c, Amount_For_Water__c FROM User__c WHERE Id = :Id];
            name = user.Name;
            amountForElectricity = user.Amount_For_Electricity__c;
            amountForGas = user.Amount_For_Gas__c;
            amountForWater = user.Amount_For_Water__c;
        }
        catch(Exception e){
            System.debug('[EditMonthlyPaymentPageController.constructor] Instance of controller gave exception'+e);
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
    
    
    public Pagereference quicksave(){
        try{
            user.Amount_For_Electricity__c = amountForElectricity;
            user.Amount_For_Gas__c = amountForGas;
            user.Amount_For_Water__c = amountForWater;
            update user;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'You successfully changed user amounts'));
            return null;
        }
        catch(Exception e){
            System.debug('[EditMonthlyPaymentPageController.quicksave] When you tried update user you got exception'+e);
        }
        PageReference pageReference = new PageReference('/apex/ProfileInfoPage');
        pageReference.setRedirect(true);
        return pageReference;
    }
    
    public Pagereference redirectToShowUsers(){
        return new PageReference('/apex/ShowUsersPage');
    }
    
}