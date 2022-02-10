public class LoginPageController {
    public String email{get;set;}
    public String password{get;set;}
    
    public PageReference login(){
        UserManagerService userManager = new UserManagerService();
        return userManager.signIn(email, password);
    }

    public PageReference redirectToRegisterPage(){
        PageReference pg = new pageReference('/apex/RegisterPage');
        return pg;
    }

    public PageReference redirectToHomePage(){
        PageReference pg = new pageReference('/apex/HomePage');
        return pg;
    }
}