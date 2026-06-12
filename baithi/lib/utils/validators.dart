/// Lớp chứa các hàm kiểm tra dữ liệu đầu vào (Validation) cho các Form.
/// Giúp tách biệt logic kiểm tra dữ liệu ra khỏi giao diện để code ngắn gọn, dễ bảo trì.
class AppValidators {
  
  /// Kiểm tra định dạng Email bằng Regular Expression (Regex)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email không được để trống';
    }
    // Biểu thức chính quy kiểm tra cấu trúc email chuẩn
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không đúng định dạng (Ví dụ: sv@utc2.edu.vn)';
    }
    return null;
  }

  /// Kiểm tra mật khẩu (độ dài tối thiểu 6 ký tự) theo yêu cầu đề bài
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải chứa ít nhất 6 ký tự';
    }
    return null;
  }

  /// Kiểm tra Mã Sinh Viên (Không được để trống)
  static String? validateStudentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mã sinh viên không được để trống';
    }
    return null;
  }

  /// Kiểm tra Họ và Tên (Không được để trống)
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Họ và tên không được để trống';
    }
    return null;
  }
  
  /// Kiểm tra Giới Tính (Phải chọn giá trị hợp lệ)
  static String? validateGender(String? value) {
    if (value == null || value.isEmpty || value == 'Chọn giới tính') {
      return 'Vui lòng chọn giới tính';
    }
    return null;
  }
}
