import 'dart:async';
import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:go_router/go_router.dart';

class TakeQuizScreen extends StatefulWidget {
  const TakeQuizScreen({super.key, required this.questions});

  /// Entire course slide map passed from StudentQuizScreen via GoRouter extra
  final Map<String, dynamic> questions;

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<dynamic> _questions = [];
  int _totalQuestions = 0;
  PageController _pageController = PageController();

  // Timer
  Timer? _timer;
  int _remainingSeconds = 0; // countdown in seconds
  int _timeSpentSeconds = 0; // to record time spent

  // Answers: questionIndex -> selected optionId
  final Map<int, int> _selectedAnswers = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _questions = List<dynamic>.from(widget.questions['questions'] ?? const []);
    _totalQuestions = _questions.length;
    _pageController = PageController();

    // Setup countdown based on completeTime (minutes) from slide
    final int minutes = (widget.questions['completeTime'] as int?) ?? 10;
    _remainingSeconds = minutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _timeSpentSeconds++;
        } else {
          timer.cancel();
          _submitQuiz(autoSubmitted: true);
        }
      });
    });
  }

  void _onSelectOption(int questionIndex, int optionId) {
    setState(() {
      _selectedAnswers[questionIndex] = optionId;
    });
  }

  void _next() {
    if (_currentIndex < _totalQuestions - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _submitQuiz({bool autoSubmitted = false}) {
    // Calculate score
    int correct = 0;
    for (int i = 0; i < _totalQuestions; i++) {
      final q = _questions[i] as Map<String, dynamic>;
      final int answerId = (q['answer'] as int? ?? -1);
      final int? selected = _selectedAnswers[i];
      if (selected != null && selected == answerId) {
        correct++;
      }
    }
    final double score =
        _totalQuestions == 0 ? 0 : (correct / _totalQuestions) * 100.0;

    // Prepare updated course slide map
    final updated = Map<String, dynamic>.from(widget.questions);
    updated['rightAnswers'] = correct;
    updated['scores'] = double.parse(score.toStringAsFixed(1));
    // Time spent in minutes (rounded up)
    final int spentMinutes = (_timeSpentSeconds / 60).ceil();
    updated['completeTime'] = spentMinutes;
    updated['solutionStatus'] = 'completed';

    // Navigate to results
    context.go(
      '/quiz-results',
      extra: {
        'course': updated,
        // you might want to compute display image like student screen does; for now omit
        'displayImage': Constants.scienceImage,
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progressByQuestion =>
      _totalQuestions == 0 ? 0 : (_currentIndex + 1) / _totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Quiz'),
        actions: [
          // Timer display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top meta and progress
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Constants.primary.withAlpha(40),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (widget.questions['difficultyLevel'] ?? 'N/A')
                            .toString()
                            .toUpperCase(),
                        style: TextStyle(color: Constants.primary),
                      ),
                    ),
                    const Spacer(),
                    Text('${_currentIndex + 1} / $_totalQuestions'),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  minHeight: 8,
                  value: _progressByQuestion,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Constants.primary),
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // PageView for questions
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: _onPageChanged,
              itemCount: _totalQuestions,
              itemBuilder: (context, index) {
                final Map<String, dynamic> q = Map<String, dynamic>.from(
                  _questions[index] as Map,
                );
                final List<Map<String, dynamic>> options =
                    List<Map<String, dynamic>>.from(q['options'] ?? const []);
                final selected = _selectedAnswers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          q['query']?.toString() ?? 'Question',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        ...options.map((opt) {
                          final int optionId = (opt['optionId'] as int? ?? -1);
                          final bool isSelected = selected == optionId;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Constants.primary
                                        : Theme.of(context).dividerColor,
                              ),
                              color:
                                  isSelected
                                      ? Constants.primary.withAlpha(25)
                                      : Theme.of(context).cardColor,
                            ),
                            child: RadioListTile<int>(
                              value: optionId,
                              groupValue: selected,
                              onChanged: (val) {
                                if (val == null) return;
                                _onSelectOption(index, val);
                              },
                              title: Text(
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                opt['option']?.toString() ?? '',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              activeColor: Constants.primary,
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom controls
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _prev,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 12),
                if (_currentIndex < _totalQuestions - 1)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _next,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _submitQuiz(),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primary,
                        foregroundColor: Colors.white,
                      ),
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
