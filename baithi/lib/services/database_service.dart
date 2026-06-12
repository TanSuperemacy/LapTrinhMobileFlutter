import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

/// Lớp dịch vụ quản lý cơ sở dữ liệu SQLite trong ứng dụng.
/// Sử dụng mô hình Singleton để đảm bảo chỉ có duy nhất 1 kết nối database hoạt động.
class DatabaseService {
  // Đối tượng singleton duy nhất của DatabaseService
  static final DatabaseService instance = DatabaseService._init();

  // Đối tượng SQLite database thực tế
  static Database? _database;

  // Constructor ẩn để tránh khởi tạo tự do từ bên ngoài
  DatabaseService._init();

  /// Getter để lấy đối tượng database. Nếu chưa khởi tạo, nó sẽ gọi hàm tạo mới.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db'); // Tạo database tên students.db
    return _database!;
  }

  /// Khởi tạo đường dẫn lưu trữ và mở cơ sở dữ liệu
  Future<Database> _initDB(String filePath) async {
    // Lấy thư mục chứa database mặc định trên thiết bị Android/iOS
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Mở database với phiên bản (version) 1
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // Hàm callback được gọi lần đầu tiên khi tạo db
    );
  }

  /// Tạo cấu trúc bảng `users` theo mô tả chi tiết của đề thi
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,          -- Đảm bảo email duy nhất, không trùng lặp
        password TEXT NOT NULL,              -- Mật khẩu của tài khoản
        student_id TEXT NOT NULL,            -- Mã sinh viên (student_id)
        full_name TEXT NOT NULL,             -- Họ và tên (full_name)
        gender TEXT NOT NULL                 -- Giới tính (gender)
      )
    ''');
  }

  /// 1. Kiểm tra Email đã tồn tại trong database chưa (dùng cho đăng ký)
  /// Trả về true nếu đã tồn tại, false nếu chưa.
  Future<bool> emailExists(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    return maps.isNotEmpty;
  }

  /// 2. Đăng ký người dùng mới (Lưu thông tin user vào SQLite)
  /// Trả về ID tự tăng của bản ghi vừa lưu (int > 0) nếu thành công.
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    // sqflite tự động lấy các trường trong map ánh xạ vào cột tương ứng
    return await db.insert('users', user.toMap());
  }

  /// 3. Xác thực tài khoản Đăng Nhập
  /// Kiểm tra xem email và mật khẩu có trùng khớp với bản ghi nào không.
  /// Trả về đối tượng User nếu khớp, null nếu sai thông tin.
  Future<User?> loginUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  /// 4. Truy xuất thông tin người dùng theo Email (dùng cho Quên mật khẩu)
  /// Trả về đối tượng User nếu email tồn tại trong database, ngược lại trả về null.
  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  /// Đóng kết nối CSDL khi không sử dụng (nếu cần thiết)
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
