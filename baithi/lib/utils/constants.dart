import 'package:flutter/material.dart';

/// Lớp định nghĩa các hằng số giao diện (Màu sắc, kích thước, bo góc...) cho ứng dụng.
/// Tuân thủ chính xác theo bảng màu và style yêu cầu trong đề thi.
class AppConstants {
  // Màu sắc theo đề bài yêu cầu
  static const Color iconColor = Color(0xFF130160);         // Icon Color: #130160
  static const Color buttonColor = Color(0xFFFF9228);       // Button Color: #FF9228
  static const Color backgroundColor = Color(0xFFE5E5E5);   // Background Color: #E5E5E5
  static const Color itemColor = Color(0xFFFFFFFF);         // Item Color: #FFFFFF
  
  // Các màu bổ trợ để giao diện đẹp và chuyên nghiệp hơn
  static const Color primaryTextColor = Color(0xFF1F1D2B);  // Chữ chính (Đen đậm)
  static const Color secondaryTextColor = Color(0xFF524B6E); // Chữ phụ (Xanh tím xám)
  static const Color errorColor = Color(0xFFD32F2F);        // Màu lỗi (Đỏ)
  static const Color successColor = Color(0xFF388E3C);      // Màu thành công (Xanh lá)

  // Độ bo góc (Border Radius) theo yêu cầu đề bài
  static const double borderRadiusValue = 12.0;             // Border Radius: 12px
  static final BorderRadius borderRadius = BorderRadius.circular(borderRadiusValue);

  // Đường dẫn Logo trường UTC2 theo yêu cầu
  static const String logoUrl = 'https://utc2.edu.vn/images/030820230730_U09Tn.png';
}
