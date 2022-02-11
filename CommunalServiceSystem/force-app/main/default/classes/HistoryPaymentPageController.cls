public class HistoryPaymentPageController {
    public List<Billing__c> billings{get;set;}
    public Boolean manager{get;set;}

    //can see everybody if know ID. Fix it    
    public HistoryPaymentPageController() {
        UserManagerService userManager = new UserManagerService();
        
        String Id = apexpages.currentpage().getparameters().get('id');
        billings = [SELECT User__r.Id, User__r.Name, Part_Of_Amount__c, Amount__c, CreatedDate FROM Billing__c WHERE User__r.Id = :Id];
        
    }
    
    public Pagereference authChecker(){
        UserManagerService userManager = new UserManagerService();
        PageReference pageReference = userManager.updateTokenIfNecessary();
        if(userManager.isAuthorized()){
            manager = true;
        }
        return pageReference;
    }
    
    
    
    public PageReference redirectToProfileInfoPage(){
        PageReference pg = new pageReference('/apex/ProfileInfoPage');
        return pg;
    }
}