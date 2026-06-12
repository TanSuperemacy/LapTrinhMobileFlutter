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
  
  String _selectedGroup = 'Bạn bè'; // DropdownButton value
  String _selectedGender = 'Nam'; // Radio button value
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

  // Thực hiện lưu dữ liệu vào SQLite
  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
        const SnackBar(content: Text('Cập nhật liên hệ thành công!')),
      );
    } else {
      // Kiểm tra xem ID có trùng lặp không (vì chúng ta nhập thủ công)
      final all = await DBHelper.instance.getAllContacts();
      final exists = all.any((element) => element.id == enteredId);
      if (exists) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Lỗi trùng ID'),
            content: Text('ID $enteredId đã tồn tại. Vui lòng nhập ID khác!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
      await DBHelper.instance.insertContact(newContact);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm liên hệ mới thành công!')),
      );
    }

    if (!mounted) return;
    Navigator.pop(context, true); // Trở về và cập nhật lại danh sách
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DBMan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF2A56C6),
        elevation: 0,
        automaticallyImplyLeading: false, // Không hiện nút back của hệ thống
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề trang được thay thế bằng họ tên SV: Âu Dương Tấn
              const Text(
                'Âu Dương Tấn',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // 1. Trường Id (Dạng số nguyên, bắt buộc nhập)
              const Text(
                'Id:',
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                enabled: !_isEditMode, // Không cho sửa ID nếu đang Edit
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập Id';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Id phải là số nguyên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 2. Trường Name (Dạng chuỗi, bắt buộc nhập)
              const Text(
                'Name:',
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. Trường Number (Số điện thoại, dạng chuỗi số, bắt buộc nhập)
              const Text(
                'Number:',
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  // Định dạng số điện thoại đơn giản (chỉ chứa chữ số và độ dài 9-11 ký tự)
                  final phoneRegex = RegExp(r'^[0-9]{9,11}$');
                  if (!phoneRegex.hasMatch(value.trim())) {
                    return 'Số điện thoại phải từ 9 đến 11 chữ số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 4. Trường Email (Dùng để ôn tập tính năng gửi email, có validate đúng định dạng)
              const Text(
                'Email (tùy chọn):',
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Email không đúng định dạng';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 5. Ôn tập DropdownButton (Nhóm liên hệ)
              const Text(
                'Group:',
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),
              DropdownButton<String>(
                value: _selectedGroup,
                isExpanded: true,
                style: const TextStyle(fontSize: 20, color: Colors.black87),
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                items: _groups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGroup = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // 6. Ôn tập RadioButton (Giới tính)
              const Text(
                'Gender:',
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Nam'),
                      value: 'Nam',
                      groupValue: _selectedGender,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Nữ'),
                      value: 'Nữ',
                      groupValue: _selectedGender,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 7. Ôn tập hiển thị Hình ảnh (Image.network và Image.asset)
              const Text(
                'Avatar Preview:',
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child: _selectedGender == 'Nam'
                        ? Image.network(
                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 60, color: Colors.grey);
                            },
                          )
                        : Image.network(
                            'https://cdn-icons-png.flaticon.com/512/3135/3135768.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person_outline, size: 60, color: Colors.grey);
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Hàng chứa nút bấm ADD/UPDATE và BACK giống trong hình
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD3D3D3), // Nền xám nhạt như hình
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _isEditMode ? 'UPDATE' : 'ADD',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD3D3D3), // Nền xám nhạt như hình
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'BACK',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
