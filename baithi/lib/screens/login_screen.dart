import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../services/database_service.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'webview_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final user = await DatabaseService.instance.loginUser(
        _emailController.text,
        _passwordController.text,
      );
      setState(() => _isLoading = false);

      if (user != null) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const WebviewScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email hoặc mật khẩu không chính xác!')),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(AppConstants.logoUrl, height: 100),
                const SizedBox(height: 16),
                const Text(
                  'Đăng Nhập',
                  style: TextStyle(color: AppConstants.iconColor, fontSize: 28, fontWeight: FontWeight.bold),
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
                            labelText: 'Email',
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
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.buttonColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: AppConstants.borderRadius),
                                  ),
                                  child: const Text('Đăng Nhập', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  ),
                  child: const Text('Quên mật khẩu?', style: TextStyle(color: AppConstants.iconColor)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  ),
                  child: const Text('Chưa có tài khoản? Đăng ký', style: TextStyle(color: AppConstants.iconColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
