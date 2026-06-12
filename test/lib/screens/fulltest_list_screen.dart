import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_app_bar.dart';

class FulltestListScreen extends StatelessWidget {
  const FulltestListScreen({super.key});

  static const _tests = [
    _TestData('Test 10 ETS 2023', '120 phút', 200, false),
    _TestData('Test 9 ETS 2023', '120 phút', 200, false),
    _TestData('Test 8 ETS 2023', '120 phút', 200, false),
    _TestData('Test 7 ETS 2023', '120 phút', 200, false),
    _TestData('Test 6 ETS 2023', '120 phút', 200, true),
    _TestData('Test 5 ETS 2023', '120 phút', 200, true),
    _TestData('Test 4 ETS 2023', '120 phút', 200, true),
    _TestData('Test 3 ETS 2023', '120 phút', 200, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'TOEIC Listening & Reading Fulltest',
        titleStyle: const TextStyle(
          color: AppColors.appBarFg,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _tests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = _tests[i];
          return _FulltestCard(data: t);
        },
      ),
    );
  }
}

class _TestData {
  const _TestData(this.name, this.duration, this.questionCount, this.isLocked);
  final String name;
  final String duration;
  final int questionCount;
  final bool isLocked;
}

class _FulltestCard extends StatelessWidget {
  const _FulltestCard({required this.data});
  final _TestData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              if (data.isLocked)
                const Icon(Icons.lock_rounded,
                    color: AppColors.primary, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Thời gian: ${data.duration}  |  Câu hỏi: ${data.questionCount}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 96,
            child: ElevatedButton(
              onPressed: data.isLocked ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    data.isLocked ? AppColors.textHint : AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                disabledBackgroundColor: const Color(0xFFBDBDBD),
                disabledForegroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: data.isLocked ? 0 : 2,
              ),
              child: const Text('Bắt đầu',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
