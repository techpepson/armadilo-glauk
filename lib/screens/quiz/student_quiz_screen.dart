import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:glauk/components/auth/auth_form.dart';
import 'package:glauk/components/buttons/custom_floating_action.dart';
import 'package:glauk/components/custom_dropdown_menu.dart';
import 'package:glauk/components/utils/empty_widget.dart';
import 'package:glauk/core/constants/constants.dart';
import 'dart:developer' as dev;
import 'package:glauk/services/util_services.dart';
import 'package:glauk/data/course_data.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class StudentQuizScreen extends StatefulWidget {
  const StudentQuizScreen({super.key});

  @override
  State<StudentQuizScreen> createState() => _StudentQuizScreenState();
}

//add the option to share and download quizzes
class _StudentQuizScreenState extends State<StudentQuizScreen> {
  int studentLevel = 12;
  int totalXP = 3000;
  int userXP = 2750;
  double averageScore = 85.5;
  String courseDisplayImage = '';
  int currentNumberOfQuestions = 10;

  final List<String> quizStatus = [
    'All',
    'Not Started',
    'Completed',
    'In Progress',
    'Retake Recommended',
  ];

  XFile? selectedFile;
  String? selectedFilePath;
  String? selectedFileExtension;
  String selectedChoice = 'All';

  CourseData courseData = CourseData();
  List<Map<String, dynamic>> completedQuizzes = [];
  List<Map<String, dynamic>> inProgressQuizzes = [];
  List<Map<String, dynamic>> notStartedQuizzes = [];
  List<Map<String, dynamic>> retakeRecommendedQuizzes = [];
  UtilService utilService = UtilService();

  @override
  void initState() {
    super.initState();
    completedQuizzes = utilService.getSlidesByStatus(
      'completed',
      courseData.courseSlides,
    );
    inProgressQuizzes = utilService.getSlidesByStatus(
      'in_progress',
      courseData.courseSlides,
    );
    notStartedQuizzes = utilService.getSlidesByStatus(
      'not_started',
      courseData.courseSlides,
    );
    retakeRecommendedQuizzes = utilService.getSlidesByStatus(
      'retake_recommended',
      courseData.courseSlides,
    );
  }

  double getAverageScore() {
    int count = 0;
    double total = 0;
    for (var slide in courseData.courseSlides) {
      if (slide['solutionStatus'] == 'completed' && slide['scores'] != null) {
        total += slide['scores'] as double;
        count++;
      }
    }
    return count > 0 ? total / count : 0.0;
  }

  Future<dynamic> uploadFile() async {
    final List<String> allowedExtensions = [
      'pdf',
      'doc',
      'docx',
      'ppt',
      'pptx',
      'png',
      'jpeg',
      'jpg',
    ];
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );
      if (result != null) {
        setState(() {
          selectedFile = XFile(result.files.single.path!);
          selectedFilePath = result.files.single.path;
          selectedFileExtension = result.files.single.extension;
        });
        dev.log(selectedFileExtension.toString());
      }
      if (!allowedExtensions.contains(selectedFileExtension)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid file type',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Quiz')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'slides_upload_fab',
        onPressed: () async {
          await _showSlideAdditionDialog();
        },
        child: Icon(Icons.add),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildLevelBar(),
                  _buildScoreCards(),
                  _buildQuizStatus(),
                  _buildExamCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(70),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Learning Progress',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Constants.primary.withAlpha(70),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      color: Constants.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Level $studentLevel',
                      style: TextStyle(
                        color: Constants.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: Constants.inter,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                  children: [
                    TextSpan(
                      text: userXP.toString(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' / '),
                    TextSpan(text: totalXP.toString()),
                    const TextSpan(text: ' XP'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: userXP / totalXP,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Constants.primary),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${((userXP / totalXP) * 100).toStringAsFixed(1)}% Complete',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: 12,
                ),
              ),
              Text(
                '${totalXP - userXP} XP to next level',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCards() {
    final getCompletedQuizzes =
        courseData.courseSlides
            .where((slide) => slide['solutionStatus'] == 'completed')
            .length;
    final getTotalQuizzes = courseData.courseSlides.length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreCard(
                title: 'Average Score',
                value: '${getAverageScore().toStringAsFixed(1)}%',
                icon: Icons.bar_chart_rounded,
                color: Colors.blue,
              ),
              Container(height: 40, width: 1, color: Colors.grey[300]),
              _buildScoreCard(
                title: 'Quizzes Taken',
                value: '$getCompletedQuizzes/$getTotalQuizzes',
                icon: Icons.quiz_rounded,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).hintColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizStatus() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quizStatus.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedChoice == quizStatus[index];
          return FilterChip(
            label: Text(quizStatus[index]),
            selected: isSelected,
            onSelected: (value) {
              setState(() {
                selectedChoice = quizStatus[index];
              });
              dev.log(selectedChoice);
            },
            backgroundColor: Theme.of(context).cardColor,
            selectedColor: Constants.primary.withValues(alpha: 0.2),
            checkmarkColor: Constants.primary,
            labelStyle: TextStyle(
              color:
                  isSelected
                      ? Constants.primary
                      : Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color:
                    isSelected
                        ? Constants.primary
                        : Theme.of(context).dividerColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExamCard() {
    return selectedChoice == 'All' && courseData.courseSlides.isEmpty ||
            selectedChoice == 'Completed' && completedQuizzes.isEmpty ||
            selectedChoice == 'In Progress' && inProgressQuizzes.isEmpty ||
            selectedChoice == 'Not Started' && notStartedQuizzes.isEmpty ||
            selectedChoice == 'Retake Recommended' &&
                retakeRecommendedQuizzes.isEmpty
        ? EmptyWidget(
          icon: Constants.bookIcon,
          title:
              selectedChoice == 'All'
                  ? 'No Quizzes Generated Yet'
                  : selectedChoice == 'Not Started'
                  ? 'No Unstarted Quizzes'
                  : selectedChoice == 'In Progress'
                  ? 'No In Progress Quizzes'
                  : selectedChoice == 'Completed'
                  ? 'No Completed Quizzes'
                  : 'No Retake Recommended Quizzes',
          subtitle: 'Upload slides to generate quizzes',
        )
        : SizedBox(
          height: 500,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(10),
            itemCount:
                selectedChoice == 'All'
                    ? courseData.courseSlides.length
                    : selectedChoice == 'Completed'
                    ? completedQuizzes.length
                    : selectedChoice == 'In Progress'
                    ? inProgressQuizzes.length
                    : selectedChoice == 'Not Started'
                    ? notStartedQuizzes.length
                    : retakeRecommendedQuizzes.length,
            itemBuilder: (context, index) {
              final course =
                  selectedChoice == 'All'
                      ? courseData.courseSlides[index]
                      : selectedChoice == 'Completed'
                      ? completedQuizzes[index]
                      : selectedChoice == 'In Progress'
                      ? inProgressQuizzes[index]
                      : selectedChoice == 'Not Started'
                      ? notStartedQuizzes[index]
                      : retakeRecommendedQuizzes[index];
              int completeTime =
                  course['solutionStatus'] == 'completed'
                      ? course['completeTime'] as int ?? 0
                      : 0;

              final quizScore =
                  course['solutionStatus'] == 'completed'
                      ? course['scores'] as double ?? 0
                      : 0;

              String scoreComplement = '';

              String completeTimeText = '';

              switch (quizScore) {
                case 0:
                  scoreComplement = 'Critical Attention Needed';
                  break;
                case >= 50 && < 75:
                  scoreComplement = 'Good Condition';
                  break;
                case >= 75 && < 90:
                  scoreComplement = 'Consistent Learner';
                  break;
                case >= 90 && <= 100:
                  scoreComplement = 'Perfect Score';
                  break;
                default:
                  scoreComplement = 'Keep Learning';
              }
              final studyField = course['courseField'] ?? 'science';
              switch (studyField) {
                case 'science':
                  courseDisplayImage = Constants.scienceImage;
                  break;
                case 'computing':
                  courseDisplayImage = Constants.computingImage;
                  break;
                case 'business':
                  courseDisplayImage = Constants.businessImage;
                  break;
                case 'arts':
                  courseDisplayImage = Constants.artsImage;
                  break;
                case 'english':
                  courseDisplayImage = Constants.englishImage;
                  break;
                case 'humanities':
                  courseDisplayImage = Constants.humanitiesImage;
                  break;
                case 'languages':
                  courseDisplayImage = Constants.languagesImage;
                  break;
                case 'maths':
                  courseDisplayImage = Constants.mathsImage;
                  break;
                case 'others':
                  courseDisplayImage = Constants.othersImage;
                  break;
                case 'statistics':
                  courseDisplayImage = Constants.statisticsImage;
                  break;
                default:
                  courseDisplayImage = Constants.scienceImage;
              }

              switch (completeTime) {
                case 0:
                  completeTimeText = 'Uncompleted';
                  break;
                case >= 1 && < 10:
                  completeTimeText = 'Moderate Finisher';
                  break;
                case >= 10 && < 20:
                  completeTimeText = 'Good Finisher';
                  break;
                case >= 20 && < 30:
                  completeTimeText = 'Excellent Finisher';
                  break;
                default:
                  completeTimeText = 'Not Started';
              }
              return Dismissible(
                key: ValueKey(course['slideId']),
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Remove Quiz?'),
                          content: Text(
                            'This will remove the quiz from your list. This cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'REMOVE',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                background: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Course Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                courseDisplayImage,
                                fit: BoxFit.cover,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Course Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['slideTitle'] ?? 'Untitled Quiz',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Uploaded: ${course['slideUploadTime']}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Difficulty & Time Chips
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildInfoChip(
                                        icon: Icons.star_rate_rounded,
                                        label:
                                            '${course['difficultyLevel'] ?? 'N/A'}'
                                                .toUpperCase(),
                                        color: _getDifficultyColor(
                                          course['difficultyLevel'],
                                        ),
                                      ),
                                      _buildInfoChip(
                                        icon: Icons.timer_outlined,
                                        label:
                                            '${course['completeTime'] ?? 0} min',
                                        color: Colors.blue[500]!,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Progress Section
                        if (course['solutionStatus'] == 'completed') ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem(
                                '${course['questions']?.length ?? 0}',
                                '${course['questions']?.length ?? 0} ${course['questions']?.length > 1 ? 'Questions' : 'Question'}',
                                Icons.help_outline,
                                color: Colors.blue[500]!,
                              ),
                              _buildStatItem(
                                '${course['scores']?.toStringAsFixed(1) ?? '0'}%',
                                'Score',
                                Icons.emoji_events_outlined,
                                color: _getScoreColor(course['scores'] ?? 0),
                              ),
                              _buildStatItem(
                                completeTimeText,
                                'Time',
                                Icons.timer_outlined,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: (course['scores'] ?? 0) / 100,
                            minHeight: 6,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getScoreColor(course['scores'] ?? 0),
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ] else
                          Text(
                            '${course['questions']?.length ?? 0} ${course['questions']?.length > 1 ? 'Questions' : 'Question'} • ${course['completeTime'] ?? 0} min',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                        const SizedBox(height: 12),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // Handle take/retake quiz
                                },
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 20,
                                ),
                                label: Text(
                                  course['solutionStatus'] == 'completed'
                                      ? 'Retake Quiz'
                                      : 'Start Quiz',
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Handle view results/review
                                  course['solutionStatus'] == 'completed'
                                      ? context.push(
                                        '/quiz-results',
                                        extra: {
                                          'course': course,
                                          'displayImage': courseDisplayImage,
                                        },
                                      )
                                      : context.push(
                                        '/quiz-review',
                                        extra: {
                                          'course': course,
                                          'displayImage': courseDisplayImage,
                                        },
                                      );
                                },
                                icon: Icon(
                                  course['solutionStatus'] == 'completed'
                                      ? Icons.bar_chart_rounded
                                      : Icons.visibility_outlined,
                                  size: 20,
                                ),
                                label: Text(
                                  course['solutionStatus'] == 'completed'
                                      ? 'View Results'
                                      : 'Review',
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
  }

  // Widget _buildSlideDisplayCard() {
  //   return Container();
  // }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color.withValues(alpha: 0.8)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color ?? Theme.of(context).hintColor),
            const SizedBox(width: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Theme.of(context).hintColor),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 85) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  //show slide addition function

  Future<void> _showSlideAdditionDialog() async {
    final isPdf =
        (selectedFileExtension == 'pdf' ||
            selectedFileExtension == 'ppt' ||
            selectedFileExtension == 'pptx' ||
            selectedFileExtension == 'doc' ||
            selectedFileExtension == 'docx');
    final isImage =
        (selectedFileExtension == 'jpg' ||
            selectedFileExtension == 'jpeg' ||
            selectedFileExtension == 'png' ||
            selectedFileExtension == 'gif');
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(onPressed: () {}, child: Text('Generate Quiz')),
              ],
              insetPadding: EdgeInsets.all(5),
              contentPadding: EdgeInsets.all(20),
              title: GestureDetector(
                onTap: () async {
                  await uploadFile();
                  setState(() {});
                },
                child: DottedBorder(
                  options: RectDottedBorderOptions(
                    padding: const EdgeInsets.all(14),
                    color: Constants.primary,
                    strokeWidth: 1,
                    dashPattern: const [2, 2],
                  ),
                  child: Center(
                    child:
                        selectedFile != null && isImage
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(selectedFile!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                            : selectedFile != null && isPdf
                            ? Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.file_copy_outlined,
                                  color: Constants.primary,
                                ),
                                Expanded(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    selectedFile!.name.toString(),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedFile = null;
                                      selectedFileExtension = null;
                                      selectedFilePath = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel_presentation_rounded,
                                    color: Constants.error,
                                  ),
                                ),
                              ],
                            )
                            : Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Constants.primary.withAlpha(70),
                                  ),
                                  child: Icon(
                                    Icons.file_upload_outlined,
                                    color: Constants.primary.withAlpha(170),
                                    size: 40,
                                  ),
                                ),
                                Text(
                                  'Tap to upload pdf or  Powerpoint slides',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  "Max File Size: 50MB",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.appBg,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(70),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(70),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          CustomDropdownMenu(
                            title: 'Course Area *',
                            items: Constants.subjectAreas,
                          ),
                          SizedBox(height: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Course Code *'),
                              AuthForm(
                                labelText: 'Course Code',
                                hintText: 'Enter course code',
                                onChanged: (value) {},
                              ),
                              SizedBox(height: 16),
                              CustomDropdownMenu(
                                title: 'Question Type *',
                                items: Constants.questionType,
                              ),
                              SizedBox(height: 16),
                              CustomDropdownMenu(
                                title: 'Difficulty Level *',
                                items: Constants.difficultyLevel,
                              ),
                              //number of questions to generated
                              SizedBox(height: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Text('Number of Questions to Generate'),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (currentNumberOfQuestions > 1) {
                                              currentNumberOfQuestions--;
                                            }
                                          });
                                        },
                                        child: Icon(Icons.remove),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AuthForm(
                                              labelText:
                                                  currentNumberOfQuestions
                                                      .toString(),
                                              hintText:
                                                  "Number of questions to generate",
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value.isNotEmpty) {
                                                    currentNumberOfQuestions =
                                                        int.parse(value);
                                                  }
                                                });
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            currentNumberOfQuestions++;
                                          });
                                        },
                                        child: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Text('Additional Notes'),
                                  AuthForm(
                                    maxLines: 3,

                                    labelText:
                                        "Any instructions to improve quiz quality",
                                  ),
                                ],
                              ),
                              //
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
