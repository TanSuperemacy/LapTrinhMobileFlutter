import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/skill_card.dart';
import '../widgets/question_card.dart';
import '../widgets/answer_card.dart';
import '../widgets/section_header.dart';
import '../widgets/explanation_widget.dart';
import '../widgets/test_card.dart';

/// Màn hình preview để test tất cả widgets trước khi tích hợp vào dự án.
/// Dùng làm home route khi chạy app riêng để kiểm tra.
class WidgetPreviewScreen extends StatefulWidget {
  const WidgetPreviewScreen({super.key});

  @override
  State<WidgetPreviewScreen> createState() => _WidgetPreviewScreenState();
}

class _WidgetPreviewScreenState extends State<WidgetPreviewScreen> {
  String? _selectedAnswer;
  String? _submittedAnswer;

  static const _options = [
    AnswerOption(key: 'A', text: 'She will attend the meeting tomorrow.'),
    AnswerOption(key: 'B', text: 'She has already finished the report.'),
    AnswerOption(key: 'C', text: 'She is going to reschedule the call.'),
    AnswerOption(key: 'D', text: 'She does not know about the project.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DefaultTabController(
        length: 5,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.appBarBg,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                title: const Text('Widget Preview'),
                centerTitle: true,
              ),
              bottom: const TabBar(
                isScrollable: true,
                labelColor: AppColors.textOnPrimary,
                unselectedLabelColor: AppColors.appBarIconBg,
                indicatorColor: AppColors.textOnPrimary,
                tabs: [
                  Tab(text: 'AppBar'),
                  Tab(text: 'Skill Cards'),
                  Tab(text: 'Question'),
                  Tab(text: 'Explanation'),
                  Tab(text: 'Test Cards'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _AppBarTab(),
              _SkillCardsTab(),
              _QuestionTab(
                selectedAnswer: _selectedAnswer,
                submittedAnswer: _submittedAnswer,
                onSelect: (k) => setState(() {
                  _selectedAnswer = k;
                  _submittedAnswer = null;
                }),
                onSubmit: () => setState(() => _submittedAnswer = _selectedAnswer),
              ),
              _ExplanationTab(),
              _TestCardsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab 1: AppBar variants ───────────────────────────────────────────────────

class _AppBarTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionLabel('AppBar cơ bản'),
        _PreviewBox(
          child: CustomAppBar(title: 'Ôn luyện kỹ năng'),
        ),
        _SectionLabel('AppBar với nút Giải thích'),
        _PreviewBox(
          child: CustomAppBar(
            title: 'Nghe',
            actions: [
              AppBarTextAction(label: 'Giải thích', onTap: () {}),
            ],
          ),
        ),
        _SectionLabel('AppBar với icon action'),
        _PreviewBox(
          child: CustomAppBar(
            title: 'Thi thử',
            actions: [
              AppBarIconAction(icon: Icons.bookmark_border_rounded, onTap: () {}),
              AppBarIconAction(icon: Icons.more_vert_rounded, onTap: () {}),
            ],
          ),
        ),
        _SectionLabel('AppBar không có nút back'),
        _PreviewBox(
          child: CustomAppBar(title: 'Trang chủ', showBackButton: false),
        ),
      ],
    );
  }
}

// ── Tab 2: Skill cards ───────────────────────────────────────────────────────

class _SkillCardsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        _SectionLabel('Cards ôn luyện kỹ năng'),
        SkillCard(
          partNumber: 1,
          title: 'Photographs',
          subtitle: '6 câu hỏi',
          progress: 1.0,
          onTap: () {},
        ),
        SkillCard(
          partNumber: 2,
          title: 'Question & Response',
          subtitle: '25 câu hỏi',
          progress: 0.6,
          onTap: () {},
        ),
        SkillCard(
          partNumber: 3,
          title: 'Conversations',
          subtitle: '39 câu hỏi',
          progress: 0.0,
          onTap: () {},
        ),
        SkillCard(
          partNumber: 4,
          title: 'Short Talks',
          subtitle: '30 câu hỏi',
          onTap: () {},
        ),
        SkillCard(
          partNumber: 5,
          title: 'Incomplete Sentences',
          subtitle: '30 câu hỏi',
          isLocked: true,
        ),
      ],
    );
  }
}

// ── Tab 3: Question + Answer ─────────────────────────────────────────────────

class _QuestionTab extends StatelessWidget {
  const _QuestionTab({
    required this.selectedAnswer,
    required this.submittedAnswer,
    required this.onSelect,
    required this.onSubmit,
  });

  final String? selectedAnswer;
  final String? submittedAnswer;
  final ValueChanged<String> onSelect;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        SectionHeader(
          sectionTitle: 'Phần 2',
          sectionSubtitle: 'Question & Response',
          currentQuestion: 3,
          totalQuestions: 16,
        ),
        QuestionCard(
          questionNumber: 3,
          totalQuestions: 16,
          questionText:
              'What does the woman suggest doing about the upcoming project deadline?',
        ),
        AnswerCard(
          options: _QuestionTab._demoOptions,
          selectedKey: selectedAnswer,
          correctKey: submittedAnswer != null ? 'B' : null,
          onSelect: onSelect,
        ),
        if (selectedAnswer != null && submittedAnswer == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  static const _demoOptions = [
    AnswerOption(key: 'A', text: 'She will attend the meeting tomorrow.'),
    AnswerOption(key: 'B', text: 'She suggests asking for an extension.'),
    AnswerOption(key: 'C', text: 'She is going to reschedule the call.'),
    AnswerOption(key: 'D', text: 'She does not know about the deadline.'),
  ];
}

// ── Tab 4: Explanation ───────────────────────────────────────────────────────

class _ExplanationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionLabel('Explanation widget (inline)'),
        ExplanationWidget(
          correctKey: 'B',
          correctAnswerText: 'She suggests asking for an extension.',
          explanation:
              'Đáp án đúng là B. Trong đoạn hội thoại, người phụ nữ nói "Maybe we should ask the manager for more time", tức là cô ấy đề xuất xin gia hạn thêm thời gian. Đây là nghĩa của "asking for an extension".',
          transcript:
              'Man: Im worried about the project deadline. It is coming up really fast.\n'
              'Woman: I know. Maybe we should ask the manager for more time. We still have a lot to do.\n'
              'Man: That sounds like a good idea. I will send an email this afternoon.',
          translation:
              'Nam: Tôi lo lắng về deadline của dự án. Nó đến rất nhanh.\n'
              'Nữ: Tôi biết. Có lẽ chúng ta nên xin quản lý thêm thời gian. Chúng ta vẫn còn nhiều việc phải làm.\n'
              'Nam: Nghe hay đấy. Tôi sẽ gửi email vào chiều nay.',
        ),
        const SizedBox(height: 20),
        _SectionLabel('Mở bằng Bottom Sheet'),
        ElevatedButton.icon(
          onPressed: () => ExplanationSheet.show(
            context,
            widget: const ExplanationWidget(
              correctKey: 'C',
              correctAnswerText: 'The office supply store.',
              explanation: 'Câu trả lời đúng là C. Người đàn ông đề cập rằng ông ấy cần ghé qua cửa hàng văn phòng phẩm trước khi trở về.',
              transcript: 'Where is the man going after work?',
              translation: 'Người đàn ông đi đâu sau giờ làm?',
            ),
          ),
          icon: const Icon(Icons.open_in_new_rounded),
          label: const Text('Xem giải thích'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

// ── Tab 5: Test cards ────────────────────────────────────────────────────────

class _TestCardsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        _SectionLabel('Cards đề thi thử'),
        TestCard(
          testName: 'TOEIC ETS 2024 – Test 01',
          duration: '120 phút',
          questionCount: 200,
          status: TestStatus.completed,
          score: 850,
          tag: 'Hot',
          onTap: () {},
        ),
        TestCard(
          testName: 'TOEIC ETS 2024 – Test 02',
          duration: '120 phút',
          questionCount: 200,
          status: TestStatus.inProgress,
          tag: 'Mới',
          onTap: () {},
        ),
        TestCard(
          testName: 'TOEIC ETS 2023 – Test 05',
          duration: '120 phút',
          questionCount: 200,
          status: TestStatus.notStarted,
          onTap: () {},
        ),
        TestCard(
          testName: 'TOEIC ETS 2023 – Test 06',
          duration: '120 phút',
          questionCount: 200,
          status: TestStatus.completed,
          score: 445,
          onTap: () {},
        ),
      ],
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _PreviewBox extends StatelessWidget {
  const _PreviewBox({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
