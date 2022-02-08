public class RegisterPageController {

    public String email{get;set;}
    public String password{get;set;}
    public String name{get;set;}
    public String state{get;set;} 
    public List<SelectOption> states{get;set;}

    public RegisterPageController(){
        states = getPicklistValuesToSelectOptions(User__c.State__c.getDescribe());
    }

    public PageReference register(){
        UserManagerService userManager = new UserManagerService();
        User__c user = new User__c(Email__c = email, Password__c = password, Name= name, State__c = state);
        PageReference pageReference = userManager.signUp(user);
        return pageReference;
    }

    public List<SelectOption> getPicklistValuesToSelectOptions(Schema.DescribeFieldResult fieldResult){
        List<SelectOption> options= new List<SelectOption>();
        
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListValue : picklistEntries){
            options.add(new SelectOption(pickListValue.getLabel(),pickListValue.getLabel()));
        }     
        return options;
    }
}