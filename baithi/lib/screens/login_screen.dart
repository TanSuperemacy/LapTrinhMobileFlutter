import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../services/database_service.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'webview_screen.dart';

/// Màn hình Đăng Nhập (Câu 1 - 3.5 điểm)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key quản lý trạng thái của Form đăng nhập
  final _formKey = GlobalKey<FormState>();

  // Controller để nhận dữ liệu từ các ô nhập
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Trạng thái hiển thị mật khẩu (Ẩn / Hiện)
  bool _obscurePassword = true;
  
  // Trạng thái đang xác thực (Loading)
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Logic xử lý Đăng Nhập
  Future<void> _login() async {
    // 1. Kiểm tra tính hợp lệ của Form nhập liệu
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Bắt đầu Loading
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // 2. Xác thực tài khoản từ SQLite Database (Yêu cầu đề bài)
      final user = await DatabaseService.instance.loginUser(email, password);

      setState(() {
        _isLoading = false; // Tắt Loading
      });

      if (user != null) {
        // Đăng nhập THÀNH CÔNG: Chuyển hướng sang màn hình WebView UTC2 (Yêu cầu đề bài)
        _showSnackBar(
          message: 'Đăng nhập thành công! Chào mừng ${user.fullName}.',
          isSuccess: true,
        );
        
        // Chuyển hướng sang màn hình WebView hiển thị trang utc2.edu.vn
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const WebviewScreen()),
          );
        }
      } else {
        // Đăng nhập THẤT BẠI: Hiển thị thông báo lỗi bằng SnackBar (Yêu cầu đề bài)
        _showSnackBar(
          message: 'Email hoặc Mật khẩu không chính xác!',
          isSuccess: false,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar(
        message: 'Lỗi xác thực hệ thống: $e',
        isSuccess: false,
      );
    }
  }

  /// Hàm hiển thị SnackBar thông báo
  void _showSnackBar({required String message, required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            FaIcon(
              isSuccess ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circleExclamation,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? AppConstants.successColor : AppConstants.errorColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor, // Nền xám nhạt #E5E5E5
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. LOGO UTC2 ở trên cùng (Yêu cầu đề bài)
                  Container(
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(AppConstants.logoUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // 2. TIÊU ĐỀ "Đăng Nhập" căn giữa (Yêu cầu đề bài)
                  const Text(
                    'Đăng Nhập',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppConstants.iconColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 3. CARD chứa Form đăng nhập màu Trắng #FFFFFF bo góc 12px (Yêu cầu đề bài)
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
                          
                          // TextFormField cho Email với validation và icon fas fa-envelope
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                            style: const TextStyle(color: AppConstants.primaryTextColor),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: AppConstants.secondaryTextColor),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: AppConstants.iconColor,
                                  size: 18,
                                ),
                              ),
                              border: OutlineInputBorder(borderRadius: AppConstants.borderRadius),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius,
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius,
                                borderSide: const BorderSide(color: AppConstants.buttonColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // TextFormField cho Mật khẩu với: Icon lock, eye show/hide, validation length >= 6
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: AppValidators.validatePassword,
                            style: const TextStyle(color: AppConstants.primaryTextColor),
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              labelStyle: const TextStyle(color: AppConstants.secondaryTextColor),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: FaIcon(
                                  FontAwesomeIcons.lock,
                                  color: AppConstants.iconColor,
                                  size: 18,
                                ),
                              ),
                              // Nút con mắt ẩn hiện mật khẩu (fas fa-eye / fas fa-eye-slash)
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                  _obscurePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                  color: AppConstants.iconColor,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(borderRadius: AppConstants.borderRadius),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius,
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppConstants.borderRadius,
                                borderSide: const BorderSide(color: AppConstants.buttonColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Button "Đăng Nhập" với màu #FF9228 và icon fas fa-sign-in-alt
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppConstants.buttonColor),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: _login,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.rightToBracket,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Đăng Nhập',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.buttonColor, // #FF9228
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: AppConstants.borderRadius, // 12px
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. NAVIGATION LINKS (Yêu cầu đề bài)
                  
                  // Text button "Quên mật khẩu?" với icon fas fa-question-circle
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.circleQuestion,
                      size: 14,
                      color: AppConstants.iconColor,
                    ),
                    label: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: AppConstants.iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Text button "Chưa có tài khoản? Đăng ký" với icon fas fa-user-plus
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.userPlus,
                      size: 14,
                      color: AppConstants.iconColor,
                    ),
                    label: const Text(
                      'Chưa có tài khoản? Đăng ký',
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
