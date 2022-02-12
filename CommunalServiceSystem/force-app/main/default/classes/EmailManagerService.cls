public class EmailManagerService {
    
    public List<Messaging.SendEmailResult> sendEmail(List<String> recipients, String textBody, String subject){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(recipients);
        mail.setHtmlBody('<p style="text-align: center;">'+ textBody +'</p>');
        mail.setSubject(subject);
        
        return Messaging.sendEmail(new List<Messaging.Email>{mail});
    }
    
    public Messaging.EmailFileAttachment generatePDF(String username, Decimal paymentFraction, Decimal amountToPay, Datetime paymentDateTime){
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        
        attachment.setContentType('application/pdf');
        attachment.setFileName('Your bill');
        attachment.setInline(true);
        String body = 'Username: ' + username + '\nPayment fraction: ' + paymentFraction + 
            '\nAmount to pay: ' + amountToPay + '\n\nDate and time of transaction: ' + paymentDateTime;
        attachment.body = Blob.toPdf(body);
        
        return attachment;
    }
    
    public List<Messaging.SendEmailResult> sendEmailWithAttachments(List<String> recipients, String textBody, String subject,  List<Messaging.EmailFileAttachment> attachments){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(recipients);
        mail.setHtmlBody('<p style="text-align: center;">'+ textBody +'</p>');
        mail.setSubject(subject);
        mail.setFileAttachments(attachments);
        
        return Messaging.sendEmail(new List<Messaging.Email>{mail});
    }
}