import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('AuDuongTan_Sqlite.db');
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

    // Chèn 6 dữ liệu mẫu theo đúng yêu cầu đề bài
    // Bản ghi thứ 4 phải là Tên sinh viên: "Âu Dương Tấn"
    List<Map<String, dynamic>> sampleContacts = [
      {
        'id': 1,
        'name': 'Nam',
        'number': '0987983793',
        'email': 'nam@gmail.com',
        'group_name': 'Bạn bè',
        'gender': 'Nam'
      },
      {
        'id': 2,
        'name': 'Hữu Thắng',
        'number': '0986774235',
        'email': 'thang@gmail.com',
        'group_name': 'Công việc',
        'gender': 'Nam'
      },
      {
        'id': 3,
        'name': 'Toan',
        'number': '0949739503',
        'email': 'toan@gmail.com',
        'group_name': 'Bạn bè',
        'gender': 'Nam'
      },
      {
        'id': 4,
        'name': 'Âu Dương Tấn', // Bản ghi thứ 4 là Tên sinh viên
        'number': '0987888773',
        'email': 'tan.auduong@student.edu.vn',
        'group_name': 'Gia đình',
        'gender': 'Nam'
      },
      {
        'id': 5,
        'name': 'Minh Hiếu',
        'number': '0964575786',
        'email': 'hieu@gmail.com',
        'group_name': 'Công việc',
        'gender': 'Nam'
      },
      {
        'id': 6,
        'name': 'Hoàng Anh',
        'number': '0987886445',
        'email': 'hoanganh@gmail.com',
        'group_name': 'Bạn bè',
        'gender': 'Nữ'
      },
    ];

    for (var contact in sampleContacts) {
      await db.insert('Contact_AuDuongTan', contact);
    }
  }

  // CRUD: Create (Thêm contact mới)
  Future<int> insertContact(Contact_AuDuongTan contact) async {
    final db = await instance.database;
    return await db.insert('Contact_AuDuongTan', contact.toMap());
  }

  // CRUD: Read (Lấy danh sách, sắp xếp tăng dần theo Tên)
  Future<List<Contact_AuDuongTan>> getAllContacts() async {
    final db = await instance.database;
    final result = await db.query('Contact_AuDuongTan', orderBy: 'name ASC');
    return result.map((json) => Contact_AuDuongTan.fromMap(json)).toList();
  }

  // CRUD: Update (Cập nhật contact)
  Future<int> updateContact(Contact_AuDuongTan contact) async {
    final db = await instance.database;
    return await db.update(
      'Contact_AuDuongTan',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // CRUD: Delete (Xóa contact)
  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete(
      'Contact_AuDuongTan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Tìm kiếm contact theo tên hoặc số điện thoại
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

  // Đóng database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
