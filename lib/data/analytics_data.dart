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
}
