import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // Hàm gửi email qua Gmail SMTP sử dụng App Password
  static Future<bool> sendGmail({
    required String senderEmail,
    required String appPassword, // Mật khẩu ứng dụng của Gmail (không phải mật khẩu chính)
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    // 1. Cấu hình SMTP Server cho Gmail
    final smtpServer = gmail(senderEmail, appPassword);

    // 2. Thiết lập nội dung email
    final message = Message()
      ..from = Address(senderEmail, 'Ứng dụng quản lý danh bạ (DBMan)')
      ..recipients.add(recipientEmail) // Người nhận
      ..subject = subject // Tiêu đề
      ..text = body; // Nội dung dạng text

    try {
      // 3. Thực hiện gửi email
      final sendReport = await send(message, smtpServer);
      print('Gửi email thành công: ${sendReport.toString()}');
      return true;
    } on MailerException catch (e) {
      print('Gửi email thất bại: $e');
      for (var p in e.problems) {
        print('Lỗi chi tiết: ${p.code} - ${p.msg}');
      }
      return false;
    }
  }
}
