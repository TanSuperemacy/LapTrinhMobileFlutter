import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_app_bar.dart';

/// Screen preview đơn cho CustomAppBar widget.
/// Hiển thị các biến thể của AppBar: cơ bản, với text action, icon action, không back.
class AppBarScreen extends StatelessWidget {
  const AppBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header điều hướng
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.appBarBg,
            foregroundColor: AppColors.appBarFg,
            flexibleSpace: Container(
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: const Text(
              'Preview: CustomAppBar',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Variant 1: AppBar cơ bản ────────────────────────
                _VariantLabel(
                  index: 1,
                  title: 'AppBar cơ bản',
                  description: 'Hiển thị tiêu đề và nút back mặc định.',
                ),
                _PreviewCard(
                  child: CustomAppBar(title: 'Ôn luyện kỹ năng'),
                ),

                const SizedBox(height: 8),

                // ── Variant 2: AppBar với Text Action ───────────────
                _VariantLabel(
                  index: 2,
                  title: 'AppBar + Text Action (Giải thích)',
                  description: 'Dùng AppBarTextAction ở bên phải.',
                ),
                _PreviewCard(
                  child: CustomAppBar(
                    title: 'Nghe',
                    actions: [
                      AppBarTextAction(label: 'Giải thích', onTap: () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Variant 3: AppBar với Icon Actions ──────────────
                _VariantLabel(
                  index: 3,
                  title: 'AppBar + Icon Actions',
                  description: 'Dùng AppBarIconAction với nhiều icon.',
                ),
                _PreviewCard(
                  child: CustomAppBar(
                    title: 'Thi thử',
                    actions: [
                      AppBarIconAction(
                        icon: Icons.bookmark_border_rounded,
                        onTap: () {},
                        tooltip: 'Lưu',
                      ),
                      AppBarIconAction(
                        icon: Icons.more_vert_rounded,
                        onTap: () {},
                        tooltip: 'Thêm',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Variant 4: AppBar không có nút Back ─────────────
                _VariantLabel(
                  index: 4,
                  title: 'AppBar không có nút Back',
                  description: 'showBackButton: false – dùng cho trang chủ.',
                ),
                _PreviewCard(
                  child: CustomAppBar(
                    title: 'Trang chủ',
                    showBackButton: false,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Variant 5: AppBar + Text & Icon Actions ──────────
                _VariantLabel(
                  index: 5,
                  title: 'AppBar + Text & Icon Actions kết hợp',
                  description: 'Kết hợp cả AppBarTextAction và AppBarIconAction.',
                ),
                _PreviewCard(
                  child: CustomAppBar(
                    title: 'Đọc hiểu',
                    actions: [
                      AppBarTextAction(label: 'Giải thích', onTap: () {}),
                      AppBarIconAction(
                        icon: Icons.flag_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Ghi chú sử dụng ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryLighter, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.code_rounded, color: AppColors.primary, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Cách dùng',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'CustomAppBar(title: \'Tiêu đề\')\n\n'
                          '// Với text action:\nCustomAppBar(\n'
                          '  title: \'Nghe\',\n'
                          '  actions: [AppBarTextAction(label: \'Giải thích\', onTap: () {})],\n'
                          ')\n\n'
                          '// Với icon action:\nCustomAppBar(\n'
                          '  title: \'Thi thử\',\n'
                          '  actions: [AppBarIconAction(icon: Icons.bookmark_border_rounded, onTap: () {})],\n'
                          ')',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontFamily: 'monospace',
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────────────────────

class _VariantLabel extends StatelessWidget {
  const _VariantLabel({
    required this.index,
    required this.title,
    required this.description,
  });

  final int index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1.5),
        color: AppColors.surface,
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
