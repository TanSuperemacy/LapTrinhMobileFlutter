/// Lớp dữ liệu (Model) đại diện cho thông tin một Người Dùng (Sinh Viên).
/// Ánh xạ trực tiếp với bảng `users` trong cơ sở dữ liệu SQLite.
class User {
  final int? id;            // ID tự tăng trong database (có thể null khi chưa lưu)
  final String email;       // Email của sinh viên
  final String password;    // Mật khẩu tài khoản
  final String studentId;   // Mã sinh viên (student_id)
  final String fullName;    // Họ và tên sinh viên (full_name)
  final String gender;      // Giới tính (gender)

  // Hàm khởi tạo constructor
  User({
    this.id,
    required this.email,
    required this.password,
    required this.studentId,
    required this.fullName,
    required this.gender,
  });

  /// Chuyển đổi đối tượng User thành Map để lưu trữ vào SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'student_id': studentId,
      'full_name': fullName,
      'gender': gender,
    };
  }

  /// Khởi tạo đối tượng User từ Map truy vấn được từ SQLite.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
      studentId: map['student_id'] as String,
      fullName: map['full_name'] as String,
      gender: map['gender'] as String,
    );
  }
}
