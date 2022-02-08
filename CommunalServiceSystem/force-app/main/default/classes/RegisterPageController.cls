public class RegisterPageController {

    public String email{get;set;}
    public String password{get;set;}
    public String name{get;set;}
    public String state{get;set;}  

    public PageReference register(){
        UserManagerService userManager = new UserManagerService();
        User__c user = new User__c(Email__c = email, Password__c = password, Name= name, State__c = state);
        PageReference pageReference = userManager.signUp(user);
        return pageReference;
    }
}