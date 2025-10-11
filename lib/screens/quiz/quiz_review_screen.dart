import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:go_router/go_router.dart';

class QuizReviewScreen extends StatefulWidget {
  const QuizReviewScreen({
    super.key,
    required this.courseSlides,
    required this.courseDisplayImage,
  });

  final Map<String, dynamic> courseSlides;
  final String courseDisplayImage;

  @override
  State<QuizReviewScreen> createState() => _QuizReviewScreenState();
}

class _QuizReviewScreenState extends State<QuizReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Review',
          style: TextStyle(
            fontSize: Constants.mediumSize,
            fontWeight: FontWeight.w400,
            fontFamily: Constants.inter,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseDetailCard(),
              const SizedBox(height: 16),
              _buildQuizDetailsCard(),
              const SizedBox(height: 16),
              _buildRulesAndRegulationsCard(),
              const SizedBox(height: 16),
              _buildImportantNotesCard(),
              const SizedBox(height: 24),
              _buildStartButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDetailCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Constants.primary.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.courseDisplayImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        widget.courseSlides['slideTitle'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: Constants.inter,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildChip(
                            label: widget.courseSlides['courseField'],
                            icon: Icons.category_outlined,
                          ),
                          _buildChip(
                            label: widget.courseSlides['difficultyLevel'],
                            icon: Icons.auto_awesome,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Test your knowledge in ${widget.courseSlides['slideTitle']} with these practice questions',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            label.toString().toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizDetailItem(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizDetailsCard() {
    final questionsCount = widget.courseSlides['questions']?.length ?? 0;
    final estimatedTime = _calculateEstimatedTime(questionsCount);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Constants.primary.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontFamily: Constants.inter,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildQuizDetailItem(
                  Icons.quiz_outlined,
                  questionsCount.toString(),
                  'Questions',
                ),
                _buildQuizDetailItem(
                  Icons.timer_outlined,
                  '$estimatedTime min',
                  'Duration',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildQuizDetailItem(
                  Constants.workSpacePremiumIcon,
                  '100',
                  'Points',
                ),
                _buildQuizDetailItem(Constants.starIcon, '+100', 'XP Rewards'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _calculateEstimatedTime(int questionsCount) {
    if (questionsCount <= 10) return 10;
    if (questionsCount <= 20) return 20;
    if (questionsCount <= 30) return 30;
    if (questionsCount <= 40) return 40;
    if (questionsCount <= 50) return 50;
    return 60;
  }

  Widget _buildItem({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 12.0),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Constants.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Constants.primary.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontFamily: Constants.inter,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => _buildItem(title: item)),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesAndRegulationsCard() {
    return _buildSectionCard(
      title: 'Rules and Regulations',
      icon: Icons.rule_outlined,
      items: const [
        'Read each question carefully before selecting your answer.',
        'You can navigate back and forth between questions.',
        'Test must be completed within the time limit',
        'Try to be truthful to yourself during the quiz.',
        'Flag questions you want to review later.',
        'You can only take the quiz once.',
      ],
    );
  }

  Widget _buildImportantNotesCard() {
    return _buildSectionCard(
      title: 'Important Notes',
      icon: Icons.info_outline_rounded,
      items: const [
        'Make sure you have a stable internet connection.',
        'You cannot pause the quiz once started.',
        'You cannot exit the quiz once started.',
        'Questions are presented one at a time.',
        'You cannot skip a question once started.',
        'Do not refresh to avoid losing state.',
        'Quiz must be completed in one sitting.',
      ],
    );
  }

  Widget _buildStartButton() {
    final questionsCount = widget.courseSlides['questions']?.length ?? 0;
    final estimatedTime = _calculateEstimatedTime(questionsCount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Constants.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to start?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: Constants.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$estimatedTime minutes',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.go(
                '/take-quiz',
                extra: {'questions': widget.courseSlides},
              );
            },
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: const Text('Start Quiz'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
