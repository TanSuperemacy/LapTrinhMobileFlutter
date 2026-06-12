import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/skill_card.dart';

class NgheHieuScreen extends StatelessWidget {
  const NgheHieuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Nghe Hiểu'),
      body: ListView(
        children: [
          // ── Stats header ───────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                // Headphone icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.headphones_rounded,
                      size: 40, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                const Expanded(child: _StatsColumn()),
              ],
            ),
          ),

          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 8),

          // ── Skill cards ────────────────────────────────────────
          SkillCard(
            partNumber: 1,
            title: 'Mô Tả Hình Ảnh',
            subtitle: 'Câu trả lời đúng  0/0',
            progress: 0.0,
            onTap: () => Navigator.pushNamed(context, '/part-detail'),
          ),
          SkillCard(
            partNumber: 2,
            title: 'Hỏi & Đáp',
            subtitle: 'Câu trả lời đúng  0/0',
            progress: 0.0,
            onTap: () {},
          ),
          SkillCard(
            partNumber: 3,
            title: 'Đoạn Hội Thoại',
            subtitle: 'Câu trả lời đúng  0/0',
            progress: 0.0,
            isLocked: true,
          ),
          SkillCard(
            partNumber: 4,
            title: 'Bài Nói Chuyện Ngắn',
            subtitle: 'Câu trả lời đúng  0/0',
            progress: 0.0,
            isLocked: true,
          ),
          SkillCard(
            partNumber: 5,
            title: 'Điền Vào Chỗ Trống',
            subtitle: 'Câu trả lời đúng  0/0',
            progress: 0.4,
            onTap: () {},
          ),
          SkillCard(
            partNumber: 6,
            title: 'Đọc Hiểu Đoạn Văn',
            subtitle: 'Câu trả lời đúng  0/0',
            progress: 0.7,
            onTap: () {},
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StatsColumn extends StatelessWidget {
  const _StatsColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatRow(label: 'Số câu đã làm', value: '0'),
        const SizedBox(height: 4),
        _StatRow(label: 'Trả lời đúng', value: '0'),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('Hoàn thành',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 13)),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.0,
                  backgroundColor: AppColors.primaryLighter,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 13)),
        const SizedBox(width: 8),
        Text(value,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }
}
