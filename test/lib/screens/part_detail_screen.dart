import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_app_bar.dart';

class PartDetailScreen extends StatefulWidget {
  const PartDetailScreen({super.key});

  @override
  State<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends State<PartDetailScreen> {
  int _questionCount = 10;
  bool _kiemTra = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Mô Tả Hình Ảnh'),
      body: Stack(
        children: [
          // Decorative wave bg
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: CustomPaint(painter: _WavePainter()),
          ),
          ListView(
            padding: const EdgeInsets.only(bottom: 160),
            children: [
              // ── Stats ──────────────────────────────────────────
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
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.image_rounded,
                          size: 38, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatRow(label: 'Số câu đã làm', value: '0'),
                          const SizedBox(height: 4),
                          _StatRow(label: 'Trả lời đúng', value: '0'),
                          const SizedBox(height: 6),
                          Row(children: [
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
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Instruction card ───────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Câu hỏi',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'For each question, you will see a picture and you will hear four short statements. '
                      'The statements will be spoken just one time. They will not be printed in your test book '
                      'so you must listen carefully to understand what the speaker says. When you hear the four '
                      'statements, look at the picture and choose the statement that best describes what you see '
                      'in the picture. Choose the best answer A, B, C or D.',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 14, height: 1.6),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Bottom controls ────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('Số câu hỏi:',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      const SizedBox(width: 10),
                      // Count dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: DropdownButton<int>(
                          value: _questionCount,
                          isDense: true,
                          underline: const SizedBox(),
                          items: [5, 10, 15, 20, 25]
                              .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                              .toList(),
                          onChanged: (v) => setState(() => _questionCount = v!),
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 14),
                        ),
                      ),
                      const Spacer(),
                      const Text('Kiểm tra:',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      const SizedBox(width: 8),
                      Switch(
                        value: _kiemTra,
                        onChanged: (v) => setState(() => _kiemTra = v),
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/question'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 3,
                      ),
                      child: const Text('Bắt đầu nào',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

// ── Wave background painter ──────────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryLighter.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.2, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.6, size.width, size.height * 0.35);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = AppColors.primaryLighter.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
        size.width * 0.3, size.height * 0.45, size.width * 0.6, size.height * 0.65);
    path2.quadraticBezierTo(
        size.width * 0.8, size.height * 0.78, size.width, size.height * 0.55);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_) => false;
}
