# HƯỚNG DẪN ÔN THI CUỐI KỲ: FLUTTER + SQLITE & GỬI EMAIL (SMTP)

Tài liệu này được biên soạn chi tiết từng bước để giúp bạn ôn tập và hoàn thành xuất sắc bài thi thực hành lập trình di động (thời gian: 75 phút).

---

## 💡 So sánh nhanh: SQLite vs Firebase
Nếu bạn đã quen với Firebase (NoSQL, Realtime, Cloud), hãy chú ý các điểm khác biệt của SQLite:
- **SQLite là SQL Database**: Cần định nghĩa cấu trúc bảng (Schema), kiểu dữ liệu cột (`INTEGER`, `TEXT`,...).
- **Chạy offline hoàn toàn**: Lưu trữ trực tiếp dưới dạng một file `.db` trên bộ nhớ thiết bị.
- **Không tự động lắng nghe thay đổi**: Firebase cung cấp Stream để tự động update UI khi data đổi. Với SQLite, bạn cần tự truy vấn lại (`refreshData`) sau khi Thêm, Sửa hoặc Xóa (CRUD) để cập nhật UI.
- **Thao tác qua Map**: Khi chèn vào DB, ta đổi Object thành `Map<String, dynamic>`. Khi đọc từ DB, ta convert từ `Map` ngược lại thành Object.

---

## 🛠️ Bước 1: Thêm thư viện vào `pubspec.yaml`
Để làm việc với SQLite và gửi email, bạn cần các package sau:
1. `sqflite`: Thư viện chính để thao tác SQLite.
2. `path`: Giúp xử lý đường dẫn lưu file database trên thiết bị.
3. `mailer`: Thư viện gửi email qua giao thức SMTP.

Trong file `pubspec.yaml`, thêm các dòng sau dưới mục `dependencies`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  sqflite: ^2.4.2+1
  path: ^1.9.1
  mailer: ^7.1.0
```
*Lưu ý: Chúng ta đã thêm các thư viện này thành công vào dự án của bạn rồi.*

---

## 📝 Bước 2: Tạo lớp Model (`Contact_TenSV`)
> **Yêu cầu đề bài:** Tạo lớp `Contact_TenSV` với các fields, constructor, getter, setter.
> *Ví dụ ở đây sử dụng họ tên: **Âu Dương Tấn***

Tạo file: `lib/models/contact_model.dart`
```dart
class Contact_AuDuongTan {
  int? _id;
  late String _name;
  late String _number;
  String? _email;
  String? _groupName;
  String? _gender;

  // Constructor
  Contact_AuDuongTan({
    int? id,
    required String name,
    required String number,
    String? email,
    String? groupName,
    String? gender,
  }) {
    _id = id;
    _name = name;
    _number = number;
    _email = email;
    _groupName = groupName;
    _gender = gender;
  }

  // Getters (Lấy giá trị)
  int? get id => _id;
  String get name => _name;
  String get number => _number;
  String? get email => _email;
  String? get groupName => _groupName;
  String? get gender => _gender;

  // Setters (Gán giá trị)
  set id(int? value) => _id = value;
  set name(String value) => _name = value;
  set number(String value) => _number = value;
  set email(String? value) => _email = value;
  set groupName(String? value) => _groupName = value;
  set gender(String? value) => _gender = value;

  // Chuyển đối tượng thành Map để lưu vào SQLite (Serialization)
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': _name,
      'number': _number,
      'email': _email,
      'group_name': _groupName,
      'gender': _gender,
    };
    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  // Tạo đối tượng từ Map lấy từ SQLite (Deserialization)
  Contact_AuDuongTan.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _number = map['number'];
    _email = map['email'];
    _groupName = map['group_name'];
    _gender = map['gender'];
  }
}
```

---

## 🗄️ Bước 3: Tạo CSDL SQLite và Seed Data (`HoTenSV_Sqlite`)
> **Yêu cầu đề bài:** Tạo CSDL với tên là `HoTenSV_Sqlite`, tên bảng là `Contact_TenSV`, đồng thời nhập 6 dữ liệu mẫu trong đó bản ghi thứ 4 chứa Tên sinh viên.

Tạo file quản lý kết nối và thực hiện CRUD: `lib/database/db_helper.dart`
```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('AuDuongTan_Sqlite.db'); // Tên CSDL: HoTenSV_Sqlite
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Khởi tạo bảng và chèn 6 bản ghi mẫu ban đầu
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Contact_AuDuongTan (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        number TEXT NOT NULL,
        email TEXT,
        group_name TEXT,
        gender TEXT
      )
    ''');

    // Chèn 6 dữ liệu mẫu. Bản ghi thứ 4 PHẢI là Tên sinh viên
    List<Map<String, dynamic>> sampleContacts = [
      {'id': 1, 'name': 'Nam', 'number': '0987983793', 'email': 'nam@gmail.com', 'group_name': 'Bạn bè', 'gender': 'Nam'},
      {'id': 2, 'name': 'Hữu Thắng', 'number': '0986774235', 'email': 'thang@gmail.com', 'group_name': 'Công việc', 'gender': 'Nam'},
      {'id': 3, 'name': 'Toan', 'number': '0949739503', 'email': 'toan@gmail.com', 'group_name': 'Bạn bè', 'gender': 'Nam'},
      {'id': 4, 'name': 'Âu Dương Tấn', 'number': '0987888773', 'email': 'tan.auduong@student.edu.vn', 'group_name': 'Gia đình', 'gender': 'Nam'}, // Bản ghi thứ 4
      {'id': 5, 'name': 'Minh Hiếu', 'number': '0964575786', 'email': 'hieu@gmail.com', 'group_name': 'Công việc', 'gender': 'Nam'},
      {'id': 6, 'name': 'Hoàng Anh', 'number': '0987886445', 'email': 'hoanganh@gmail.com', 'group_name': 'Bạn bè', 'gender': 'Nữ'},
    ];

    for (var contact in sampleContacts) {
      await db.insert('Contact_AuDuongTan', contact);
    }
  }

  // --- CÁC THAO TÁC CRUD ---

  // 1. CREATE: Thêm mới liên hệ
  Future<int> insertContact(Contact_AuDuongTan contact) async {
    final db = await instance.database;
    return await db.insert('Contact_AuDuongTan', contact.toMap());
  }

  // 2. READ: Lấy toàn bộ và Sắp xếp tăng dần theo Tên
  Future<List<Contact_AuDuongTan>> getAllContacts() async {
    final db = await instance.database;
    // Sắp xếp tăng dần theo Tên (name ASC)
    final result = await db.query('Contact_AuDuongTan', orderBy: 'name ASC');
    return result.map((json) => Contact_AuDuongTan.fromMap(json)).toList();
  }

  // 3. UPDATE: Cập nhật liên hệ
  Future<int> updateContact(Contact_AuDuongTan contact) async {
    final db = await instance.database;
    return await db.update(
      'Contact_AuDuongTan',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // 4. DELETE: Xóa liên hệ
  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete(
      'Contact_AuDuongTan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. SEARCH: Tìm kiếm theo tên, số điện thoại hoặc email
  Future<List<Contact_AuDuongTan>> searchContacts(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'Contact_AuDuongTan',
      where: 'name LIKE ? OR number LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((json) => Contact_AuDuongTan.fromMap(json)).toList();
  }
}
```

---

## 🎨 Bước 4: Tạo Adapter hiển thị danh sách (`HoTenSV_Adapter`)
> **Yêu cầu đề bài:** Hiển thị danh sách các Contact dạng ListView/RecyclerView thông qua lớp adapter có tên là `HoTenSV_Adapter`.

Trong Flutter, ta tự viết một Widget kế thừa từ `StatelessWidget` làm nhiệm vụ vẽ các item danh sách. Cách này tương đương lớp Adapter trong Android Native.

Tạo file: `lib/widgets/contact_adapter.dart`
```dart
import 'package:flutter/material.dart';
import '../models/contact_model.dart';

class AuDuongTan_Adapter extends StatelessWidget {
  final List<Contact_AuDuongTan> contacts;
  final Function(Contact_AuDuongTan) onEdit;
  final Function(int) onDelete;

  const AuDuongTan_Adapter({
    super.key,
    required this.contacts,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Không tìm thấy liên hệ nào.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Để scroll mượt trong SingleChildScrollView của trang chủ
      itemCount: contacts.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE0E0E0)),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              // Cột hiển thị Số thứ tự (như hình mẫu)
              SizedBox(
                width: 40,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontSize: 26, color: Colors.black54),
                ),
              ),
              // Thông tin liên hệ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.number,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              // Các nút chỉnh sửa/xóa (hỗ trợ thao tác CRUD)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.indigo, size: 22),
                    onPressed: () => onEdit(contact),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                    onPressed: () => onDelete(contact.id!),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
```

---

## 🏠 Bước 5: Màn hình chính (`HomeScreen`)
Nhiệm vụ:
1. Hiện thanh tìm kiếm thời gian thực.
2. Nạp dữ liệu từ SQLite khi khởi chạy.
3. Sắp xếp tăng dần theo Tên.
4. Hiện FloatingActionButton "+" chuyển sang màn hình nhập thông tin.

Tạo file: `lib/screens/home_screen.dart`
```dart
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

  // Tải danh sách từ SQLite
  Future<void> _refreshContacts() async {
    setState(() {
      _isLoading = true;
    });

    final data = _searchController.text.isEmpty
        ? await DBHelper.instance.getAllContacts()
        : await DBHelper.instance.searchContacts(_searchController.text);

    // Sắp xếp tăng dần theo tên
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
        content: const Text('Bạn có muốn xóa liên hệ này khỏi CSDL?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('HỦY')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DBHelper.instance.deleteContact(id);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Xóa thành công!')),
              );
              _refreshContacts();
            },
            child: const Text('XÓA', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Chuyển sang màn hình thêm/sửa
  Future<void> _navigateToDetail([Contact_AuDuongTan? contact]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(contact: contact),
      ),
    );

    if (result == true) {
      _refreshContacts(); // Tải lại danh sách nếu có thay đổi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DBMan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFF2A56C6), // Màu xanh dương giống hình
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.email_outlined, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmailScreen()),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Thanh Tìm kiếm (Search) có viền dưới đổi màu hồng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => _refreshContacts(),
                decoration: const InputDecoration(
                  labelText: 'Search',
                  floatingLabelStyle: TextStyle(color: Colors.pinkAccent),
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
                ? const Center(child: CircularProgressIndicator())
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
        backgroundColor: Colors.pinkAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
```

---

## 📝 Màn hình nhập chi tiết (`DetailScreen`)
> **Yêu cầu đề bài:**
> - Thay dòng chữ "Information detail" bằng **Họ tên sinh viên** (ví dụ: "Âu Dương Tấn").
> - Nút **ADD**: Thêm liên hệ vào SQLite, hiển thị thông báo, đồng thời cập nhật lại ListView của màn hình chính.
> - Nút **BACK**: Đóng màn hình hiện tại (quay lại).
> - Ôn tập thêm: **DropdownButton**, **RadioButtons**, **Validate dữ liệu**, hiển thị ảnh từ mạng (**Image.network**).

Tạo file: `lib/screens/detail_screen.dart`
```dart
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/contact_model.dart';

class DetailScreen extends StatefulWidget {
  final Contact_AuDuongTan? contact;

  const DetailScreen({super.key, this.contact});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String _selectedGroup = 'Bạn bè';
  String _selectedGender = 'Nam';
  final List<String> _groups = ['Gia đình', 'Bạn bè', 'Công việc', 'Khác'];

  bool get _isEditMode => widget.contact != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final contact = widget.contact!;
      _idController.text = contact.id.toString();
      _nameController.text = contact.name;
      _numberController.text = contact.number;
      _emailController.text = contact.email ?? '';
      _selectedGroup = contact.groupName ?? 'Bạn bè';
      _selectedGender = contact.gender ?? 'Nam';
    }
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    final int enteredId = int.parse(_idController.text.trim());
    final String enteredName = _nameController.text.trim();
    final String enteredNumber = _numberController.text.trim();
    final String enteredEmail = _emailController.text.trim();

    final newContact = Contact_AuDuongTan(
      id: enteredId,
      name: enteredName,
      number: enteredNumber,
      email: enteredEmail.isEmpty ? null : enteredEmail,
      groupName: _selectedGroup,
      gender: _selectedGender,
    );

    if (_isEditMode) {
      await DBHelper.instance.updateContact(newContact);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công!')),
      );
    } else {
      // Validate trùng khóa chính ID
      final all = await DBHelper.instance.getAllContacts();
      final exists = all.any((element) => element.id == enteredId);
      if (exists) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Lỗi trùng ID'),
            content: Text('ID $enteredId đã tồn tại trong danh bạ.'),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ĐỒNG Ý'))],
          ),
        );
        return;
      }
      
      await DBHelper.instance.insertContact(newContact);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm thành công!')),
      );
    }

    if (!mounted) return;
    Navigator.pop(context, true); // Trở về và báo hiệu cần load lại danh sách
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DBMan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2A56C6),
        automaticallyImplyLeading: false, // Tắt nút Back mặc định để dùng nút BACK của giao diện
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Yêu cầu số 4: Dòng "Information detail" thay thế bằng họ tên sinh viên
              const Text(
                'Âu Dương Tấn',
                style: TextStyle(fontSize: 32, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Trường ID
              const Text('Id:', style: TextStyle(fontSize: 20, color: Colors.black54)),
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                enabled: !_isEditMode, // Chỉ nhập ID khi thêm mới, sửa thì khóa lại
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'ID không được để trống';
                  if (int.tryParse(val) == null) return 'ID phải là số nguyên';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Trường Name
              const Text('Name:', style: TextStyle(fontSize: 20, color: Colors.black54)),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent)),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Tên không được để trống' : null,
              ),
              const SizedBox(height: 15),

              // Trường Number (Số điện thoại)
              const Text('Number:', style: TextStyle(fontSize: 20, color: Colors.black54)),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Số điện thoại không được để trống';
                  if (!RegExp(r'^[0-9]{9,11}$').hasMatch(val.trim())) {
                    return 'SĐT phải gồm 9-11 chữ số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Trường Email
              const Text('Email:', style: TextStyle(fontSize: 20, color: Colors.black54)),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty) {
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(val.trim())) {
                      return 'Định dạng email sai';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // DropdownButton (Nhóm)
              const Text('Group:', style: TextStyle(fontSize: 20, color: Colors.black54)),
              DropdownButton<String>(
                value: _selectedGroup,
                isExpanded: true,
                items: _groups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) => setState(() => _selectedGroup = val!),
              ),
              const SizedBox(height: 15),

              // RadioButton (Giới tính)
              const Text('Gender:', style: TextStyle(fontSize: 20, color: Colors.black54)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Nam'),
                      value: 'Nam',
                      groupValue: _selectedGender,
                      onChanged: (val) => setState(() => _selectedGender = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Nữ'),
                      value: 'Nữ',
                      groupValue: _selectedGender,
                      onChanged: (val) => setState(() => _selectedGender = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Image.network preview avatar
              const Text('Avatar Preview:', style: TextStyle(fontSize: 20, color: Colors.black54)),
              const SizedBox(height: 10),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: Image.network(
                      _selectedGender == 'Nam'
                          ? 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'
                          : 'https://cdn-icons-png.flaticon.com/512/3135/3135768.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Hàng nút bấm ADD/UPDATE & BACK giống hệt thiết kế đề bài
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD3D3D3), // Nền nút xám nhạt
                        foregroundColor: Colors.black87,
                        shape: const RoundedRectangleBorder(), // Vuông vức không bo tròn
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(_isEditMode ? 'UPDATE' : 'ADD'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, false), // Đóng màn hình
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD3D3D3),
                        foregroundColor: Colors.black87,
                        shape: const RoundedRectangleBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text('BACK'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 📧 Bước 6: Ôn tập Gửi Email qua SMTP (`mailer`)
Để gửi email, Flutter sử dụng package `mailer` cùng máy chủ SMTP của Gmail.
1. Bạn cần một tài khoản Gmail người gửi.
2. Bạn phải **Bật Xác thực 2 bước** cho tài khoản Gmail đó.
3. Vào phần bảo mật Google Account để tạo **Mật khẩu ứng dụng (App Password)** gồm 16 ký tự. Hãy sử dụng mật khẩu này thay vì mật khẩu Gmail thông thường của bạn.

### Service gửi email:
Tạo file: `lib/services/email_service.dart`
```dart
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static Future<bool> sendGmail({
    required String senderEmail,
    required String appPassword,
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final smtpServer = gmail(senderEmail, appPassword);

    final message = Message()
      ..from = Address(senderEmail, 'Ứng dụng DBMan')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      await send(message, smtpServer);
      return true;
    } catch (e) {
      print('Lỗi gửi mail: $e');
      return false;
    }
  }
}
```

Màn hình điền nội dung mail được thiết kế sẵn tại file: `lib/screens/email_screen.dart`. Khi đi thi, nếu thầy cô yêu cầu viết chức năng gửi mail, bạn chỉ cần ném class này vào dự án và gọi nó là chạy!

---

## 🎓 Bí quyết & Mẹo đi thi trong 75 phút
1. **Kiểm tra kỹ tên tệp / thư mục**: Bài thi thường yêu cầu đặt tên dự án hoặc thư mục theo cấu trúc `HoTen_MaSV`. Trước khi bắt đầu, hãy đổi tên thích hợp.
2. **Khởi tạo dữ liệu mẫu đầu tiên**: Khi tạo bảng SQLite (`onCreate`), hãy chèn luôn dữ liệu mẫu (Seeding). Giúp bạn ngay lập tức có dữ liệu hiển thị lên ListView khi ứng dụng vừa chạy lên lần đầu, tiết kiệm thời gian test.
3. **Mẹo SQLite không update giao diện**: Hãy viết một hàm `_refreshContacts()` gọi `DBHelper.instance.getAllContacts()` và bọc kết quả bên trong `setState(() {})`. Gọi hàm này mỗi khi khởi tạo (`initState`), sau khi xóa liên hệ, hoặc nhận giá trị trả về `true` từ lệnh `Navigator.push` để tự động vẽ lại màn hình.
4. **Nhớ dùng `mounted`**: Khi sử dụng `BuildContext` (như `ScaffoldMessenger.of(context)` hoặc `Navigator.pop(context)`) sau từ khóa `await` (tức là sau khi chờ SQLite phản hồi), hãy luôn thêm điều kiện:
   `if (!mounted) return;`
   Điều này giúp code của bạn chuẩn chỉnh, sạch sẽ và không bao giờ bị báo cảnh báo hoặc crash ứng dụng.
