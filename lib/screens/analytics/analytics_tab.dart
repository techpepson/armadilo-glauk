import 'package:flutter/material.dart';
import 'package:glauk/components/utils/empty_widget.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:glauk/data/analytics_data.dart';
import 'package:glauk/data/course_data.dart';
import 'package:glauk/data/student_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:developer' as dev;

import 'package:glauk/services/util_services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  final StudentData studentData = StudentData();
  final AnalyticsData analyticsData = AnalyticsData();
  final UtilService utilService = UtilService();
  final CourseData courseData = CourseData();
  final String _user = 'Dickson';

  int _completedQuizzes = 50;
  int _studyTime = 123;
  int _uploadedSlides = 10;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: PageScrollPhysics(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Column(
              children: [
                _buildPredictionCard(),
                _buildScoreSummaryCard(),
                _buildMasteryCard(),
                _buildStreaksCard(),
                _buildSuggestionCard(),
                _buildShareCard(),
                _buildBottomCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPredictionCard() {
    final currentGPA = studentData.studentDetails['currentGpa'];
    final targetGPA = studentData.studentDetails['targetGpa'];
    final gpaData = analyticsData.gpaData.isEmpty ? [] : analyticsData.gpaData;
    return Container(
      child: Column(
        children: [
          Row(children: [Icon(Constants.chartArrow), Text('GPA Prediction')]),
          Row(
            children: [
              Column(children: [Text('Current GPA'), Text('$currentGPA')]),
              Column(children: [Text('Projected GPA'), Text('$targetGPA')]),
            ],
          ),

          //chart display of gpa prediction
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: [
              LineSeries(
                dataSource: gpaData,
                xValueMapper:
                    (data, index) =>
                        utilService.convertStringToDateTime(data['uploadDate']),
                yValueMapper: (data, index) => data['gpa'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSummaryCard() {
    final scoresData = analyticsData.scoresData;
    final values = utilService.valuesByWeek(scoresData, 'uploadDate');

    final monthValues = utilService.valuesByMonth(scoresData, 'uploadDate');

    //find average of all values less than a week
    final sum = values.fold(0, (first, second) {
      final results = (first + second['score']);
      return results.toInt();
    });

    final monthSum = monthValues.fold(0, (first, second) {
      final results = (first + second['score']);
      return results.toInt();
    });
    final averageByWeek = values.isEmpty ? 0 : sum / values.length;
    final averageByMonth =
        monthValues.isEmpty ? 0 : monthSum / monthValues.length;

    final highestScore = utilService.highestScore(scoresData, 'score');

    final lowestScore = utilService.lowestScore(scoresData, 'score');

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Card(
                child: Center(
                  child: Column(
                    children: [
                      Text('Weekly Average'),
                      Text('${averageByWeek.toStringAsFixed(2)} %'),
                    ],
                  ),
                ),
              ),
              Card(
                child: Center(
                  child: Column(
                    children: [
                      Text('Monthly Average'),
                      Text('${averageByMonth.toStringAsFixed(2)} %'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Card(
                child: Center(
                  child: Column(
                    children: [Text('Highest Score'), Text('$highestScore')],
                  ),
                ),
              ),
              Card(
                child: Center(
                  child: Column(
                    children: [Text('Lowest Score'), Text('$lowestScore')],
                  ),
                ),
              ),
            ],
          ),
          LinearProgressIndicator(
            value: averageByWeek.toDouble(),
            valueColor: AlwaysStoppedAnimation(Constants.primary),
            color: Colors.grey,
            backgroundColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryCard() {
    final overallScore = utilService.overallScore(
      courseData.courseSlides,
      'scores',
    );
    return Container(
      child:
          courseData.courseSlides.isEmpty
              ? EmptyWidget(
                icon: Constants.bookIcon,
                title: 'No Course Uploaded',
                subtitle: 'Upload a course to summary',
              )
              : Column(
                children: [
                  Row(
                    children: [
                      Icon(Constants.bookIcon),
                      Text('Course Mastery'),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      physics: PageScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: courseData.courseSlides.length,
                      itemBuilder: (context, index) {
                        final item = courseData.courseSlides[index];
                        final itemTitle = item['slideTitle'] ?? 'Unknown';
                        final courseField = item['courseField'] ?? 'Unknown';
                        final courseScore = item['scores'] ?? 0;
                        final displayImage = utilService.getDisplayImage(
                          courseField,
                        );
                        return Column(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      displayImage,
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(itemTitle),
                                  ],
                                ),
                                Text(courseScore.toStringAsFixed(2)),
                              ],
                            ),
                            LinearProgressIndicator(
                              value: courseScore,
                              valueColor: AlwaysStoppedAnimation(
                                Constants.primary,
                              ),
                              color: Colors.grey,
                              backgroundColor: Colors.grey,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  //overall score average
                  Column(
                    children: [
                      Text('Overall Mastery'),
                      Text(
                        '${overallScore.toStringAsFixed(2)} % across all courses',
                      ),
                    ],
                  ),
                ],
              ),
    );
  }

  Widget _buildStreaksCard() {
    return Container(
      child: Column(
        children: [
          Row(children: [Icon(Icons.whatshot_outlined), Text('Quiz Streaks')]),
          Row(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.whatshot_outlined),
                      Text('Current Streak'),
                    ],
                  ),
                  Text('${analyticsData.streakData['currentStreak']}'),
                  Text('days'),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.whatshot_outlined),
                      Text('Longest Streak'),
                    ],
                  ),
                  Text('${analyticsData.streakData['longestStreak']}'),
                  Text('days'),
                ],
              ),
            ],
          ),

          Row(
            children: [
              Text('Weekly Goal Progress'),
              Text(
                '${analyticsData.weeklyGoals['currentProgressiveDays']} / 5 days',
              ),
            ],
          ),

          LinearProgressIndicator(
            value: analyticsData.weeklyGoals['currentProgressiveDays'] / 5,
            valueColor: AlwaysStoppedAnimation(Constants.primary),
            color: Colors.grey,
            backgroundColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard() {
    return Container(
      child: Column(
        children: [
          Row(children: [Icon(FontAwesomeIcons.brain), Text('Study Tip')]),
          Text(
            'Focus on courses with low grades and retry quizzes again for perfection. You\'ve got this $_user !',
          ),
        ],
      ),
    );
  }

  Widget _buildShareCard() {
    return ElevatedButton(
      onPressed: () async {
        final params = ShareParams(
          title: "Check $_user's Progress on ${Constants.glauk}",
          uri: Uri.parse('https://google.com'),
          subject: 'Check out my progress on ${Constants.glauk}!',
          previewThumbnail: XFile(Constants.glaukLogo),
        );
        final share = await SharePlus.instance.share(params);
        if (share.status == ShareResultStatus.success && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Shared successfully')));
        }
      },
      child: Center(
        child: Row(children: [Icon(Icons.share), Text('Share My Progress')]),
      ),
    );
  }

  Widget _buildBottomCard() {
    return Row(
      children: [
        Card(
          child: Column(
            children: [Text('Completed Quizzes'), Text('$_completedQuizzes')],
          ),
        ),
        Card(
          child: Column(children: [Text('Study Time'), Text('$_studyTime')]),
        ),
        Card(
          child: Column(
            children: [Text('Uploaded Slides'), Text('$_uploadedSlides')],
          ),
        ),
      ],
    );
  }
}
