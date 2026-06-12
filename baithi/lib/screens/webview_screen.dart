import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';

/// Màn hình WebView dùng để tải và hiển thị trang web của UTC2 (https://utc2.edu.vn).
/// Được kích hoạt khi sinh viên đăng nhập thành công.
class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true; // Trạng thái tải trang
  double _progressValue = 0.0; // Tiến trình tải trang (0.0 -> 1.0)

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo WebViewController theo API mới của webview_flutter 4.x
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Cho phép chạy Javascript trên trang
      ..setBackgroundColor(AppConstants.itemColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          // Lắng nghe tiến trình load trang
          onProgress: (int progress) {
            setState(() {
              _progressValue = progress / 100.0;
            });
          },
          // Lắng nghe bắt đầu load trang
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          // Lắng nghe hoàn tất load trang
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Cho phép tất cả các đường dẫn chuyển hướng trong WebView
            return NavigationDecision.navigate;
          },
        ),
      )
      // Tải URL trang chủ UTC2 theo yêu cầu đề bài
      ..loadRequest(Uri.parse('https://utc2.edu.vn'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'UTC2 Website',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppConstants.iconColor, // Màu Icon chính làm màu nền AppBar
        elevation: 0,
        // Nút quay lại màn hình Đăng nhập (sử dụng icon FontAwesome Arrow Left)
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // Nút Refresh để tải lại trang
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Widget WebView hiển thị nội dung trang
          WebViewWidget(controller: _controller),
          
          // Thanh tiến trình tải trang (LinearProgressIndicator) hiển thị trên cùng khi đang tải
          if (_isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progressValue,
                color: AppConstants.buttonColor, // Màu cam nút bấm của đề bài
                backgroundColor: Colors.grey[300],
                minHeight: 4,
              ),
            ),
        ],
      ),
    );
  }
}
