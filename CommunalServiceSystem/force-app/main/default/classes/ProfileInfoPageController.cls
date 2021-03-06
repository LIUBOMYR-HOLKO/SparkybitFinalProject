public class ProfileInfoPageController {
    public String name{get;set;}
    public Decimal deposit{get;set;}
    public Decimal electricityMeterReadings{get;set;}
    public Decimal amountForElectricity{get;set;}
    public Decimal gasMeterReadings{get;set;}
    public Decimal amountForGas{get;set;}
    public Decimal waterMeterReadings{get;set;}
    public Decimal amountForWater{get;set;}
    public String regionName{get;set;}
    public List<SelectOption> regions{get;set;}
    
    public String state{get;set;}
    
    public User__c user{get;set;}
    public String Id{get;set;}
    public Boolean hasAccess{get;set;}
    
    TokenManagerService tokenManager = new TokenManagerService();
    
    public ProfileInfoPageController(){
        try{
            CookieManagerService cookieManager = new CookieManagerService();
            Id = tokenManager.getUserIdByAccessToken(cookieManager.getCookie('ACCESS-TOKEN'));
            user = [SELECT Id, Amount_For_Electricity__c, Amount_For_Gas__c, Amount_For_Water__c, 
                    Deposit__c, Electricity_Meter_Readings__c, Email__c, Gas_Meter_Readings__c,
                    Region__r.Name, Water_Meter_Readings__c, Name FROM User__c WHERE Id = :Id ];
            name = user.Name;
            deposit = user.Deposit__c;
            regions = regionsToSelectOptionList();
            regionName = user.Region__r.Name;
            electricityMeterReadings = user.Electricity_Meter_Readings__c;
            amountForElectricity = user.Amount_For_Electricity__c;
            gasMeterReadings = user.Gas_Meter_Readings__c;
            amountForGas = user.Amount_For_Gas__c;
            waterMeterReadings = user.Water_Meter_Readings__c;
            amountForWater = user.Amount_For_Water__c;
        }
        catch(Exception e){
            System.debug('[ProfileInfoPageController.constructor] Instance of controller gave an exception: '+e);
        }
    }
    
    public List<SelectOption> regionsToSelectOptionList(){
        List<SelectOption> options= new List<SelectOption>();
        for(Region__c region : [SELECT Name FROM Region__c ORDER BY Name]){
            options.add(new SelectOption(region.Name,region.Name));
        }     
        return options;
    }
    
    public Pagereference authChecker(){
        UserManagerService userManager = new UserManagerService();
        return userManager.updateTokenIfNecessary();
    }
    
    public void quicksave(){
        try{
            Region__c region = [SELECT Id,Name, Gas_Rate__c, Water_Rate__c, Electricity_Rate__c FROM Region__c WHERE Name = :regionName];
            user.Region__c = region.Id;
            update user;
            
            user.Amount_For_Electricity__c += (electricityMeterReadings - user.Electricity_Meter_Readings__c) * region.Electricity_Rate__c;
            user.Electricity_Meter_Readings__c = electricityMeterReadings;
            user.Amount_For_Gas__c += (gasMeterReadings - user.Gas_Meter_Readings__c) * region.Gas_Rate__c;
            user.Gas_Meter_Readings__c = gasMeterReadings;
            user.Amount_For_Water__c += (waterMeterReadings - user.Water_Meter_Readings__c) * region.Water_Rate__c;
            user.Water_Meter_Readings__c = waterMeterReadings;
            update user;
            
            amountForElectricity = user.Amount_For_Electricity__c;
            amountForGas = user.Amount_For_Gas__c;
            amountForWater = user.Amount_For_Water__c;
        }
        catch(DmlException dmlException){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, dmlException.getDmlMessage(0)));
        }
        catch(Exception e){
            System.debug('[ProfileInfoPageController.quicksave] When you tried update user you got exception'+e);
        }
    }
    
    public PageReference pay(){
        return new PageReference('/apex/PaymentPage');
    }
    
    public PageReference showHistory(){
        return new PageReference('/apex/HistoryPaymentPage?id='+user.Id);
    }
    
    public void contactTheManager(){
        try{
            User__c manager = [SELECT Manager__c, Region__r.Name, Email__c FROM User__c WHERE Manager__c = true AND Region__r.Name = :user.Region__r.Name LIMIT 1];
            EmailManagerService emailManager = new EmailManagerService();
            //emailManager.sendEmail(new List<String>{manager.Email__c}, 'Contact the client with email '+user.Email__c+' and username '+user.Name+'.', 'Contact with client');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Your application has been sent to the regional manager'));
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry but in your region doesnot exist any manager'));
            System.debug('[ProfileInfoPageController.contactTheManager] When you tried contact the manager you got exception'+e);
        }
    }
    
}