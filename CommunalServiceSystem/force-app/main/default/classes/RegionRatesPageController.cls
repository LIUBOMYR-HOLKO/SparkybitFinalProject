public class RegionRatesPageController {
    
    
    public User__c manager{get;set;}
    public Region__c region{get;set;}
    
    public String name{get;set;}
    public String state{get;set;}
    public Decimal electricityRates{get;set;}
    public Decimal gasRates{get;set;}
    public Decimal waterRates{get;set;}
    
    TokenManagerService tokenManager = new TokenManagerService();
    UserManagerService userManager = new UserManagerService();
    
    public RegionRatesPageController() {
        
        
        
        CookieManagerService cookieManager = new CookieManagerService();
        String Id = tokenManager.getUserIdByAccessToken(cookieManager.getCookie('ACCESS-TOKEN'));
        System.debug(Id);        
        manager = [SELECT Id, State__c FROM User__c WHERE Id = :Id];
        System.debug(manager);
        region = [SELECT Name, State__c, Electricity_Rate__c, Gas_Rate__c, Water_Rate__c FROM Region__c WHERE State__c = :manager.State__c LIMIT 1];
                System.debug(region);
        name = region.Name;
        state = region.State__c;
        electricityRates = region.Electricity_Rate__c;
        gasRates = region.Gas_Rate__c;
        waterRates = region.Water_Rate__c;
        
        
        
    }
    public Pagereference authChecker(){
        UserManagerService userManager = new UserManagerService();
        PageReference pageReference = userManager.updateTokenIfNecessary();
        if(userManager.isAuthorized()){
            return pageReference;
        }
        return new PageReference('/apex/HomePage');
    }
    
    public void quicksave(){
        try{
            region.Electricity_Rate__c =electricityRates;
            region.Gas_Rate__c = gasRates;
            region.Water_Rate__c = waterRates;
            
            update region;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'You successfully changed rates for region'));
        }
        catch(Exception e){
            System.debug('[RegionRatesPageController.quicksave] When you tried change rates you got exception: '+e);
        }
    }
}