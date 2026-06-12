import 'package:flutter/material.dart';

class RadioButtonScreen extends StatefulWidget {
  const RadioButtonScreen({super.key});

  @override
  State<RadioButtonScreen> createState() => _RadioButtonScreenState();
}

class _RadioButtonScreenState extends State<RadioButtonScreen> {
  // Biến dùng chung để lưu trạng thái của nhóm Radio
  String? _gender = "Nam";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập: RadioButton'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LÝ THUYẾT ---
            const Card(
              color: Colors.purpleAccent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Cơ chế hoạt động của Radio & RadioListTile:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• value: Giá trị của RIÊNG nút Radio đó.\n'
                      '• groupValue: Biến lưu giá trị ĐANG ĐƯỢC CHỌN của cả nhóm.\n'
                      '• Khi value == groupValue, nút Radio đó sẽ được tô màu (chọn).\n'
                      '• Nên dùng RadioListTile thay vì Radio vì nó có sẵn nhãn chữ bên cạnh, và cho phép bấm vào toàn bộ dòng để chọn thay vì chỉ bấm trúng vòng tròn nhỏ.',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- DEMO ---
            const Text(
              '🎮 Demo thực tế (dùng RadioListTile):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chọn giới tính của bạn:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Lựa chọn 1: Nam
                    RadioListTile<String>(
                      title: const Text('Nam'),
                      value: 'Nam',
                      groupValue: _gender,
                      activeColor: Colors.purple,
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),

                    // Lựa chọn 2: Nữ
                    RadioListTile<String>(
                      title: const Text('Nữ'),
                      value: 'Nữ',
                      groupValue: _gender,
                      activeColor: Colors.purple,
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),

                    // Lựa chọn 3: Khác
                    RadioListTile<String>(
                      title: const Text('Khác'),
                      value: 'Khác',
                      groupValue: _gender,
                      activeColor: Colors.purple,
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Giới tính đã chọn: $_gender',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
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
                'String? groupVal = "A";\n\n'
                '// Trong build (hai lựa chọn A và B):\n'
                'RadioListTile<String>(\n'
                '  title: Text("Lựa chọn A"),\n'
                '  value: "A",\n'
                '  groupValue: groupVal,\n'
                '  onChanged: (val) {\n'
                '    setState(() { groupVal = val; });\n'
                '  },\n'
                '),\n'
                'RadioListTile<String>(\n'
                '  title: Text("Lựa chọn B"),\n'
                '  value: "B",\n'
                '  groupValue: groupVal,\n'
                '  onChanged: (val) {\n'
                '    setState(() { groupVal = val; });\n'
                '  },\n'
                '),',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
