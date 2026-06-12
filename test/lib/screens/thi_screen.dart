import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_app_bar.dart';

class ThiScreen extends StatelessWidget {
  const ThiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Thi', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _TestSection(
            title: 'TOEIC Listening & Reading Fulltest',
            total: 50,
            tests: List.generate(8, (i) {
              final n = 10 - i;
              return _TestGridItem(
                label: 'Test $n ETS\n2023',
                isLocked: n <= 6,
                onTap: () => Navigator.pushNamed(context, '/fulltest-list'),
              );
            }),
          ),
          _TestSection(
            title: 'TOEIC Listening & Reading Minitest',
            total: 55,
            tests: List.generate(4, (i) {
              return _TestGridItem(
                label: 'Test ${i + 1}',
                isLocked: false,
                onTap: () {},
              );
            }),
          ),
          _TestSection(
            title: 'TOEIC Speaking & Writing',
            total: 20,
            tests: List.generate(4, (i) {
              return _TestGridItem(
                label: 'Test ${i + 1}',
                isLocked: i > 1,
                onTap: () {},
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

// ── Bottom nav (demo only) ───────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.timer_rounded), label: 'Thi'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.diamond_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: ''),
      ],
    );
  }
}

// ── Section ──────────────────────────────────────────────────────────────────

class _TestSection extends StatelessWidget {
  const _TestSection({
    required this.title,
    required this.total,
    required this.tests,
  });

  final String title;
  final int total;
  final List<Widget> tests;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$title | $total',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/fulltest-list'),
                child: const Text(
                  'Xem thêm',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: tests.length,
            itemBuilder: (_, i) => tests[i],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Grid item ────────────────────────────────────────────────────────────────

class _TestGridItem extends StatelessWidget {
  const _TestGridItem({
    required this.label,
    required this.isLocked,
    this.onTap,
  });

  final String label;
  final bool isLocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
                boxShadow: const [
                  BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.article_outlined,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                  if (isLocked)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.lock_rounded,
                          size: 16, color: AppColors.primary),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isLocked ? AppColors.textHint : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
