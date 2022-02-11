public class EmailManagerService {

    public List<Messaging.SendEmailResult> sendEmail(List<String> recipients, String textBody, String subject){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(recipients);
        mail.setHtmlBody('<p style="text-align: center;">'+ textBody +'</p>');
        mail.setSubject(subject);
        
        return Messaging.sendEmail(new List<Messaging.Email>{mail});
    }
}