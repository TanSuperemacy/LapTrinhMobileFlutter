import 'package:flutter/material.dart';

class TextFormFieldScreen extends StatefulWidget {
  const TextFormFieldScreen({super.key});

  @override
  State<TextFormFieldScreen> createState() => _TextFormFieldScreenState();
}

class _TextFormFieldScreenState extends State<TextFormFieldScreen> {
  // 1. Tạo GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // 2. Tạo Controller để lấy giá trị từ TextFormField
  final _nameController = TextEditingController();

  String _submittedName = "";

  @override
  void dispose() {
    // Luôn giải phóng controller khi không dùng nữa để tránh rò rỉ bộ nhớ
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập: TextFormField'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PHẦN 1: LÝ THUYẾT & CODE TỐI GIẢN ---
            const Card(
              color: Colors.tealAccent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Cú pháp tối giản cần nhớ để đi thi:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Khai báo key: final _formKey = GlobalKey<FormState>();\n'
                      '2. Bao bọc các TextFormField bằng widget Form(key: _formKey).\n'
                      '3. Kiểm tra hợp lệ: if (_formKey.currentState!.validate()) { ... }',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- PHẦN 2: DEMO CHẠY THỬ ---
            const Text(
              '🎮 Demo thực tế:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey, // Gán key cho Form
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController, // Gán controller
                        decoration: const InputDecoration(
                          labelText: 'Nhập họ và tên',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        // Hàm validator kiểm tra dữ liệu đầu vào
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng không để trống họ tên!';
                          }
                          if (value.trim().length < 3) {
                            return 'Họ tên phải từ 3 ký tự trở lên!';
                          }
                          return null; // Trả về null nghĩa là dữ liệu hợp lệ
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Gọi validate() để kích hoạt validator của tất cả TextFormField trong Form
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _submittedName = _nameController.text;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Form hợp lệ! Đang xử lý...')),
                            );
                          }
                        },
                        child: const Text('Gửi dữ liệu (Submit)'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_submittedName.isNotEmpty)
              Text(
                'Dữ liệu đã nhận: $_submittedName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            
            const SizedBox(height: 30),
            // --- PHẦN 3: CODE CHAY ĐỂ ÔN THI ---
            const Text(
              '📝 Mẫu code chay tối giản nhất:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: const Text(
                '// Khai báo trong State:\n'
                'final _key = GlobalKey<FormState>();\n\n'
                '// Trong build:\n'
                'Form(\n'
                '  key: _key,\n'
                '  child: Column(\n'
                '    children: [\n'
                '      TextFormField(\n'
                '        validator: (val) => val == null || val.isEmpty ? "Lỗi" : null,\n'
                '      ),\n'
                '      ElevatedButton(\n'
                '        onPressed: () {\n'
                '          if (_key.currentState!.validate()) {\n'
                '             // Thành công\n'
                '          }\n'
                '        },\n'
                '        child: Text("Submit"),\n'
                '      )\n'
                '    ],\n'
                '  ),\n'
                ')',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
