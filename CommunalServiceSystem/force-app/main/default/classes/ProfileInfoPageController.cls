public class ProfileInfoPageController {
    public String Id {get;set;}
    public User__c user{get;set;}
    public ProfileInfoPageController(){
        TokenManagerService  tokenManager = new TokenManagerService();
        CookieManagerService cookieManager = new CookieManagerService();
        Id = tokenManager.getUserIdByRefreshToken(cookieManager.getCookie('REFRESH-TOKEN'));
        user = [SELECT Amount_For_Electricity__c, Amount_For_Gas__c, Amount_For_Water__c, 
        Appartement_Number__c, Deposit__c, Electricity_Meter_Readings__c, Electricity_Service__c, Email__c, Gas_Meter_Readings__c,
        Gas_Serivce__c, House_Number__c, State__c, Street__c, Water_Meter_Readings__c, Water_Service__c, Id, Name FROM User__c WHERE Id = :Id ];
    }
}