public class RegionRatesPageController {
    public Boolean hasAccess{get;set;}
    public Boolean isManager {get;set;}
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
        hasAccess = userManager.isAuthenticated();
        isManager = userManager.isAuthorized();
        if(hasAccess && isManager){
                CookieManagerService cookieManager = new CookieManagerService();
                String Id = tokenManager.getUserIdByRefreshToken(cookieManager.getCookie('REFRESH-TOKEN'));
                manager = [SELECT Id, State__c FROM User__c WHERE Id = :Id];
                region = [SELECT Name, State__c, Electricity_Rate__c, Gas_Rate__c, Water_Rate__c FROM Region__c WHERE State__c = :manager.State__c LIMIT 1];
                name = region.Name;
                state = region.State__c;
                electricityRates = region.Electricity_Rate__c;
                gasRates = region.Gas_Rate__c;
                waterRates = region.Water_Rate__c;

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