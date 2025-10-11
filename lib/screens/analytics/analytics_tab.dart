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
    return Scaffold(
      body: RefreshIndicator(
        color: Constants.primary,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          physics: PageScrollPhysics(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Column(
                  children: [
                    _buildPredictionCard(),
                    SizedBox(height: 12),
                    _buildScoreSummaryCard(),
                    SizedBox(height: 12),
                    _buildMasteryCard(),
                    SizedBox(height: 12),
                    _buildStreaksCard(),
                    SizedBox(height: 12),
                    _buildSuggestionCard(),
                    SizedBox(height: 12),
                    _buildShareCard(),
                    SizedBox(height: 12),
                    _buildBottomCard(),
                    SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    final currentGPA = studentData.studentDetails['currentGpa'];
    final targetGPA = studentData.studentDetails['targetGpa'];
    final gpaData = analyticsData.gpaData.isEmpty ? [] : analyticsData.gpaData;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart, color: Constants.primary),
                  SizedBox(width: 5),
                  Text(
                    'GPA Chart',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current GPA',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '$currentGPA',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Constants.primary,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Projected GPA',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '$targetGPA',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Constants.success,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              //chart display of gpa prediction
              SfCartesianChart(
                legend: Legend(
                  title: LegendTitle(text: 'GPA By Date'),
                  isVisible: true,
                ),

                primaryXAxis: DateTimeAxis(),
                series: [
                  LineSeries(
                    dataSource: gpaData,
                    xValueMapper:
                        (data, index) => utilService.convertStringToDateTime(
                          data['uploadDate'],
                        ),
                    yValueMapper: (data, index) => data['gpa'],
                  ),
                ],
              ),
            ],
          ),
        ),
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Constants.chartArrow, color: Constants.primary),
                  SizedBox(width: 5),
                  Text(
                    'Score Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              'Weekly Average',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            ),
                            Text(
                              '${averageByWeek.toStringAsFixed(2)} %',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Constants.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              'Monthly Average',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w300),
                            ),
                            Text(
                              '${averageByMonth.toStringAsFixed(2)} %',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Constants.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 118,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Constants.success, width: 1),
                      color: Constants.success.withAlpha(40),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Highest: ',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              color: Constants.success,
                            ),
                          ),
                          Text(
                            '$highestScore%',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Constants.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 115,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Constants.error, width: 1),
                      color: Constants.error.withAlpha(40),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Lowest ',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              color: Constants.error,
                            ),
                          ),
                          Text(
                            '$lowestScore%',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: Constants.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weekly Progress',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${averageByWeek.toStringAsFixed(2)} %',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Constants.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(6),
                    value: averageByWeek.toDouble() / 100,
                    valueColor: AlwaysStoppedAnimation(Constants.primary),
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasteryCard() {
    final overallScore = utilService.overallScore(
      courseData.courseSlides,
      'scores',
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child:
            courseData.courseSlides.isEmpty
                ? EmptyWidget(
                  icon: Constants.bookIcon,
                  title: 'No Course Uploaded',
                  subtitle: 'Upload a course to summary',
                )
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Constants.bookIcon, color: Constants.primary),
                          SizedBox(width: 8),
                          Text(
                            'Course Mastery',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 370,
                        child: ListView.builder(
                          itemExtent: 50,
                          physics: PageScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: courseData.courseSlides.length,
                          itemBuilder: (context, index) {
                            final item = courseData.courseSlides[index];
                            final itemTitle = item['slideTitle'] ?? 'Unknown';
                            final courseField =
                                item['courseField'] ?? 'Unknown';
                            final courseScore = item['scores'] ?? 0;
                            final displayImage = utilService.getDisplayImage(
                              courseField,
                            );
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          displayImage,
                                          height: 30,
                                          width: 30,
                                        ),
                                        Text(
                                          itemTitle,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      courseScore.toStringAsFixed(2),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color:
                                            courseScore >= 80
                                                ? Constants.success
                                                : courseScore >= 50
                                                ? Constants.secondary
                                                : Constants.error,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                LinearProgressIndicator(
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(6),
                                  value: courseScore / 100,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Mastery',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '${overallScore.toStringAsFixed(2)}%',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                  color:
                                      overallScore >= 80
                                          ? Constants.success
                                          : overallScore >= 50
                                          ? Constants.secondary
                                          : Constants.error,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'across all courses',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildStreaksCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.whatshot_outlined, color: Constants.primary),
                  SizedBox(width: 5),
                  Text(
                    'Quiz Streaks',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.whatshot_outlined,
                            color: Constants.secondary,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Current Streak',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Text(
                        '${analyticsData.streakData['currentStreak']}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 28,
                          color:
                              analyticsData.streakData['currentStreak'] > 0
                                  ? Constants.primary
                                  : Constants.error,
                        ),
                      ),
                      Text(
                        'days',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.whatshot_outlined, color: Constants.error),
                          SizedBox(width: 5),
                          Text(
                            'Longest Streak',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Text(
                        '${analyticsData.streakData['longestStreak']}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 28,
                          color:
                              analyticsData.streakData['longestStreak'] > 0
                                  ? Constants.primary
                                  : Constants.error,
                        ),
                      ),
                      Text(
                        'days',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Goal Progress',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    '${analyticsData.weeklyGoals['currentProgressiveDays']} / 5 days',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      color:
                          analyticsData.weeklyGoals['currentProgressiveDays'] /
                                      5 >=
                                  0.8
                              ? Constants.success
                              : Constants.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              LinearProgressIndicator(
                value: analyticsData.weeklyGoals['currentProgressiveDays'] / 5,
                minHeight: 6,
                borderRadius: BorderRadius.circular(6),
                valueColor: AlwaysStoppedAnimation(Constants.primary),
                color: Colors.grey,
                backgroundColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.primary.withAlpha(60),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.brain, color: Constants.primary),
                  SizedBox(width: 12),
                  Text(
                    'Study Tip',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Focus on courses with low grades and retry quizzes again for perfection. You\'ve got this $_user !',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareCard() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Constants.primary),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.share, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Share My Progress',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 100,
            width: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    '$_completedQuizzes',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 24,
                      color: Constants.primary,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Completed Quizzes',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 100,
            width: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    '$_studyTime mins',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 24,
                      color: Constants.success,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Study Time',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 100,
            width: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    '$_uploadedSlides',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 24,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Uploaded Slides',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
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
