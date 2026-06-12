import 'package:flutter/material.dart';

class DropdownScreen extends StatefulWidget {
  const DropdownScreen({super.key});

  @override
  State<DropdownScreen> createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  // 1. Khai báo danh sách các tùy chọn
  final List<String> _cities = ['Hà Nội', 'Đà Nẵng', 'TP. Hồ Chí Minh', 'Cần Thơ'];

  // 2. Biến lưu trữ giá trị đang được chọn (phải nằm trong danh sách hoặc null)
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập: DropdownButton'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LÝ THUYẾT ---
            const Card(
              color: Colors.orangeAccent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Lưu ý cực kỳ quan trọng khi làm DropdownButton:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Giá trị của biến "value" (giá trị hiện tại) bắt buộc phải TRÙNG KHỚP hoàn toàn với thuộc tính "value" của một trong các DropdownMenuItem trong danh sách items.\n'
                      '• Nếu không trùng khớp, ứng dụng sẽ bị CRASH ngay lập tức kèm lỗi "assertion failed".\n'
                      '• Dùng hàm map() để biến đổi danh sách String sang danh sách DropdownMenuItem nhanh chóng.',
                      style: TextStyle(fontSize: 14),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Chọn thành phố của bạn:'),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      hint: const Text('Bấm vào để chọn'), // Hiện khi chưa chọn gì
                      value: _selectedCity, // Giá trị hiện tại
                      isExpanded: true, // Cho phép trải rộng hết chiều ngang
                      items: _cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city, // Giá trị tương ứng với item
                          child: Text(city), // Nội dung hiển thị
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Cập nhật lại state khi chọn item mới
                        setState(() {
                          _selectedCity = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedCity != null)
              Center(
                child: Text(
                  'Thành phố đã chọn: $_selectedCity',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
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
                '// Khai báo trong State:\n'
                'String? selectedVal;\n'
                'List<String> list = ["A", "B", "C"];\n\n'
                '// Trong build:\n'
                'DropdownButton<String>(\n'
                '  value: selectedVal,\n'
                '  hint: Text("Chọn..."),\n'
                '  items: list.map((val) => DropdownMenuItem(\n'
                '    value: val,\n'
                '    child: Text(val),\n'
                '  )).toList(),\n'
                '  onChanged: (newVal) {\n'
                '    setState(() {\n'
                '      selectedVal = newVal;\n'
                '    });\n'
                '  },\n'
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
