import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../services/database_service.dart';
import '../services/email_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _recoverPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();

    try {
      final user = await DatabaseService.instance.getUserByEmail(email);

      setState(() => _isLoading = false);

      if (user == null) {
        _showDialog('Thất bại', 'Địa chỉ email này chưa được đăng ký!');
        return;
      }

      await EmailService.sendEmail(
        recipient: email,
        subject: 'Khôi phục thông tin tài khoản - UTC2',
        body: 'Thông tin tài khoản của bạn:\nEmail: ${user.email}\nMật khẩu: ${user.password}',
      );

      _showDialog('Thành công', 'Thông tin tài khoản đã được gửi về email của bạn.');
    } catch (e) {
      setState(() => _isLoading = false);
      _showDialog('Lỗi', 'Không thể gửi email. Lỗi: $e');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (title == 'Thành công') Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: AppConstants.iconColor)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(AppConstants.logoUrl, height: 100),
                const SizedBox(height: 16),
                const Text(
                  'Quên Mật Khẩu',
                  style: TextStyle(color: AppConstants.iconColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Card(
                  color: AppConstants.itemColor,
                  shape: RoundedRectangleBorder(borderRadius: AppConstants.borderRadius),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: AppValidators.validateEmail,
                          decoration: InputDecoration(
                            labelText: 'Email đã đăng ký',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(FontAwesomeIcons.envelope, color: AppConstants.iconColor),
                            ),
                            border: OutlineInputBorder(borderRadius: AppConstants.borderRadius),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _recoverPassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.buttonColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: AppConstants.borderRadius),
                                  ),
                                  child: const Text('Gửi Mật Khẩu', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Quay lại Đăng nhập', style: TextStyle(color: AppConstants.iconColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
