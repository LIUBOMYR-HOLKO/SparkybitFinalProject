public class LoginPageController {
    public String email{get;set;}
    public String password{get;set;}
    
    public PageReference login(){
        UserManagerService userManager = new UserManagerService();
        return userManager.signIn(email, password);
    }
}
