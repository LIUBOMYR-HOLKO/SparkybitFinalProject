public class HomePageController {
    public Boolean guest{get;set;}
    public Boolean user{get;set;}
    public Boolean manager{get;set;}
    
    public PageReference authChecker(){
        UserManagerService userManager = new UserManagerService();
        PageReference pageReference = userManager.updateTokenIfNecessary();
        
        if(pageReference == null){        
            if(userManager.isAuthorized()){
                manager = true;
            }
            else{
                user = true;
            }
            return null;
        }
        else if(pageReference.getUrl() == '/apex/LoginPage'){
            guest = true;
            return null;
        }
        Pagereference currentReference = ApexPages.currentPage();
        currentReference.setRedirect(true);
        return currentReference;
    }
    
    public PageReference redirectToLoginPage(){
        PageReference pageReference = new pageReference('/apex/LoginPage');
        return pageReference;
    }
    
    public PageReference redirectToProfileInfoPage(){
        PageReference pageReference = new pageReference('/apex/ProfileInfoPage');
        return pageReference;
    }
    
    public PageReference redirectToRegisterPage(){
        PageReference pageReference = new pageReference('/apex/RegisterPage');
        return pageReference;
    }
    
    public PageReference redirectToShowUsersPage(){
        PageReference pageReference = new pageReference('/apex/ShowUsersPage');
        return pageReference;
    }
    /*
    public PageReference redirectToHomePage(){
        UserManagerService userManager = new UserManagerService();
        PageReference pageReference = userManager.signOut();
        pageReference.setRedirect(true);
        return pageReference;
    }
    */
}