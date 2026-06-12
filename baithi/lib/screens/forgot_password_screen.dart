import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../services/database_service.dart';
import '../services/email_service.dart';

/// Màn hình Quên Mật Khẩu (Câu 3 - 3 điểm)
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Hàm xử lý yêu cầu Khôi phục mật khẩu
  Future<void> _recoverPassword() async {
    // 1. Kiểm tra tính hợp lệ của Form nhập liệu
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Bắt đầu hiển thị Loading
    });

    final email = _emailController.text.trim();

    try {
      // 2. Kiểm tra email có tồn tại trong CSDL SQLite không (Yêu cầu đề bài)
      final user = await DatabaseService.instance.getUserByEmail(email);

      if (user == null) {
        // Email không tồn tại trong database
        setState(() {
          _isLoading = false;
        });
        
        // Hiển thị thông báo thất bại (Icon fas fa-exclamation-circle)
        _showFeedbackDialog(
          success: false,
          title: 'Thất bại!',
          message: 'Địa chỉ email này chưa được đăng ký trong hệ thống.',
        );
        return;
      }

      // 3. Tiến hành gửi email chứa thông tin tài khoản và mật khẩu (Yêu cầu đề bài)
      final subject = 'Khôi phục thông tin tài khoản - UTC2';
      final body = 'Thông tin tài khoản của bạn:\nEmail: ${user.email}\nMật khẩu: ${user.password}';
      
      // Gọi SMTP Gmail Service
      await EmailService.sendEmail(
        recipient: email,
        subject: subject,
        body: body,
      );

      setState(() {
        _isLoading = false; // Tắt Loading sau khi gửi xong
      });

      // Hiển thị thông báo thành công (Icon fas fa-check-circle)
      _showFeedbackDialog(
        success: true,
        title: 'Thành công!',
        message: 'Thông tin tài khoản và mật khẩu đã được gửi về email của bạn. Vui lòng kiểm tra hòm thư.',
      );

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Hiển thị thông báo thất bại khi gặp lỗi hệ thống hoặc SMTP
      _showFeedbackDialog(
        success: false,
        title: 'Lỗi hệ thống!',
        message: 'Không thể gửi email. Lỗi: $e',
      );
    }
  }

  /// Hàm hiển thị Dialog thông báo kết quả (Thành công / Thất bại) với icon FontAwesome tương ứng
  void _showFeedbackDialog({
    required bool success,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppConstants.borderRadius,
          ),
          backgroundColor: AppConstants.itemColor,
          title: Row(
            children: [
              // Icon thông báo thành công (circleCheck) hoặc thất bại (circleExclamation)
              FaIcon(
                success ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circleExclamation,
                color: success ? AppConstants.successColor : AppConstants.errorColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: success ? AppConstants.successColor : AppConstants.errorColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: AppConstants.primaryTextColor,
              fontSize: 15,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng Dialog
                if (success) {
                  Navigator.of(context).pop(); // Quay lại màn hình Đăng nhập nếu thành công
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: AppConstants.borderRadius,
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor, // Nền xám nhạt #E5E5E5
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppConstants.iconColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. UTC2 LOGO ở trên cùng (Yêu cầu đề bài)
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(AppConstants.logoUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  // 2. TIÊU ĐỀ "Quên Mật Khẩu" (Yêu cầu đề bài)
                  const Text(
                    'Quên Mật Khẩu',
                    style: TextStyle(
                      color: AppConstants.iconColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. CARD chứa Form nhập liệu màu Trắng #FFFFFF bo tròn 12px (Yêu cầu đề bài)
                  Card(
                    color: AppConstants.itemColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppConstants.borderRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Hướng dẫn nhập email kèm icon fas fa-info-circle
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.circleInfo,
                                color: AppConstants.iconColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Nhập email đã đăng ký để nhận lại mật khẩu',
                                  style: TextStyle(
                                    color: AppConstants.secondaryTextColor,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // TextFormField Email kèm icon fas fa-envelope
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                            style: const TextStyle(color: AppConstants.primaryTextColor),
                            decoration: InputDecoration(
                              labelText: 'Email đã đăng ký',
                              labelStyle: const TextStyle(color: AppConstants.secondaryTextColor),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: AppConstants.iconColor,
                                  size: 18,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius,
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius,
                                borderSide: const BorderSide(color: AppConstants.buttonColor, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius,
                                borderSide: const BorderSide(color: AppConstants.errorColor),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius,
                                borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Button "Gửi Mật Khẩu" kèm icon fas fa-paper-plane màu #FF9228
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppConstants.buttonColor),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: _recoverPassword,
                                  icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 16, color: Colors.white),
                                  label: const Text(
                                    'Gửi Mật Khẩu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.buttonColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: AppConstants.borderRadius,
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. CARD bảo mật (Security tips) với icon fas fa-shield-alt (Yêu cầu đề bài)
                  Card(
                    color: AppConstants.itemColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppConstants.borderRadius,
                    ),
                    elevation: 1,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.shieldHalved,
                            color: AppConstants.iconColor,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Bảo mật: Vui lòng đổi mật khẩu sau khi nhận lại thông tin tài khoản thành công.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConstants.secondaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. Nút quay lại đăng nhập kèm icon fas fa-arrow-left (Yêu cầu đề bài)
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 14, color: AppConstants.iconColor),
                    label: const Text(
                      'Quay lại Đăng nhập',
                      style: TextStyle(
                        color: AppConstants.iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
