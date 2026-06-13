    class AppValidators {
      static String? validateEmail(String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email không được để trống';
        }
        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Email không đúng định dạng';
        }
        return null;
      }

      static String? validatePassword(String? value) {
        if (value == null || value.isEmpty) {
          return 'Mật khẩu không được để trống';
        }
        if (value.length < 6) {
          return 'Mật khẩu phải chứa ít nhất 6 ký tự';
        }
        return null;
      }

      static String? validateStudentId(String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Mã sinh viên không được để trống';
        }
        return null;
      }

      static String? validateFullName(String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Họ và tên không được để trống';
        }
        return null;
      }
      
      static String? validateGender(String? value) {
        if (value == null || value.isEmpty || value == 'Chọn giới tính') {
          return 'Vui lòng chọn giới tính';
        }
        return null;
      }
    }
