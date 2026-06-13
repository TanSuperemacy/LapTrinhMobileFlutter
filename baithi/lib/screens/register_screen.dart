import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/email_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _selectedGender = 'Chọn giới tính';
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final studentId = _studentIdController.text.trim();
    final fullName = _fullNameController.text.trim();

    try {
      if (await DatabaseService.instance.emailExists(email)) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email này đã được sử dụng!')),
          );
        }
        return;
      }

      final newUser = User(
        email: email,
        password: password,
        studentId: studentId,
        fullName: fullName,
        gender: _selectedGender,
      );

      await DatabaseService.instance.registerUser(newUser);

      await EmailService.sendEmail(
        recipient: email,
        subject: 'Chào mừng thành viên mới - UTC2',
        body: 'Chào mừng $fullName đã đăng ký thành công tài khoản tại UTC2!',
      );

      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thành công! Đã gửi mail chào mừng.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi đăng ký: $e')),
        );
      }
    }
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
                Image.network(AppConstants.logoUrl, height: 80),
                const SizedBox(height: 12),
                const Text(
                  'Đăng Ký',
                  style: TextStyle(color: AppConstants.iconColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
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
                            labelText: 'Email sinh viên',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(FontAwesomeIcons.envelope, color: AppConstants.iconColor),
                            ),
                            border: OutlineInputBorder(borderRadius: AppConstants.borderRadius),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: AppValidators.validatePassword,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(FontAwesomeIcons.lock, color: AppConstants.iconColor),
                            ),
                            suffixIcon: IconButton(
                              icon: FaIcon(_obscurePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, color: AppConstants.iconColor),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(borderRadius: AppConstants.borderRadius),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _studentIdController,
                          validator: AppValidators.validateStudentId,
                          decoration: InputDecoration(
                            labelText: 'Mã sinh viên',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(FontAwesomeIcons.idCard, color: AppConstants.iconColor),
                            ),
                            border: OutlineInputBorder(borderRadius: AppConstants.borderRadius),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _fullNameController,
                          validator: AppValidators.validateFullName,
                          decoration: InputDecoration(
                            labelText: 'Họ và tên',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(FontAwesomeIcons.user, color: AppConstants.iconColor),
                            ),
                            border: OutlineInputBorder(borderRadius: AppConstants.borderRadius),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          validator: AppValidators.validateGender,
                          dropdownColor: AppConstants.itemColor,
                          decoration: InputDecoration(
                            labelText: 'Giới tính',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(FontAwesomeIcons.venusMars, color: AppConstants.iconColor),
                            ),
                            border: OutlineInputBorder(borderRadius: AppConstants.borderRadius),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Chọn giới tính', child: Text('Chọn giới tính')),
                            DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                            DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                            DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                          ],
                          onChanged: (val) => setState(() => _selectedGender = val!),
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.buttonColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: AppConstants.borderRadius),
                                  ),
                                  child: const Text('Đăng Ký', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Đã có tài khoản? Đăng nhập', style: TextStyle(color: AppConstants.iconColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
