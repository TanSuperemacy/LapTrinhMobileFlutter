import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/answer_card.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String? _selected;
  String? _submitted;
  bool _showExplanation = false;
  int _currentQuestion = 1;
  final int _totalQuestions = 10;

  // Fake audio state
  double _audioProgress = 0.08;
  bool _isPlaying = true;

  static const _options = [
    AnswerOption(key: 'A', text: 'A'),
    AnswerOption(key: 'B', text: 'B'),
    AnswerOption(key: 'C', text: 'C'),
    AnswerOption(key: 'D', text: 'D'),
  ];

  // Explanation options with full text
  static const _optionsExplanation = [
    AnswerOption(key: 'A', text: "They're folding some papers"),
    AnswerOption(key: 'B', text: "They're putting a picture in a frame"),
    AnswerOption(key: 'C', text: "They're studying a drawing"),
    AnswerOption(key: 'D', text: "They're closing a window"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Câu $_currentQuestion',
        actions: [
          IconButton(
            icon: const Icon(Icons.error_outline_rounded, color: AppColors.appBarFg),
            onPressed: () {},
            iconSize: 22,
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: AppColors.appBarFg),
            onPressed: () {},
            iconSize: 22,
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: AppColors.appBarFg),
            onPressed: () {},
            iconSize: 22,
          ),
          AppBarTextActionRaw(
            label: 'Giải thích',
            onTap: () => setState(() => _showExplanation = !_showExplanation),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Audio player bar ─────────────────────────────────────
          _AudioBar(
            isPlaying: _isPlaying,
            progress: _audioProgress,
            elapsed: '00:02',
            total: '0:22',
            onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
          ),

          // ── Main content ─────────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    // Question card content (image + answers)
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "Select the answer" header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB8860B).withOpacity(0.85),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                children: [
                                  TextSpan(text: 'Select the '),
                                  TextSpan(
                                    text: 'answer',
                                    style: TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Image placeholder
                          Container(
                            height: 230,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_rounded,
                                size: 60, color: Colors.grey),
                          ),

                          // Answer options
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            child: AnswerCard(
                              options: _showExplanation
                                  ? _optionsExplanation
                                  : _options,
                              selectedKey: _selected,
                              correctKey: _submitted != null ? 'A' : null,
                              onSelect: _submitted == null
                                  ? (k) => setState(() => _selected = k)
                                  : null,
                              title: '',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ── Explanation panel (slides up from bottom) ───────
                if (_showExplanation)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _ExplanationPanel(
                      onClose: () =>
                          setState(() => _showExplanation = false),
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

// ── Audio player bar ─────────────────────────────────────────────────────────

class _AudioBar extends StatelessWidget {
  const _AudioBar({
    required this.isPlaying,
    required this.progress,
    required this.elapsed,
    required this.total,
    required this.onPlayPause,
  });

  final bool isPlaying;
  final double progress;
  final String elapsed;
  final String total;
  final VoidCallback onPlayPause;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _AudioBtn(icon: Icons.replay_5_rounded, onTap: () {}),
          const SizedBox(width: 8),
          _AudioBtn(
            icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onTap: onPlayPause,
            size: 28,
          ),
          const SizedBox(width: 8),
          _AudioBtn(icon: Icons.forward_5_rounded, onTap: () {}),
          const SizedBox(width: 10),
          Text(elapsed,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: SliderComponentShape.noOverlay,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.primaryLighter,
                thumbColor: AppColors.primary,
              ),
              child: Slider(
                value: progress,
                onChanged: (_) {},
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(total,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _AudioBtn extends StatelessWidget {
  const _AudioBtn({required this.icon, required this.onTap, this.size = 22});
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.textSecondary, size: size),
    );
  }
}

// ── Explanation panel ────────────────────────────────────────────────────────

class _ExplanationPanel extends StatefulWidget {
  const _ExplanationPanel({required this.onClose});
  final VoidCallback onClose;

  @override
  State<_ExplanationPanel> createState() => _ExplanationPanelState();
}

class _ExplanationPanelState extends State<_ExplanationPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tab bar row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tab,
                    labelColor: AppColors.textOnPrimary,
                    unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.6),
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                    indicatorColor: AppColors.textOnPrimary,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Phụ đề'),
                      Tab(text: 'Lời dịch'),
                      Tab(text: 'Từ khoá'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          SizedBox(
            height: 180,
            child: TabBarView(
              controller: _tab,
              children: [
                _ExplanationTabContent(lines: const [
                  MapEntry('A', "They're folding some papers"),
                  MapEntry('B', "They're putting a picture in a frame"),
                  MapEntry('C', "They're studying a drawing"),
                  MapEntry('D', "They're closing a window"),
                ]),
                const _ExplanationTextContent(
                    text: 'A. Họ đang gấp một số tờ giấy\n'
                        'B. Họ đang đặt một bức tranh vào khung\n'
                        'C. Họ đang nghiên cứu một bản vẽ\n'
                        'D. Họ đang đóng cửa sổ'),
                const _ExplanationTextContent(
                    text: '🔑 fold: gấp\n'
                        '🔑 picture: bức tranh\n'
                        '🔑 frame: khung\n'
                        '🔑 study: nghiên cứu, xem xét\n'
                        '🔑 window: cửa sổ'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplanationTabContent extends StatelessWidget {
  const _ExplanationTabContent({required this.lines});
  final List<MapEntry<String, String>> lines;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: lines.map((e) {
        final isHighlighted = e.key == 'B';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              children: [
                TextSpan(text: '${e.key}. '),
                TextSpan(
                  text: e.value,
                  style: isHighlighted
                      ? const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ExplanationTextContent extends StatelessWidget {
  const _ExplanationTextContent({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.7),
      ),
    );
  }
}

// ── Reusable AppBar text action without package import ───────────────────────

class AppBarTextActionRaw extends StatelessWidget {
  const AppBarTextActionRaw({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.appBarFg,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
