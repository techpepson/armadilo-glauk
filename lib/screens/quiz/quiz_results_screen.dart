import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:glauk/data/course_data.dart';
import 'dart:developer' as dev;

import 'package:go_router/go_router.dart';

class QuizResultsScreen extends StatefulWidget {
  const QuizResultsScreen({
    super.key,
    required this.courseSlides,
    required this.courseDisplayImage,
  });

  final Map<String, dynamic> courseSlides;
  final String courseDisplayImage;

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  final _courseData = CourseData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Results',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
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
              _buildQuizResultsCard(),
              const SizedBox(height: 16),
              _buildPerformanceBreakDown(),
              const SizedBox(height: 16),
              _buildQuestionReviewCard(),
              const SizedBox(height: 24),
              _buildStartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizResultsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Constants.primary, width: 1),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color:
                  widget.courseSlides['scores'] > 60
                      ? Constants.success.withAlpha(70)
                      : Constants.error.withAlpha(70),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                '${widget.courseSlides['scores'].toString()}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 2, 102, 18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Text(
                widget.courseSlides['slideTitle'],
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              widget.courseSlides['scores'] > 60
                  ? Text(
                    'Great job! You did well! 👏',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.textColor.withAlpha(170),
                    ),
                  )
                  : Text(
                    'Better luck next time!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.textColor,
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.textColor.withAlpha(170),
                    ),
                    '${widget.courseSlides['rightAnswers']} / ${widget.courseSlides['questions'].length}',
                  ),
                  Text(
                    'Right Answers',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.textColor.withAlpha(170),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${widget.courseSlides['completeTime']} min',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.textColor.withAlpha(170),
                    ),
                  ),
                  Text(
                    'Time Spent',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.textColor.withAlpha(170),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '⭐ ${widget.courseSlides['pointsEarned']} XP',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.textColor.withAlpha(170),
                    ),
                  ),
                  Text(
                    'XP Earned',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.textColor.withAlpha(170),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPerformanceBreakDown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: Constants.primary),
                SizedBox(width: 8),
                Text(
                  'Performance Breakdown',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall Score',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Constants.textColor.withAlpha(170),
                  ),
                ),

                Text(
                  '${widget.courseSlides['scores'].toString()}%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Constants.success.withAlpha(170),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              minHeight: 15,
              value: widget.courseSlides['scores'] / 100,
              color: Constants.textColor,
              stopIndicatorRadius: 20,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Constants.greyedText,
            ),
            SizedBox(height: 24),
            //show correct and wrong answers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Constants.success),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Text('${widget.courseSlides['rightAnswers']} '),
                        Text(
                          'Correct',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Constants.textColor.withAlpha(170),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.close, color: Constants.error),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          '${widget.courseSlides['questions'].length - widget.courseSlides['rightAnswers']}',
                        ),
                        Text(
                          'Incorrect',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Constants.textColor.withAlpha(170),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // SizedBox(height: 16),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionReviewCard() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Question Review',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 28),
          ListView.builder(
            scrollDirection: Axis.vertical,
            physics: PageScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.courseSlides['questions'].length,
            itemBuilder: (context, index) {
              final question = widget.courseSlides['questions'][index];

              final List<Map<String, dynamic>> options =
                  List<Map<String, dynamic>>.from(
                    question['options'] ?? const [],
                  );
              final answerId = question['answer'];

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${index + 1} .'),
                        Text(
                          '${question['query']}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            // color: Constants.textColor.withAlpha(190),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    //container to display answers
                    Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...options.map((option) {
                          return Container(
                            height: 70,
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color:
                                    answerId == option['optionId']
                                        ? Constants.success.withAlpha(170)
                                        : Constants.error.withAlpha(170),
                              ),
                              color:
                                  answerId == option['optionId']
                                      ? Constants.success.withAlpha(70)
                                      : Constants.error.withAlpha(70),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  option['option']?.toString() ?? 'N/A',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: Constants.textColor.withAlpha(190),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/student-quiz');
                },
                icon: Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                label: Text(
                  'Continue To Quizzes',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  backgroundColor: Constants.primary,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.go(
                '/take-quiz',
                extra: {'questions': widget.courseSlides},
              );
            },
            icon: Icon(Icons.refresh, size: 20),
            label: Text('Retake Quiz'),
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
