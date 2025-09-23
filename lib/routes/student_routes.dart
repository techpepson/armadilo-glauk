import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentRoutes extends StatefulWidget {
  const StudentRoutes({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;
  @override
  State<StudentRoutes> createState() => _StudentRoutesState();
}

class _StudentRoutesState extends State<StudentRoutes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        animationDuration: Duration(seconds: 2),
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(index, initialLocation: true);
        },
        backgroundColor: Colors.transparent,
        indicatorColor: Theme.of(context).colorScheme.primary,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            label: 'Performance',
          ),
          NavigationDestination(icon: Icon(Icons.quiz_outlined), label: 'Quiz'),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            label: 'Exams',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
