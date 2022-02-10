public class EditMonthlyPaymentPageController {
    public Boolean hasAccess{get;set;}
    public Boolean isManager {get;set;}
    TokenManagerService tokenManager = new TokenManagerService();
    UserManagerService userManager = new UserManagerService();

    public String name{get;set;}
    public Decimal amountForElectricity{get;set;}
    public Decimal amountForGas{get;set;}
    public Decimal amountForWater{get;set;}

    public User__c user{get;set;}

    public EditMonthlyPaymentPageController() {

        hasAccess = userManager.isAuthenticated();
        isManager = userManager.isAuthorized();

        if(hasAccess && isManager){
            String Id = apexpages.currentpage().getparameters().get('id');
			user = [SELECT Id, Name, Amount_For_Electricity__c, Amount_For_Gas__c, Amount_For_Water__c FROM User__c WHERE Id = :Id];
            name = user.Name;
            amountForElectricity = user.Amount_For_Electricity__c;
            amountForGas = user.Amount_For_Gas__c;
            amountForWater = user.Amount_For_Water__c;
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

}