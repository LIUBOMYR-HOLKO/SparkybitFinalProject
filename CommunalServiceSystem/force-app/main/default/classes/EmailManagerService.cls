public with sharing class EmailManagerService {

    public void sendEmail(List<String> recipients, String textBody, String subject){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(recipients);
        mail.setHtmlBody('<p style="text-align: center;">'+ textBody +'</p>');
        mail.setSubject(subject);
        
        Messaging.sendEmail(new List<Messaging.Email>{mail});
    }
}
