import 'package:flutter/material.dart';
import 'package:glauk/screens/analytics/analytics_tab.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Analytics'),
            bottom: const TabBar(
              tabs: [Tab(text: 'Analytics'), Tab(text: 'Leaderboard')],
            ),
          ),
          body: const TabBarView(
            children: [AnalyticsTab(), Center(child: Text('Performance'))],
          ),
        ),
      ),
    );
  }
}
