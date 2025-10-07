import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glauk/components/utils/app_bar_actions.dart';
import 'package:glauk/components/utils/empty_widget.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:glauk/data/student_data.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class StudentProgress extends StatefulWidget {
  const StudentProgress({super.key});

  @override
  State<StudentProgress> createState() => _StudentProgressState();
}

class _StudentProgressState extends State<StudentProgress> {
  final String userImage =
      "https://images.unsplash.com/photo-1522529599102-193c0d76b5b6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmxhY2slMjBtYW58ZW58MHx8MHx8fDA%3D";

  final StudentData studentData = StudentData();

  String grade = 'N/A';

  final _editFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showEditingMenu();
        },
        child: Icon(Icons.library_add),
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        actions: [AppBarActions(userImage: userImage)],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Exams",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: Constants.mediumSize,
                fontWeight: FontWeight.w600,
                fontFamily: Constants.inter,
              ),
            ),
            Text(
              "Academic Performance",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: Constants.smallSize,
                fontWeight: FontWeight.w600,
                fontFamily: Constants.inter,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: Constants.primary,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2));
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: Center(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: PageScrollPhysics(),
                  children: [
                    SizedBox(height: Constants.verticalPadding),
                    _buildGpaCard(),
                    SizedBox(height: Constants.verticalPadding),
                    _buildCourseTable(),
                    SizedBox(height: Constants.verticalPadding),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGpaCard() {
    final currentGpa = studentData.studentDetails['currentGpa'];
    final targetGpa = studentData.studentDetails['targetGpa'];
    final percentage = (currentGpa / targetGpa);
    String gpaStatus;

    switch (currentGpa) {
      case 4.0:
        gpaStatus = 'Outstanding';
        break;
      case >= 3.5 && < 4.0:
        gpaStatus = 'Excellent';
        break;
      case >= 3.0 && < 3.5:
        gpaStatus = 'Very Good';
        break;
      case >= 2.5 && < 3.0:
        gpaStatus = 'Good';
        break;
      case >= 2.0 && < 2.5:
        gpaStatus = 'Average';
        break;
      default:
        gpaStatus = 'Needs Improvement';
    }
    return GlassContainer(
      blur: 0.3,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // First row with GPA info
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Constants.verticalPadding,
                horizontal: Constants.horizontalPadding,
              ),
              child: Row(
                children: [
                  // Left side with chart arrow and GPA info
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constants.primary,
                        ),
                        child: Icon(
                          Constants.chartArrow,
                          size: Constants.largeSize,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current GPA',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: Constants.mediumSize,
                              fontWeight: FontWeight.w700,
                              fontFamily: Constants.inter,
                            ),
                          ),
                          Text(
                            gpaStatus.toString(),
                            style: TextStyle(
                              color: Constants.primary,
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w700,
                              fontFamily: Constants.inter,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Spacer to push the trailing content to the right
                  const Spacer(),

                  // Right side with current GPA and target
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currentGpa.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: Constants.largeSize,
                          fontWeight: FontWeight.w800,
                          fontFamily: Constants.inter,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Constants.targetIcon,
                            size: Constants.iconSize,
                            color: Constants.greyedText,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Target: $targetGpa',
                            style: TextStyle(
                              color: Constants.greyedText,
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w700,
                              fontFamily: Constants.inter,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Progress bar section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // Progress label and percentage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress to Target',
                        style: TextStyle(
                          color: Constants.greyedText,
                          fontSize: Constants.smallSize,
                          fontWeight: FontWeight.w700,
                          fontFamily: Constants.inter,
                        ),
                      ),
                      Text(
                        '${(percentage * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: Constants.smallSize,
                          fontWeight: FontWeight.w800,
                          fontFamily: Constants.inter,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  CircularStepProgressIndicator(
                    currentStep: (percentage * 100).round(),
                    totalSteps: 100,
                    selectedColor: Constants.primary,
                    unselectedColor: Colors.grey[200]!,
                    stepSize: 8,
                    padding: 0,
                    width: 150,
                    height: 150,
                    selectedStepSize: 8,
                    roundedCap: (_, __) => true,
                    child: Center(
                      child: Text(
                        '$currentGpa/$targetGpa',
                        style: TextStyle(
                          fontFamily: Constants.inter,
                          fontWeight: FontWeight.w700,
                          fontSize: Constants.mediumSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseTable() {
    final List<Map<String, dynamic>> courses = studentData.courseData;
    final courseLength = courses.length;

    return courses.isNotEmpty
        ? LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: DataTable(
                    border: TableBorder(
                      top: BorderSide(color: Constants.greyedText),
                      bottom: BorderSide(color: Constants.greyedText),
                    ),
                    columnSpacing: 16,
                    horizontalMargin: 16,
                    dividerThickness: 0.0,
                    dataRowColor: WidgetStateProperty<Color?>.fromMap({
                      WidgetState.selected: Constants.appBg,
                    }),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Course Code',
                          style: TextStyle(
                            fontFamily: Constants.inter,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Grade',
                          style: TextStyle(
                            fontFamily: Constants.inter,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Credits',
                          style: TextStyle(
                            fontFamily: Constants.inter,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Grade Points',
                          style: TextStyle(
                            fontFamily: Constants.inter,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      for (int i = 0; i < courseLength; i++)
                        DataRow(
                          cells: [
                            DataCell(
                              Text(
                                courses[i]['courseCode'] ?? 'N/A',
                                style: TextStyle(fontFamily: Constants.inter),
                              ),
                            ),
                            DataCell(
                              Text(
                                grade,
                                style: TextStyle(
                                  fontFamily: Constants.inter,
                                  color: _getGradeColor(grade),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                courses[i]['credits']?.toString() ?? '0',
                                style: TextStyle(fontFamily: Constants.inter),
                              ),
                            ),
                            DataCell(
                              Text(
                                _calculateWeightedAverage(
                                  courses[i]['gradePoints'] as List<dynamic>?,
                                  (courses[i]['credits'] as int?) ?? 0,
                                ).toStringAsFixed(2),
                                style: TextStyle(
                                  fontFamily: Constants.inter,
                                  color: _getGradeColor(grade),
                                  fontWeight: FontWeight.bold,
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
        )
        : Center(
          child: EmptyWidget(
            icon: Constants.bookIcon,
            title: 'No Courses Added',
            subtitle: 'Add a course to get started',
          ),
        );
  }

  Color _getGradeColor(String grade) {
    if (grade.startsWith('A')) return Colors.green.shade700;
    if (grade.startsWith('B')) return Colors.blue.shade700;
    if (grade.startsWith('C')) return Colors.orange.shade700;
    if (grade.startsWith('D')) return Colors.amber.shade700;
    if (grade.startsWith('F') || grade.startsWith('E')) {
      return Colors.red.shade700;
    }
    return Colors.black;
  }

  double _calculateWeightedAverage(List<dynamic>? gradePoints, int credits) {
    if (gradePoints == null || gradePoints.isEmpty || credits == 0) return 0.0;

    // Convert dynamic list to List<double>
    final points = gradePoints.map((e) => (e as num).toDouble()).toList();

    // Calculate average of grade points
    final average = points.reduce((a, b) => a + b) / points.length;

    // Update the grade based on the average
    if (average >= 3.6 && average <= 4.0) {
      grade = 'A';
    } else if (average >= 3.1 && average <= 3.5) {
      grade = 'B+';
    } else if (average >= 2.6 && average <= 3.0) {
      grade = 'B';
    } else if (average >= 2.1 && average <= 2.5) {
      grade = 'C+';
    } else if (average >= 1.6 && average <= 2.0) {
      grade = 'C';
    } else if (average >= 1.1 && average <= 1.5) {
      grade = 'D+';
    } else if (average >= 1.0 && average <= 1.3) {
      grade = 'D';
    } else if (average >= 0.7 && average < 1.0) {
      grade = 'E';
    } else {
      grade = 'F';
    }

    return average;
  }

  Widget _buildTextFields({
    required BuildContext context,
    TextInputType? keyboardType,
    required String hintText,
    required String label,
    void Function(String)? onChange,
    String? initialValue,
    double? width,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      validator: validator,
      controller:
          initialValue != null
              ? TextEditingController(text: initialValue)
              : null,
      decoration: InputDecoration(
        errorStyle: TextStyle(fontFamily: Constants.roboto),
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Constants.greyedText,
          fontFamily: Constants.inter,
          fontWeight: FontWeight.w400,
          fontSize: Constants.smallSize,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: Constants.primary,
          ),
          borderRadius: BorderRadius.circular(Constants.rounded),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      keyboardType: keyboardType,
      onChanged: onChange,
    );
  }

  Widget _buildSubmitButton(String selectedAction, void Function()? onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Constants.primary),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.white),
          Text(
            style: TextStyle(
              fontFamily: Constants.inter,
              fontWeight: FontWeight.w600,
              fontSize: Constants.smallSize,
              color: Colors.white,
            ),
            selectedAction == 'add' ? 'Add Course' : 'Update Course',
          ),
        ],
      ),
    );
  }

  Future<void> _showEditingMenu() async {
    String selectedAction = 'add';
    final List<Map<String, dynamic>> courses = studentData.courseData;
    final courseLength = courses.length;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return SingleChildScrollView(
              child: AlertDialog(
                insetPadding: EdgeInsets.all(5),
                contentPadding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Constants.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Constants.bookIcon, color: Colors.white),
                  ),
                  title: Text(
                    'Manage Courses',
                    style: TextStyle(
                      fontFamily: Constants.inter,
                      fontWeight: FontWeight.w700,
                      fontSize: Constants.mediumSize,
                    ),
                  ),
                  subtitle: Text(
                    'Add or update existing course details.',
                    style: TextStyle(
                      fontFamily: Constants.inter,
                      color: Constants.greyedText,
                      fontWeight: FontWeight.w500,
                      fontSize: Constants.smallSize,
                    ),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add/Edit Toggle
                    GlassContainer(
                      borderRadius: BorderRadius.circular(50),
                      blur: 5,
                      opacity: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChoiceChip(
                              showCheckmark: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              selectedColor: Constants.primary,
                              selected: selectedAction == 'add',
                              onSelected: (value) {
                                setDialogState(() {
                                  selectedAction = 'add';
                                });
                              },
                              label: Row(
                                children: [
                                  Icon(Icons.add, color: Constants.textColor),
                                  Text(
                                    'Add Course',
                                    style: TextStyle(
                                      fontFamily: Constants.inter,
                                      color: Constants.textColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Constants.smallSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              avatarBorder: Border.all(color: Colors.white),
                              showCheckmark: false,
                              selectedColor: Constants.primary,
                              selected: selectedAction == 'edit',
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onSelected: (value) {
                                setDialogState(() {
                                  selectedAction = 'edit';
                                });
                              },
                              label: Row(
                                children: [
                                  Icon(
                                    Constants.bookIcon,
                                    color: Constants.textColor,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'Edit Course',
                                    style: TextStyle(
                                      fontFamily: Constants.inter,
                                      color: Constants.textColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Constants.smallSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Course Details
                    selectedAction == 'add'
                        ? GlassContainer(
                          borderRadius: BorderRadius.circular(12),
                          blur: 25,
                          opacity: 0.1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Form(
                              key: _editFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Course Name *',
                                    style: TextStyle(
                                      fontFamily: Constants.inter,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Constants.smallSize,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: _buildTextFields(
                                      validator: (p0) {
                                        return p0!.isEmpty
                                            ? 'Please enter a course name'
                                            : null;
                                      },
                                      context: context,
                                      hintText: 'Enter course name',
                                      label: 'Course Name',
                                      onChange: (value) {},
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Course Description *',
                                    style: TextStyle(
                                      fontFamily: Constants.inter,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Constants.smallSize,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    validator: (value) {
                                      return value!.isEmpty
                                          ? "Please enter a course description"
                                          : null;
                                    },
                                    textAlign: TextAlign.left,
                                    textAlignVertical: TextAlignVertical.top,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                      label: Text(
                                        "Course Description Here",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          height: 1.5,
                                          color: Constants.greyedText,
                                        ),
                                      ),
                                      alignLabelWithHint: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Course Code *',
                                    style: TextStyle(
                                      fontFamily: Constants.inter,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Constants.smallSize,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: _buildTextFields(
                                      validator: (p0) {
                                        return p0!.isEmpty
                                            ? "Please enter a course code"
                                            : null;
                                      },
                                      context: context,
                                      hintText: 'Enter course code',
                                      label: 'Course Code',
                                      onChange: (value) {},
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Credit Hours *',
                                              style: TextStyle(
                                                fontFamily: Constants.inter,
                                                fontWeight: FontWeight.w600,
                                                fontSize: Constants.smallSize,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            _buildTextFields(
                                              validator: (p0) {
                                                return p0!.isEmpty
                                                    ? "Please enter credit hours"
                                                    : null;
                                              },
                                              context: context,
                                              keyboardType:
                                                  TextInputType.number,
                                              hintText: 'Enter credit hours',
                                              label: 'Credit Hours',
                                              onChange: (value) {},
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Instructor',
                                              style: TextStyle(
                                                fontFamily: Constants.inter,
                                                fontWeight: FontWeight.w600,
                                                fontSize: Constants.smallSize,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            _buildTextFields(
                                              context: context,
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter instructor',
                                              label: 'Instructor',
                                              onChange: (value) {},
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  //button here
                                  _buildSubmitButton(selectedAction, () {
                                    _editFormKey.currentState?.validate() ??
                                        false;
                                  }),
                                ],
                              ),
                            ),
                          ),
                        )
                        : courses.isEmpty
                        ? EmptyWidget(
                          icon: Constants.bookIcon,
                          title: 'No Courses Available',
                          subtitle: 'Add some courses to get started.',
                        )
                        : SizedBox(
                          width: double.infinity,
                          height: 500,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...courses.asMap().entries.map(
                                  (entry) => Dismissible(
                                    key: Key(entry.value['id']),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      padding: const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      return await showDialog<bool>(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Theme.of(
                                                      context,
                                                    ).scaffoldBackgroundColor,
                                                title: ListTile(
                                                  leading: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  title: const Text(
                                                    'Confirm Delete',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          Constants.roboto,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize:
                                                          Constants.smallSize,
                                                    ),
                                                  ),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete this course?',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        Constants.roboto,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize:
                                                        Constants.smallSize,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ??
                                          false;
                                    },
                                    onDismissed: (direction) {
                                      setState(() {
                                        courses.remove(entry.value['id']);
                                      });
                                      // Show a snackbar to undo the deletion
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      color:
                                          Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Theme.of(
                                            context,
                                          ).dividerColor.withValues(alpha: 0.1),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Course Name",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        Constants.roboto,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        Constants.smallSize,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                _buildTextFields(
                                                  context: context,
                                                  hintText: entry.value['name'],
                                                  label: 'Course Name',
                                                  onChange: (value) {},
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Course Code",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              Constants.inter,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              Constants
                                                                  .smallSize,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      _buildTextFields(
                                                        context: context,
                                                        hintText:
                                                            entry
                                                                .value['courseCode'],
                                                        label: 'Course Code',
                                                        width: double.infinity,
                                                        onChange: (value) {},
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Credits",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              Constants.inter,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              Constants
                                                                  .smallSize,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      _buildTextFields(
                                                        context: context,
                                                        hintText:
                                                            entry
                                                                .value['credits']
                                                                .toString(),
                                                        label: 'Credits',
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        width: double.infinity,
                                                        onChange: (value) {},
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Course Description',
                                                  style: TextStyle(
                                                    fontFamily: Constants.inter,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        Constants.smallSize,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                TextField(
                                                  textAlign: TextAlign.left,
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  maxLines: 5,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                          horizontal: 16,
                                                        ),
                                                    hintText:
                                                        entry
                                                            .value['description'] ??
                                                        "Course Description Here",
                                                    hintStyle: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      height: 1.5,
                                                      color:
                                                          Constants.greyedText,
                                                      fontFamily:
                                                          Constants.inter,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          Constants.smallSize,
                                                    ),
                                                    alignLabelWithHint: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Constants.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const SizedBox(height: 16),

                    // Academic Records
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL'),
                  ),
                  FilledButton(
                    onPressed: () {
                      // TODO: Handle save action
                      Navigator.pop(context);
                    },
                    child: Text('SAVE'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Constants.primary),
      label: Text(
        label,
        style: TextStyle(
          color: Constants.primary,
          fontWeight: FontWeight.w600,
          fontFamily: Constants.inter,
        ),
      ),
      backgroundColor: Constants.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Constants.primary, width: 1),
      ),
    );
  }
}
