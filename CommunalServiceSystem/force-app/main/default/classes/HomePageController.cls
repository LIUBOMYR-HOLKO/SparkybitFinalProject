public with sharing class HomePageController {
    public PageReference redirectToLoginPage(){
        PageReference pg = new pageReference('/apex/LoginPage');
        return pg;
    }
    
    public PageReference redirectToRegisterPage(){
        PageReference pg = new pageReference('/apex/RegisterPage');
        return pg;
    }
}
