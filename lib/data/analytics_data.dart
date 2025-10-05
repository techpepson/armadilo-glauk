import 'course_data.dart';

class AnalyticsData {
  //in the database, a gpa should be a model on its own with a collection of scores
  final List<Map<String, dynamic>> gpaData = [
    {'uploadDate': '2025-08-22', 'gpa': 4.0},
    {'uploadDate': '2025-07-23', 'gpa': 3.5},
    {'uploadDate': '2024-06-24', 'gpa': 3.0},
    {'uploadDate': '2024-05-25', 'gpa': 2.5},
    {'uploadDate': '2022-04-26', 'gpa': 2.0},
    {'uploadDate': '2025-09-27', 'gpa': 1.5},
    {'uploadDate': '2025-09-28', 'gpa': 1.0},
    {'uploadDate': '2025-02-29', 'gpa': 0.5},
    {'uploadDate': '2025-01-30', 'gpa': 0.0},
    {'uploadDate': '2025-03-30', 'gpa': 4.0},
    {'uploadDate': '2025-04-30', 'gpa': 4.0},
    {'uploadDate': '2025-10-30', 'gpa': 8.0},
    {'uploadDate': '2025-11-30', 'gpa': 8.0},
    {'uploadDate': '2025-12-30', 'gpa': 8.0},
  ];

  //in the database, scores should have their own model
  final List<Map<String, dynamic>> scoresData = [
    {'uploadDate': '2025-10-22', 'score': 90.0},
    {'uploadDate': '2025-07-23', 'score': 85.0},
    {'uploadDate': '2024-06-24', 'score': 80.0},
    {'uploadDate': '2025-10-04', 'score': 75.0},
    {'uploadDate': '2025-10-04', 'score': 70.0},
    {'uploadDate': '2025-09-27', 'score': 65.0},
    {'uploadDate': '2025-09-28', 'score': 60.0},
    {'uploadDate': '2025-02-29', 'score': 55.0},
    {'uploadDate': '2025-01-30', 'score': 50.0},
    {'uploadDate': '2025-03-30', 'score': 45.0},
    {'uploadDate': '2025-04-30', 'score': 40.0},
    {'uploadDate': '2025-10-30', 'score': 35.0},
    {'uploadDate': '2025-09-02', 'score': 30.0},
    {'uploadDate': '2025-09-03', 'score': 25.0},
  ];

  Map<String, dynamic> streakData = {
    'lastActiveData': '2025-10-30',
    'currentStreak': 0,
    'longestStreak': 0,
  };

  Map<String, dynamic> weeklyGoals = {'currentProgressiveDays': 4};

  // ===== Leaderboard dummy users and helpers =====
  // Dummy users across the platform
  final List<Map<String, dynamic>> users = [
    {
      'id': 'u1',
      'name': 'Ama Boateng',
      'avatar': null,
      'currentStreak': 7,
      'longestStreak': 21,
      'avgScore': 92.5,
      'quizzesTaken': 18,
      'slidesCompleted': 35,
      'totalPoints': 1250,
    },
    {
      'id': 'u2',
      'name': 'Kwesi Mensah',
      'avatar': null,
      'currentStreak': 5,
      'longestStreak': 18,
      'avgScore': 88.0,
      'quizzesTaken': 22,
      'slidesCompleted': 40,
      'totalPoints': 1320,
    },
    {
      'id': 'u3',
      'name': 'Nana Yaa',
      'avatar': null,
      'currentStreak': 10,
      'longestStreak': 27,
      'avgScore': 95.2,
      'quizzesTaken': 30,
      'slidesCompleted': 52,
      'totalPoints': 1810,
    },
    {
      'id': 'u4',
      'name': 'Kofi Adjei',
      'avatar': null,
      'currentStreak': 3,
      'longestStreak': 12,
      'avgScore': 73.4,
      'quizzesTaken': 11,
      'slidesCompleted': 19,
      'totalPoints': 640,
    },
    {
      'id': 'u5',
      'name': 'Afua Serwaa',
      'avatar': null,
      'currentStreak': 14,
      'longestStreak': 29,
      'avgScore': 89.9,
      'quizzesTaken': 28,
      'slidesCompleted': 48,
      'totalPoints': 1700,
    },
    {
      'id': 'u6',
      'name': 'Yaw Owusu',
      'avatar': null,
      'currentStreak': 2,
      'longestStreak': 9,
      'avgScore': 67.0,
      'quizzesTaken': 8,
      'slidesCompleted': 12,
      'totalPoints': 310,
    },
    {
      'id': 'u7',
      'name': 'Esi Baah',
      'avatar': null,
      'currentStreak': 9,
      'longestStreak': 24,
      'avgScore': 91.0,
      'quizzesTaken': 24,
      'slidesCompleted': 43,
      'totalPoints': 1505,
    },
    {
      'id': 'u8',
      'name': 'Kojo Asante',
      'avatar': null,
      'currentStreak': 1,
      'longestStreak': 6,
      'avgScore': 58.6,
      'quizzesTaken': 5,
      'slidesCompleted': 7,
      'totalPoints': 150,
    },
  ];

  // Platform totals
  int get totalStudents => users.length;
  int get totalCourseSlides => CourseData().courseSlides.length;
  int get totalQuizzesTaken => scoresData.length;

  // Retrieve a user by id
  Map<String, dynamic>? findUser(String id) {
    try {
      return users.firstWhere((u) => u['id'] == id);
    } catch (_) {
      return null;
    }
  }

  // Top N by longest streak (desc), tie-break by current streak
  List<Map<String, dynamic>> getTopStreaks({int limit = 5}) {
    final data = List<Map<String, dynamic>>.from(users);
    data.sort((a, b) {
      final ls = (b['longestStreak'] as num).compareTo(
        a['longestStreak'] as num,
      );
      if (ls != 0) return ls;
      return (b['currentStreak'] as num).compareTo(a['currentStreak'] as num);
    });
    return data.take(limit).toList();
  }

  // Top N by average score (desc)
  List<Map<String, dynamic>> getTopScorers({int limit = 5}) {
    final data = List<Map<String, dynamic>>.from(users);
    data.sort((a, b) => (b['avgScore'] as num).compareTo(a['avgScore'] as num));
    return data.take(limit).toList();
  }

  // Additional leaderboard: Most slides completed
  List<Map<String, dynamic>> getMostSlidesCompleted({int limit = 5}) {
    final data = List<Map<String, dynamic>>.from(users);
    data.sort(
      (a, b) =>
          (b['slidesCompleted'] as num).compareTo(a['slidesCompleted'] as num),
    );
    return data.take(limit).toList();
  }
}
