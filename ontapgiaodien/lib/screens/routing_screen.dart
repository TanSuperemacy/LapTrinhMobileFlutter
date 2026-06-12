import 'package:flutter/material.dart';

class RoutingScreen extends StatelessWidget {
  const RoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập: Điều hướng (Route)'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LÝ THUYẾT ---
            const Card(
              color: Colors.pinkAccent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 2 cách điều hướng trang thường dùng trong đề thi:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Điều hướng động (Anonymous Route):\n'
                      '   • Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenB()));\n'
                      '2. Điều hướng qua tên (Named Route):\n'
                      '   • Phải cấu hình Map "routes" trong MaterialApp ở file main.dart.\n'
                      '   • Navigator.pushNamed(context, "/screen-b");\n'
                      '3. Quay lại trang cũ:\n'
                      '   • Navigator.pop(context);',
                      style: TextStyle(fontSize: 14, color: Colors.white),
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
                    const Text(
                      'Thử bấm nút bên dưới để chuyển sang màn hình B:',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                      onPressed: () {
                        // Demo điều hướng động (Anonymous Route)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScreenB(data: "Được truyền qua từ Trang chính"),
                          ),
                        );
                      },
                      child: const Text('Chuyển trang (Navigator.push)'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.pink, side: const BorderSide(color: Colors.pink)),
                      onPressed: () {
                        // Demo điều hướng qua tên (Named Route)
                        // Phải đảm bảo tên route đã được khai báo ở MaterialApp.
                        Navigator.pushNamed(context, '/text-form-field');
                      },
                      child: const Text('Đi tới Trang TextFormField (Named Route: "/text-form-field")'),
                    ),
                  ],
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
                '// 1. Chuyển sang màn hình mới:\n'
                'Navigator.push(\n'
                '  context,\n'
                '  MaterialPageRoute(builder: (context) => SecondScreen()),\n'
                ');\n\n'
                '// 2. Quay lại màn hình cũ:\n'
                'Navigator.pop(context);\n\n'
                '// 3. Chuyển bằng tên (Named Route):\n'
                'Navigator.pushNamed(context, "/second-screen");',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Màn hình phụ B để demo cách quay về
class ScreenB extends StatelessWidget {
  final String data;
  const ScreenB({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Màn hình B'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.airport_shuttle, size: 80, color: Colors.pink),
              const SizedBox(height: 20),
              const Text(
                'Chào mừng bạn đã đến Màn hình B!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Dữ liệu nhận từ Trang trước:\n"$data"',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Quay lại trang trước
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay lại trang chính (Navigator.pop)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
