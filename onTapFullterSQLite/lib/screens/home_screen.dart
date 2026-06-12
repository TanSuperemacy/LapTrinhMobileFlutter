import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/contact_model.dart';
import '../widgets/contact_adapter.dart';
import 'detail_screen.dart';
import 'email_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact_AuDuongTan> _contacts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshContacts();
  }

  // Tải lại danh sách từ SQLite
  Future<void> _refreshContacts() async {
    setState(() {
      _isLoading = true;
    });

    final data = _searchController.text.isEmpty
        ? await DBHelper.instance.getAllContacts()
        : await DBHelper.instance.searchContacts(_searchController.text);

    // Đảm bảo sắp xếp tăng dần theo Tên
    data.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    setState(() {
      _contacts = data;
      _isLoading = false;
    });
  }

  // Xóa liên hệ
  Future<void> _deleteContact(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa liên hệ này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('HỦY'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DBHelper.instance.deleteContact(id);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa liên hệ thành công!')),
              );
              _refreshContacts();
            },
            child: const Text('XÓA', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Chuyển sang màn hình thêm/sửa liên hệ
  Future<void> _navigateToDetail([Contact_AuDuongTan? contact]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(contact: contact),
      ),
    );

    if (result == true) {
      _refreshContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DBMan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF2A56C6), // Màu xanh dương đậm như hình
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.email_outlined, color: Colors.white),
            tooltip: 'Gửi Email',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmailScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ô tìm kiếm với viền dưới màu hồng khi focus như hình mẫu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => _refreshContacts(),
                decoration: const InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.grey),
                  floatingLabelStyle: TextStyle(color: Colors.redAccent),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : AuDuongTan_Adapter(
                    contacts: _contacts,
                    onEdit: _navigateToDetail,
                    onDelete: _deleteContact,
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(),
        backgroundColor: Colors.pink, // Nút tròn hồng như hình mẫu
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
