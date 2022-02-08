public with sharing class RegisterPageController {

    public User__c user{get;set;}
	
    public RegisterPageController(){
        user = new User__c();
    }
    public PageReference register(){
        UserManagerService userManager = new UserManagerService();
        PageReference pageReference = userManager.signUp(user);
        return pageReference;
    }
}