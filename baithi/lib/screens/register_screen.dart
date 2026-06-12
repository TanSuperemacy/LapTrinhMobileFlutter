import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/email_service.dart';

/// Màn hình Đăng Ký (Câu 2 - 3.5 điểm)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Key quản lý trạng thái Form đăng ký
  final _formKey = GlobalKey<FormState>();

  // Các controller nhận dữ liệu từ các ô nhập
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  
  // Biến lưu giới tính được chọn (Mặc định hiển thị dòng hướng dẫn)
  String _selectedGender = 'Chọn giới tính';
  
  // Trạng thái hiển thị mật khẩu (Ẩn / Hiện)
  bool _obscurePassword = true;
  
  // Trạng thái hiển thị vòng tròn tải (Loading Indicator) khi gửi email
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _studentIdController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  /// Hàm xử lý logic Đăng Ký Sinh Viên
  Future<void> _register() async {
    // 1. Kiểm tra tính hợp lệ của Form nhập liệu phía Client
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Bật Loading
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final studentId = _studentIdController.text.trim();
    final fullName = _fullNameController.text.trim();
    final gender = _selectedGender;

    try {
      // 2. Kiểm tra email đã tồn tại trong SQLite chưa (Yêu cầu đề bài)
      final isEmailTaken = await DatabaseService.instance.emailExists(email);

      if (isEmailTaken) {
        setState(() {
          _isLoading = false;
        });
        // Hiển thị thông báo email trùng bằng SnackBar
        _showSnackBar(
          message: 'Email này đã được sử dụng. Vui lòng chọn email khác!',
          isSuccess: false,
        );
        return;
      }

      // 3. Khởi tạo đối tượng User mới
      final newUser = User(
        email: email,
        password: password,
        studentId: studentId,
        fullName: fullName,
        gender: gender,
      );

      // 4. Lưu thông tin User vào SQLite (Yêu cầu đề bài)
      await DatabaseService.instance.registerUser(newUser);

      // 5. Gửi email chào mừng sử dụng SMTP (Yêu cầu đề bài)
      // Nội dung: "Chào mừng [Họ tên] đã đăng ký tài khoản tại UTC2!"
      final subject = 'Chào mừng thành viên mới - UTC2';
      final body = 'Chào mừng $fullName đã đăng ký tài khoản tại UTC2!';
      
      await EmailService.sendEmail(
        recipient: email,
        subject: subject,
        body: body,
      );

      setState(() {
        _isLoading = false; // Tắt Loading
      });

      // 6. Hiển thị thông báo thành công và chuyển về màn hình đăng nhập
      _showSnackBar(
        message: 'Đăng ký thành công! Vui lòng kiểm tra email chào mừng.',
        isSuccess: true,
      );
      
      // Chờ một chút để SnackBar kịp hiển thị rồi pop quay lại login
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Hiển thị thông báo lỗi nếu có sự cố
      _showSnackBar(
        message: 'Đăng ký thất bại. Lỗi: $e',
        isSuccess: false,
      );
    }
  }

  /// Hàm hiển thị SnackBar thông báo nhanh cho sinh viên
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. LOGO UTC2 ở trên cùng (Yêu cầu đề bài)
                  Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(AppConstants.logoUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // 2. TIÊU ĐỀ "Đăng Ký" (Yêu cầu đề bài)
                  const Text(
                    'Đăng Ký',
                    style: TextStyle(
                      color: AppConstants.iconColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. CARD chứa Form đăng ký màu Trắng #FFFFFF bo góc 12px (Yêu cầu đề bài)
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
                          
                          // TextFormField cho Email (icon: fas fa-envelope)
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                            style: const TextStyle(color: AppConstants.primaryTextColor),
                            decoration: InputDecoration(
                              labelText: 'Email sinh viên',
                              labelStyle: const TextStyle(color: AppConstants.secondaryTextColor),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: AppConstants.iconColor,
                                  size: 16,
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

                          // TextFormField cho Mật khẩu (show/hide password, icon: fas fa-lock, fas fa-eye/fas fa-eye-slash)
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
                                  size: 16,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                  _obscurePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                  color: AppConstants.iconColor,
                                  size: 16,
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
                          const SizedBox(height: 16),

                          // TextFormField cho Mã sinh viên (icon: fas fa-id-card)
                          TextFormField(
                            controller: _studentIdController,
                            validator: AppValidators.validateStudentId,
                            style: const TextStyle(color: AppConstants.primaryTextColor),
                            decoration: InputDecoration(
                              labelText: 'Mã sinh viên',
                              labelStyle: const TextStyle(color: AppConstants.secondaryTextColor),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: FaIcon(
                                  FontAwesomeIcons.idCard,
                                  color: AppConstants.iconColor,
                                  size: 16,
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

                          // TextFormField cho Họ và tên (icon: fas fa-user)
                          TextFormField(
                            controller: _fullNameController,
                            validator: AppValidators.validateFullName,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(color: AppConstants.primaryTextColor),
                            decoration: InputDecoration(
                              labelText: 'Họ và tên',
                              labelStyle: const TextStyle(color: AppConstants.secondaryTextColor),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: FaIcon(
                                  FontAwesomeIcons.user,
                                  color: AppConstants.iconColor,
                                  size: 16,
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

                          // DropdownButton cho Giới tính Nam/Nữ/Khác (icon: fas fa-venus-mars)
                          DropdownButtonFormField<String>(
                            initialValue: _selectedGender,
                            validator: AppValidators.validateGender,
                            style: const TextStyle(color: AppConstants.primaryTextColor, fontSize: 16),
                            dropdownColor: AppConstants.itemColor,
                            decoration: InputDecoration(
                              labelText: 'Giới tính',
                              labelStyle: const TextStyle(color: AppConstants.secondaryTextColor),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: FaIcon(
                                  FontAwesomeIcons.venusMars,
                                  color: AppConstants.iconColor,
                                  size: 16,
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
                            items: const [
                              DropdownMenuItem(value: 'Chọn giới tính', child: Text('Chọn giới tính')),
                              DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                              DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                              DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                            ],
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 24),

                          // Button "Đăng Ký" kèm icon fas fa-user-plus màu #FF9228
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppConstants.buttonColor),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: _register,
                                  icon: const FaIcon(FontAwesomeIcons.userPlus, size: 16, color: Colors.white),
                                  label: const Text(
                                    'Đăng Ký',
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

                  // 4. Nút chuyển hướng sang màn hình Đăng nhập kèm icon fas fa-sign-in-alt
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const FaIcon(FontAwesomeIcons.rightToBracket, size: 14, color: AppConstants.iconColor),
                    label: const Text(
                      'Đã có tài khoản? Đăng nhập',
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
