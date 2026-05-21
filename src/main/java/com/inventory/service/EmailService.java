package com.inventory.service;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.Random;

/**
 * OOP Concept: ABSTRACTION
 * EmailService hides all JavaMail complexity behind two clean methods:
 *   - generateOtp()  → produces a 6-digit one-time password
 *   - sendOtpEmail() → delivers it to the user's inbox via Gmail SMTP
 *
 * SETUP REQUIRED (one-time):
 *   1. Use a Gmail account dedicated to this app (e.g. lumenara.noreply@gmail.com).
 *   2. Enable 2-Step Verification on that Google account.
 *   3. Go to Google Account → Security → App Passwords → generate a 16-char app password.
 *   4. Replace SENDER_EMAIL and SENDER_APP_PASSWORD below with your values.
 */
public class EmailService {

    // -----------------------------------------------------------------------
    // ⚠️  CONFIGURE THESE TWO VALUES BEFORE RUNNING
    // -----------------------------------------------------------------------
    private static final String SENDER_EMAIL       = "your_gmail@gmail.com";      // your Gmail address
    private static final String SENDER_APP_PASSWORD = "your_app_password_here";   // 16-char Gmail App Password
    // -----------------------------------------------------------------------

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int    SMTP_PORT = 587;

    /**
     * Generates a random 6-digit OTP string.
     */
    public String generateOtp() {
        int otp = 100000 + new Random().nextInt(900000); // range: 100000–999999
        return String.valueOf(otp);
    }

    /**
     * Sends the OTP to the given recipient email address.
     *
     * @param recipientEmail  the user's registered email
     * @param otp             the 6-digit code to send
     * @throws MessagingException if the email could not be delivered
     */
    public void sendOtpEmail(String recipientEmail, String otp) throws MessagingException {

        // Configure SMTP properties for Gmail TLS
        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            SMTP_HOST);
        props.put("mail.smtp.port",            String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust",       SMTP_HOST);

        // Authenticate with Gmail using the App Password
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_APP_PASSWORD);
            }
        });

        // Build the email message
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SENDER_EMAIL, false));
        message.setRecipients(Message.RecipientType.TO,
                InternetAddress.parse(recipientEmail));
        message.setSubject("Lumenara — Your Password Reset OTP");
        message.setContent(buildEmailBody(otp), "text/html; charset=UTF-8");

        // Send
        Transport.send(message);
    }

    /**
     * Builds a simple HTML email body containing the OTP.
     */
    private String buildEmailBody(String otp) {
        return "<!DOCTYPE html><html><body style=\"font-family:Arial,sans-serif;"
                + "background:#07041A;color:#EEE8FF;padding:32px;\">"
                + "<div style=\"max-width:480px;margin:auto;background:rgba(139,92,246,.08);"
                + "border:1px solid rgba(139,92,246,.30);border-radius:16px;padding:32px;\">"
                + "<h2 style=\"color:#8B5CF6;margin-top:0;\">&#128274; Password Reset</h2>"
                + "<p style=\"color:#8878A6;\">You requested a password reset for your "
                + "<strong style=\"color:#EEE8FF;\">Lumenara</strong> account.</p>"
                + "<p style=\"color:#8878A6;\">Your one-time password (OTP) is:</p>"
                + "<div style=\"font-size:36px;font-weight:700;letter-spacing:10px;"
                + "color:#00E896;text-align:center;padding:16px 0;\">" + otp + "</div>"
                + "<p style=\"color:#8878A6;font-size:13px;\">This code expires in "
                + "<strong style=\"color:#EEE8FF;\">10 minutes</strong>. "
                + "Do not share it with anyone.</p>"
                + "<hr style=\"border-color:rgba(139,92,246,.20);margin:24px 0;\">"
                + "<p style=\"color:#3A2F5A;font-size:11px;\">If you did not request this, "
                + "you can safely ignore this email.</p>"
                + "</div></body></html>";
    }
}
