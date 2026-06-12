import 'package:flutter/material.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  String _message = "Chưa bấm nút nào";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập: Các loại Button'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LÝ THUYẾT ---
            Card(
              color: Colors.indigo.shade100,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 4 loại Button cơ bản thường gặp trong đề thi:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• ElevatedButton: Nút lồi lên, có màu nền nổi bật (chính).\n'
                      '• OutlinedButton: Nút có đường viền xung quanh, nền trong suốt.\n'
                      '• TextButton: Nút chỉ có chữ, không nền, không viền (dùng cho link hoặc tùy chọn phụ).\n'
                      '• IconButton: Nút dạng icon hình ảnh tròn nhỏ.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- DEMO ---
            const Text(
              '🎮 Demo thực tế:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 1. ElevatedButton
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _message = "Đã bấm: ElevatedButton";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('ElevatedButton (Nút lồi)'),
                    ),
                    const SizedBox(height: 12),

                    // 2. OutlinedButton
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _message = "Đã bấm: OutlinedButton";
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.indigo),
                        foregroundColor: Colors.indigo,
                      ),
                      child: const Text('OutlinedButton (Nút viền)'),
                    ),
                    const SizedBox(height: 12),

                    // 3. TextButton
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _message = "Đã bấm: TextButton";
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.indigo,
                      ),
                      child: const Text('TextButton (Nút văn bản)'),
                    ),
                    const SizedBox(height: 12),

                    // 4. IconButton
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _message = "Đã bấm: IconButton (Icon Thích)";
                        });
                      },
                      icon: const Icon(Icons.thumb_up),
                      color: Colors.indigo,
                      tooltip: 'Like',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            // --- CODE CHAY ĐỂ HỌC ---
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
                '// 1. ElevatedButton\n'
                'ElevatedButton(\n'
                '  onPressed: () {}, \n'
                '  child: Text("Elevated"),\n'
                ')\n\n'
                '// 2. OutlinedButton\n'
                'OutlinedButton(\n'
                '  onPressed: () {}, \n'
                '  child: Text("Outlined"),\n'
                ')\n\n'
                '// 3. TextButton\n'
                'TextButton(\n'
                '  onPressed: () {}, \n'
                '  child: Text("Text Button"),\n'
                ')\n\n'
                '// 4. IconButton\n'
                'IconButton(\n'
                '  icon: Icon(Icons.add),\n'
                '  onPressed: () {},\n'
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
