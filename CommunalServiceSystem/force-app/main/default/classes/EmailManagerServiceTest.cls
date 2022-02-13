@isTest
public class EmailManagerServiceTest {
    
    @isTest
    public static void sendEmailPositiveTest(){
        EmailManagerService emailManager = new EmailManagerService();
        List<String> recepients = new List<String>{'golko04102001@gmail.com'};
            String body = 'test body';
        String subject = 'test method';
        
        Test.startTest();
        List<Messaging.SendEmailResult> sendEmailResultList = emailManager.sendEmail(recepients, body, subject);
        Test.stopTest();
        
        System.assertEquals(1, sendEmailResultList.size());
        System.assertEquals(true, sendEmailResultList[0].success);
    }
    
    @isTest
    public static void generatePDFPosistiveTest(){
        EmailManagerService emailManager = new EmailManagerService();
        
        Test.startTest();
        Messaging.EmailFileAttachment attachment = emailManager.generatePDF('test', 1.0, 1.0, Datetime.now());
        Test.stopTest();
        
        System.assertEquals('Your bill', attachment.filename);
        System.assertEquals('application/pdf', attachment.contenttype);
    }
    
    @isTest
    public static void sendEmailWithAttachmentsPositiveTest(){
        EmailManagerService emailManager = new EmailManagerService();
        List<String> recepients = new List<String>{'golko04102001@gmail.com'};
            String body = 'test body';
        String subject = 'test method';
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>{emailManager.generatePDF('test', 1.0, 1.0, Datetime.now())};
            
            Test.startTest();
        List<Messaging.SendEmailResult> sendEmailWithAttachmentsResultList = emailManager.sendEmailWithAttachments(recepients, body, subject, attachments);
        Test.stopTest();
        
        System.assertEquals(1, sendEmailWithAttachmentsResultList.size());
        System.assertEquals(true, sendEmailWithAttachmentsResultList[0].success);
    }
    
}