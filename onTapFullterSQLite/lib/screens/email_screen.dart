import 'package:flutter/material.dart';
import '../services/email_service.dart';

class EmailScreen extends StatefulWidget {
  final String? initialRecipient;

  const EmailScreen({super.key, this.initialRecipient});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _senderController = TextEditingController(text: 'your-email@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: 'your-app-password');
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController(text: 'Thông báo từ ứng dụng DBMan');
  final TextEditingController _bodyController = TextEditingController(text: 'Xin chào,\n\nĐây là email thử nghiệm gửi từ ứng dụng Flutter sử dụng package mailer.');

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialRecipient != null) {
      _recipientController.text = widget.initialRecipient!;
    }
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    final success = await EmailService.sendGmail(
      senderEmail: _senderController.text.trim(),
      appPassword: _passwordController.text.trim(),
      recipientEmail: _recipientController.text.trim(),
      subject: _subjectController.text.trim(),
      body: _bodyController.text.trim(),
    );

    setState(() {
      _isSending = false;
    });

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi email thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Gửi email thất bại'),
          content: const Text(
            'Không thể gửi email. Vui lòng kiểm tra lại:\n'
            '1. Email gửi đã bật Xác thực 2 bước (2-Step Verification) chưa.\n'
            '2. Mật khẩu ứng dụng (App Password) đã được tạo chính xác chưa.\n'
            '3. Kết nối internet.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ĐÓNG'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gửi Email (SMTP)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF2A56C6),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cấu hình Gmail SMTP',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 10),
              
              // Email gửi (Sender)
              TextFormField(
                controller: _senderController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Gmail người gửi (Sender)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập email người gửi';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // App Password (Mật khẩu ứng dụng)
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu ứng dụng Gmail (App Password)',
                  border: OutlineInputBorder(),
                  helperText: 'Lưu ý: Phải tạo mật khẩu ứng dụng 16 ký tự trong tài khoản Google.',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập mật khẩu ứng dụng';
                  return null;
                },
              ),
              const SizedBox(height: 25),

              const Text(
                'Nội dung thư',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 10),

              // Email nhận (Recipient)
              TextFormField(
                controller: _recipientController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email người nhận (Recipient)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập email người nhận';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Tiêu đề thư
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề (Subject)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập tiêu đề';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Nội dung thư (Body)
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Nội dung thư (Body)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập nội dung';
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // Nút gửi email
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSending ? null : _sendEmail,
                  icon: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isSending ? 'ĐANG GỬI...' : 'GỬI EMAIL'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
