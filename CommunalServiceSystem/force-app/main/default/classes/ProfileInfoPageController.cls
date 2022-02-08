public class ProfileInfoPageController {
    public String name{get;set;}
    public Decimal deposit{get;set;}
    public List<SelectOption> states{get;set;}
    public String state{get;set;}
    public String street{get;set;}
    public String houseNumber{get;set;}
    public Decimal appartementNumber{get;set;}
    public Decimal electricityMeterReadings{get;set;}
    public Decimal amountForElectricity{get;set;}
    public Decimal gasMeterReadings{get;set;}
    public Decimal amountForGas{get;set;}
    public Decimal waterMeterReadings{get;set;}
    public Decimal amountForWater{get;set;}



    public Boolean hasAccess{get;set;}

    TokenManagerService tokenManager = new TokenManagerService();

    public ProfileInfoPageController(){
        UserManagerService userManager = new UserManagerService();
        hasAccess = userManager.isAuthenticated();
        
        if(hasAccess){
            CookieManagerService cookieManager = new CookieManagerService();
            String Id = tokenManager.getUserIdByRefreshToken(cookieManager.getCookie('REFRESH-TOKEN'));
            User__c user = [SELECT Amount_For_Electricity__c, Amount_For_Gas__c, Amount_For_Water__c, 
            Appartement_Number__c, Deposit__c, Electricity_Meter_Readings__c, Email__c, Gas_Meter_Readings__c,
            House_Number__c, State__c, Street__c, Water_Meter_Readings__c, Id, Name FROM User__c WHERE Id = :Id ];
            name = user.Name;
            deposit = user.Deposit__c;
            states = getPicklistValuesToSelectOptions(User__c.State__c.getDescribe());
            state = user.State__c;
            street = user.Street__c;
            houseNumber = user.House_Number__c;
            appartementNumber = user.Appartement_Number__c;
            electricityMeterReadings = user.Electricity_Meter_Readings__c;
            amountForElectricity = user.Amount_For_Electricity__c;
            gasMeterReadings = user.Gas_Meter_Readings__c;
            amountForGas = user.Amount_For_Gas__c;
            waterMeterReadings = user.Water_Meter_Readings__c;
            amountForWater = user.Amount_For_Water__c;

        }
    }

    public List<SelectOption> getPicklistValuesToSelectOptions(Schema.DescribeFieldResult fieldResult){
        List<SelectOption> options= new List<SelectOption>();
        
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListValue : picklistEntries){
            options.add(new SelectOption(pickListValue.getLabel(),pickListValue.getLabel()));
        }     
        return options;
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
}