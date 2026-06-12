import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static const String _gmailUser = 'auduongtan321@gmail.com';
  static const String _gmailAppPassword = 'khnpwmqyzszmrciq';

  static Future<bool> sendEmail({
    required String recipient,
    required String subject,
    required String body,
  }) async {
    final smtpServer = gmail(_gmailUser, _gmailAppPassword);
    
    final message = Message()
      ..from = const Address(_gmailUser, 'UTC2 Student Portal')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    await send(message, smtpServer);
    return true;
  }
}
