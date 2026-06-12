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
        child: Text(
          'Không có liên hệ nào.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Đẩy cuộn lên cho SingleChildScrollView
      itemCount: contacts.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: Color(0xFFE0E0E0),
      ),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              // Cột số thứ tự
              SizedBox(
                width: 40,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ),
              // Thông tin liên hệ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.number,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // Nút sửa và xóa để hỗ trợ CRUD đầy đủ cho thi cử
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
