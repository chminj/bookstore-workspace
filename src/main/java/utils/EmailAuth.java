package utils;

import java.util.Properties;
import java.util.Random;

import domain.user.dao.EmailAuthDao;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.InternetAddress;

public class EmailAuth {
	
	public static void sendEmail(String to) throws MessagingException {
		
		// 1. 이메일 서버 설정
		Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
    	// 2. 로그인 정보 설정
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("gyulbbbe@gmail.com", "ktkg pqjo cbxr whcg");
            }
        });
        
        // 3. 토큰번호를 생성하여 이메일과 함께 데이터베이스에 저장시킨다.
		Random random = new Random();
		int token = random.nextInt(900000) + 100000;
		EmailAuthDao emailAuthDao = new EmailAuthDao();
		// 3-1. 아직 해당 이메일에 존재하는 토큰번호가 있다면 삭제
		emailAuthDao.deleteToken(to);
		emailAuthDao.insertToken(to, token);
        
        // 4. 이메일 내용
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress("gyulbbbe@gmail.com"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject("2조 세미프로젝트 회원가입 인증 번호");
        message.setText(String.valueOf(token));
        
        // 5. 이메일 전송
        Transport.send(message);
	}
	
	
	/**
	 * 이메일에 저장된 토큰과 입력한 값과 비교한다.
	 * @param email 
	 * @param token 입력한 토큰 번호
	 * @return
	 */
	public static boolean compareToken(String email, int inputToken) {
		EmailAuthDao emailAuthDao = new EmailAuthDao();
		int savedToken = emailAuthDao.getTokenByEmail(email);
		if (savedToken == inputToken) {
			return true;
		}
		return false;
	}
}