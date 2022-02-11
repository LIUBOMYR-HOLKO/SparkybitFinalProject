public class RegisterPageController {

    public String email{get;set;}
    public String password{get;set;}
    public String name{get;set;}
    public String regionName{get;set;}
    public List<SelectOption> regions{get;set;}
    

    public RegisterPageController(){
        regions = regionsToSelectOptionList();
    }

    public PageReference register(){
        UserManagerService userManager = new UserManagerService();
        Region__c region = [SELECT Id, Name FROM Region__c WHERE Name = :regionName];
        User__c user = new User__c(Email__c = email, Password__c = password, Name= name, Region__c = region.Id);
        PageReference pageReference = userManager.signUp(user);
        return pageReference;
    }

    public List<SelectOption> regionsToSelectOptionList(){
        List<SelectOption> options= new List<SelectOption>();
        
        for(Region__c region : [SELECT Name FROM Region__c]){
            options.add(new SelectOption(region.Name,region.Name));
        }     
        return options;
    }

    public PageReference redirectToLoginPage(){
        PageReference pageReference = new pageReference('/apex/LoginPage');
        return pageReference;
    }

    public PageReference redirectToHomePage(){
        PageReference pageReference = new pageReference('/apex/HomePage');
        return pageReference;
    }
}