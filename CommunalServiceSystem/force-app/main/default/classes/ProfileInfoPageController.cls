public class ProfileInfoPageController {
    public String name{get;set;}
    public Decimal deposit{get;set;}
    public List<SelectOption> states{get;set;}
    public String state{get;set;}
    public Decimal electricityMeterReadings{get;set;}
    public Decimal amountForElectricity{get;set;}
    public Decimal gasMeterReadings{get;set;}
    public Decimal amountForGas{get;set;}
    public Decimal waterMeterReadings{get;set;}
    public Decimal amountForWater{get;set;}


    public User__c user{get;set;}
    public String Id{get;set;}
    public Boolean hasAccess{get;set;}

    TokenManagerService tokenManager = new TokenManagerService();

    public ProfileInfoPageController(){
        UserManagerService userManager = new UserManagerService();
        hasAccess = userManager.isAuthenticated();
        
        if(hasAccess){
            CookieManagerService cookieManager = new CookieManagerService();
            Id = tokenManager.getUserIdByRefreshToken(cookieManager.getCookie('REFRESH-TOKEN'));
            user = [SELECT Id, Amount_For_Electricity__c, Amount_For_Gas__c, Amount_For_Water__c, 
            Deposit__c, Electricity_Meter_Readings__c, Email__c, Gas_Meter_Readings__c,
            State__c, Water_Meter_Readings__c, Name FROM User__c WHERE Id = :Id ];
            name = user.Name;
            deposit = user.Deposit__c;
            states = getPicklistValuesToSelectOptions(User__c.State__c.getDescribe());
            state = user.State__c;
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

    public Pagereference updateTokens(){
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
	
    
    public Boolean canSetUserData(){
        try{
            Region__c region = [SELECT Id,State__c, Gas_Rate__c, Water_Rate__c, Electricity_Rate__c FROM Region__c WHERE State__c = :state];

            user.Amount_For_Electricity__c += (electricityMeterReadings - user.Electricity_Meter_Readings__c) *region.Electricity_Rate__c ;
            user.Electricity_Meter_Readings__c = electricityMeterReadings;
            user.Amount_For_Gas__c += (gasMeterReadings - user.Gas_Meter_Readings__c)* region.Gas_Rate__c;
            user.Gas_Meter_Readings__c = gasMeterReadings;
            user.Amount_For_Water__c += (waterMeterReadings - user.Water_Meter_Readings__c)* region.Water_Rate__c;
            user.Water_Meter_Readings__c = waterMeterReadings;

            if(state!=user.State__c){
                Decimal amountToPay = user.Amount_For_Electricity__c + user.Amount_For_Gas__c + user.Amount_For_Water__c;
                System.debug(amountToPay);
                System.debug(amountToPay!=0);
                if(amountToPay!= 0){
                    System.debug('here 1');
                    
                    return false;
                }else{
                    System.debug('here 2');
                    user.State__c= state;
                    return true;
                }
             }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'In new region doesnnot exist any communal service'));
            System.debug('[ProfileInfoPageController.quicksave] When you tried update user you got exception'+e);
            return false;
        }
        return true;
    }
    public Pagereference quicksave(){
        try{
 
			if(canSetUserData()){
                update user;
            }else{
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You cannot update state if you have dobt'));
               return null;
            }
        }
        catch(Exception e){
            System.debug('[ProfileInfoPageController.quicksave] When you tried update user you got exception'+e);
        }
        PageReference pageReference = new PageReference('/apex/ProfileInfoPage');
        pageReference.setRedirect(true);
        return pageReference;
    }

    public PageReference pay(){
        PageReference pageReference = new PageReference('/apex/PaymentPage');
        pageReference.setRedirect(false);
        return pageReference;
    }
    
   	public PageReference showHistory(){
        PageReference pageReference = new PageReference('/apex/HistoryPaymentPage');
        pageReference.setRedirect(false);
        return pageReference;
    }

    public void contactTheManager(){
        try{
            User__c manager = [SELECT Manager__c, State__c, Email__c FROM User__c WHERE Manager__c = true AND State__c = :user.State__c LIMIT 1];
            System.debug(manager);
            EmailManagerService emailManager = new EmailManagerService();
            emailManager.sendEmail(new List<String>{manager.Email__c}, 'Contact the client with email '+user.Email__c+' and username '+user.Name+'.', 'Contact with client');

            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Your application has been sent to the regional manager'));
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Sorry but in your region doesnot exist any manager'));
            System.debug('[ProfileInfoPageController.contactTheManager] When you tried contact the manager you got exception'+e);
        }
    }
    
}