// Notification data models and sample data
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final String sender;
  final String? avatarUrl;
  bool isRead;
  final String? category; // e.g., system, quiz, reminder

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.sender,
    this.avatarUrl,
    this.isRead = false,
    this.category,
  });
}

class NotificationsData {
  // Seed sample notifications
  final List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      title: 'Quiz Results Available',
      body:
          'Your results for "Biochemistry - Week 3 Quiz" are now available. Tap to review your performance and feedback.',
      receivedAt: DateTime.now().subtract(const Duration(minutes: 12)),
      sender: 'Glauk Exams',
      avatarUrl:
          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=200&h=200&fit=crop',
      isRead: false,
      category: 'quiz',
    ),
    AppNotification(
      id: 'n2',
      title: 'New Study Slide Added',
      body:
          'A new slide has been added to Pharmacology: "Autonomic Nervous System Overview". Start revising now.',
      receivedAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 8)),
      sender: 'Course Updates',
      avatarUrl:
          'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=200&h=200&fit=crop',
      isRead: true,
      category: 'system',
    ),
    AppNotification(
      id: 'n3',
      title: 'Reminder: Practice Quiz',
      body:
          'Don’t forget your daily practice quiz for Pathology. Consistency drives mastery. Tap to begin.',
      receivedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      sender: 'Glauk Coach',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop',
      isRead: false,
      category: 'reminder',
    ),
    AppNotification(
      id: 'n4',
      title: 'Streak Milestone',
      body:
          'Amazing! You just hit a 7-day learning streak. Keep up the momentum and earn bonus XP.',
      receivedAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      sender: 'Glauk Rewards',
      avatarUrl:
          'https://images.unsplash.com/photo-1541532713592-79a0317b6b77?w=200&h=200&fit=crop',
      isRead: true,
      category: 'reward',
    ),
  ];

  List<AppNotification> getAll() => List<AppNotification>.from(notifications);

  void markAsRead(String id) {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1) notifications[idx].isRead = true;
  }

  void markAllAsRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
  }

  void deleteById(String id) {
    notifications.removeWhere((n) => n.id == id);
  }
}
