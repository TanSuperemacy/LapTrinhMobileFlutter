import 'package:flutter/material.dart';
import 'package:ontapgiaodien/screens/text_form_field_screen.dart';
import 'package:ontapgiaodien/screens/buttons_screen.dart';
import 'package:ontapgiaodien/screens/dropdown_screen.dart';
import 'package:ontapgiaodien/screens/radio_button_screen.dart';
import 'package:ontapgiaodien/screens/image_network_screen.dart';
import 'package:ontapgiaodien/screens/image_asset_screen.dart';
import 'package:ontapgiaodien/screens/image_file_screen.dart';
import 'package:ontapgiaodien/screens/routing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ôn Tập Flutter UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // CẤU HÌNH ROUTING (ĐIỀU HƯỚNG BẰNG TÊN - NAMED ROUTES)
      // Đây là phần rất hay thi lý thuyết/thực hành, học sinh cần nhớ cấu trúc khai báo này.
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/text-form-field': (context) => const TextFormFieldScreen(),
        '/buttons': (context) => const ButtonsScreen(),
        '/dropdown': (context) => const DropdownScreen(),
        '/radio': (context) => const RadioButtonScreen(),
        '/image-network': (context) => const ImageNetworkScreen(),
        '/image-asset': (context) => const ImageAssetScreen(),
        '/image-file': (context) => const ImageFileScreen(),
        '/routing': (context) => const RoutingScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Định nghĩa danh sách các chủ đề để sinh giao diện động
    final List<Map<String, dynamic>> topics = [
      {
        'title': '1. TextFormField',
        'subtitle': 'Form, Validation, Controller',
        'route': '/text-form-field',
        'icon': Icons.edit_note,
        'color': Colors.teal,
      },
      {
        'title': '2. Buttons (Các loại nút)',
        'subtitle': 'ElevatedButton, TextButton, OutlinedButton...',
        'route': '/buttons',
        'icon': Icons.smart_button,
        'color': Colors.indigo,
      },
      {
        'title': '3. DropdownButton',
        'subtitle': 'Lựa chọn giá trị từ danh sách xổ xuống',
        'route': '/dropdown',
        'icon': Icons.arrow_drop_down_circle,
        'color': Colors.orange,
      },
      {
        'title': '4. RadioButtonFormField',
        'subtitle': 'Chọn một lựa chọn duy nhất (RadioListTile)',
        'route': '/radio',
        'icon': Icons.radio_button_checked,
        'color': Colors.purple,
      },
      {
        'title': '5. Image.network',
        'subtitle': 'Tải ảnh từ link Internet & xử lý lỗi',
        'route': '/image-network',
        'icon': Icons.cloud_download,
        'color': Colors.blue,
      },
      {
        'title': '6. Image.asset',
        'subtitle': 'Tải ảnh cục bộ từ thư mục của dự án',
        'route': '/image-asset',
        'icon': Icons.image,
        'color': Colors.teal[700],
      },
      {
        'title': '7. Image.file',
        'subtitle': 'Tải ảnh từ tệp tin cục bộ trong thiết bị',
        'route': '/image-file',
        'icon': Icons.file_present,
        'color': Colors.cyan,
      },
      {
        'title': '8. Navigation & Routes',
        'subtitle': 'Navigator.push, Navigator.pop, Named Routes',
        'route': '/routing',
        'icon': Icons.directions,
        'color': Colors.pink,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎓 Ôn Tập Flutter UI - Đi Thi'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner chào mừng và giới thiệu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.tealAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.school, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'HỌC & ÔN TẬP CODE CHAY WIDGETS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Bấm vào từng chủ đề dưới đây để học cú pháp tối giản và trải nghiệm demo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Phần lý thuyết cách khai báo Route
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Card(
                elevation: 3,
                color: Colors.yellow[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.amber, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            '💡 Cách đăng ký Route trong main.dart:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber.shade900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'MaterialApp(\n'
                        '  initialRoute: \'/\',\n'
                        '  routes: {\n'
                        '    \'/\': (context) => HomeScreen(),\n'
                        '    \'/route-name\': (context) => OtherScreen(),\n'
                        '  },\n'
                        ')',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Danh sách các nút điều hướng đến từng chủ đề ôn thi
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      // Sử dụng Named Route để điều hướng đến bài tương ứng
                      Navigator.pushNamed(context, topic['route']);
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: topic['color'],
                          foregroundColor: Colors.white,
                          child: Icon(topic['icon']),
                        ),
                        title: Text(
                          topic['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(topic['subtitle']),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
