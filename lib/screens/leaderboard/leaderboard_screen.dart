import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:glauk/data/analytics_data.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final AnalyticsData analytics = AnalyticsData();
  final String currentUserId = 'u3'; // dummy logged-in user id

  @override
  Widget build(BuildContext context) {
    final topStreaks = analytics.getTopStreaks(limit: 5);
    final topScorers = analytics.getTopScorers(limit: 5);
    final mostSlides = analytics.getMostSlidesCompleted(limit: 5);
    final me = analytics.findUser(currentUserId);

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: RefreshIndicator(
        color: Constants.primary,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryStats(
                totalStudents: analytics.totalStudents,
                totalSlides: analytics.totalCourseSlides,
                totalQuizzes: analytics.totalQuizzesTaken,
              ),
              const SizedBox(height: 16),
              _Section(
                icon: Icons.whatshot_sharp,
                title: 'Top Streaks',
                child: _RankedList(
                  items: topStreaks,
                  primaryValueKey: 'longestStreak',
                  secondaryLabelBuilder:
                      (u) => 'Current: ${u['currentStreak']}d',
                  valueSuffix: 'd',
                ),
              ),
              const SizedBox(height: 16),
              if (me != null)
                _Section(
                  icon: Icons.whatshot_outlined,
                  title: 'Your Streak',
                  child: _MyStatCard(
                    name: me['name'],
                    current: me['currentStreak'],
                    longest: me['longestStreak'],
                  ),
                ),
              const SizedBox(height: 16),
              _Section(
                icon: Icons.quiz,
                title: 'Top Scorers (Avg %)',
                child: _RankedList(
                  items: topScorers,
                  primaryValueKey: 'avgScore',
                  valueSuffix: '%',
                  secondaryLabelBuilder: (u) => '${u['quizzesTaken']} quizzes',
                ),
              ),
              const SizedBox(height: 16),
              _Section(
                icon: Icons.slideshow,
                title: 'Most Slides Completed',
                child: _RankedList(
                  items: mostSlides,
                  primaryValueKey: 'slidesCompleted',
                  valueSuffix: '',
                  secondaryLabelBuilder: (u) => '${u['totalPoints']} pts',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryStats extends StatelessWidget {
  final int totalStudents;
  final int totalSlides;
  final int totalQuizzes;

  const _SummaryStats({
    required this.totalStudents,
    required this.totalSlides,
    required this.totalQuizzes,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget card({
      required IconData icon,
      required String label,
      required String value,
      Color? color,
    }) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                color?.withValues(alpha: 0.08) ??
                colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (color ?? Constants.primary).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: (color ?? Constants.primary).withValues(
                  alpha: 0.12,
                ),
                child: Icon(icon, color: color ?? Constants.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Constants.chartArrow, color: Constants.primary),
            SizedBox(width: 5),
            Text(
              'Summary',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            card(
              icon: Icons.people,
              label: 'Students',
              value: '$totalStudents',
            ),
            const SizedBox(width: 12),
            card(
              icon: Icons.slideshow,
              label: 'Course Slides',
              value: '$totalSlides',
              color: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            card(
              icon: Icons.quiz,
              label: 'Quizzes Taken',
              value: '$totalQuizzes',
              color: Colors.teal,
            ),
            const SizedBox(width: 12),
            card(
              icon: Icons.emoji_events,
              label: 'Active Streaks (Top 5)',
              value: '↑',
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData icon;
  const _Section({
    required this.title,
    required this.child,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Constants.primary),
            SizedBox(width: 5),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _RankedList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String primaryValueKey;
  final String valueSuffix;
  final String Function(Map<String, dynamic>)? secondaryLabelBuilder;

  const _RankedList({
    required this.items,
    required this.primaryValueKey,
    required this.valueSuffix,
    this.secondaryLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final u = items[index];
        final rank = index + 1;
        final name = u['name'] as String? ?? 'Student';
        final value = u[primaryValueKey];
        final secondary = secondaryLabelBuilder?.call(u);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              _RankBadge(rank: rank),
              const SizedBox(width: 12),
              CircleAvatar(child: Text(_initials(name))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium),
                    if (secondary != null)
                      Text(
                        secondary,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Text(
                '$value$valueSuffix',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].isNotEmpty ? parts[0][0] : '') +
        (parts[1].isNotEmpty ? parts[1][0] : '');
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (rank) {
      case 1:
        color = const Color(0xFFFFD700); // gold
        break;
      case 2:
        color = const Color(0xFFC0C0C0); // silver
        break;
      case 3:
        color = const Color(0xFFCD7F32); // bronze
        break;
      default:
        color = Constants.primary.withAlpha(70);
    }
    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.3),
      child: Text('$rank'),
    );
  }
}

class _MyStatCard extends StatelessWidget {
  final String name;
  final int current;
  final int longest;
  const _MyStatCard({
    required this.name,
    required this.current,
    required this.longest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          CircleAvatar(child: Text(_RankedList._initials(name))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text('Current: ${current}d  •  Longest: ${longest}d'),
              ],
            ),
          ),
          const Icon(Icons.local_fire_department, color: Colors.orange),
        ],
      ),
    );
  }
}
