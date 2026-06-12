import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'thi_screen.dart';
import 'fulltest_list_screen.dart';
import 'listening_screen.dart';
import 'listening_part_detail_screen.dart';
import 'listening_practice_screen.dart';
import '../data/listening_data.dart';

/// Màn hình tổng – chứa các entry point để test từng flow.
class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.appBarBg,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOEIC Master',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900)),
                        SizedBox(height: 4),
                        Text('Widget Preview Hub',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Widget Preview Hub',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              collapseMode: CollapseMode.none,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryLighter),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app_rounded,
                        color: AppColors.primary, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bấm vào từng screen để xem preview, nhấn ← để quay lại',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Listening flow ────────────────────────────
                _GroupLabel('Phần Nghe Hiểu'),
                _ScreenCard(
                  icon: Icons.headphones_rounded,
                  title: 'Danh sách 4 Part',
                  subtitle: 'Screen chọn Part ôn luyện',
                  color: AppColors.primary,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const ListeningScreen())),
                ),
                ...ListeningData.parts.map((part) => _ScreenCard(
                      icon: part.icon,
                      title: 'Part ${part.partNumber} – ${part.titleVi}',
                      subtitle: 'Chuẩn bị làm bài',
                      color: AppColors.primary,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ListeningPartDetailScreen(part: part),
                        ),
                      ),
                    )),
                ...ListeningData.parts.map((part) => _ScreenCard(
                      icon: Icons.play_circle_rounded,
                      title: 'Làm bài Part ${part.partNumber}',
                      subtitle: 'Màn hình luyện tập Part ${part.partNumber}',
                      color: const Color(0xFFAB47BC),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ListeningPracticeScreen(
                              part: part, questionCount: 5),
                        ),
                      ),
                    )),

                // ── Thi ──────────────────────────────────────
                _GroupLabel('Phần Thi'),
                _ScreenCard(
                  icon: Icons.timer_rounded,
                  title: 'Thi – Grid đề',
                  subtitle: 'Fulltest / Minitest grid',
                  color: const Color(0xFF42A5F5),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ThiScreen())),
                ),
                _ScreenCard(
                  icon: Icons.article_rounded,
                  title: 'Danh Sách Fulltest',
                  subtitle: 'List bài test dạng card',
                  color: const Color(0xFFEF5350),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FulltestListScreen())),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ScreenCard extends StatelessWidget {
  const _ScreenCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: color, size: 14),
          ],
        ),
      ),
    );
  }
}
