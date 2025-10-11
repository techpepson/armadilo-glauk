import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:glauk/screens/analytics/analytics_tab.dart';
import 'package:glauk/screens/leaderboard/leaderboard_screen.dart';

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
            title: const Text(
              'Analytics',
              style: TextStyle(
                fontSize: Constants.mediumSize,
                fontWeight: FontWeight.w400,
                fontFamily: Constants.inter,
              ),
            ),
            bottom: TabBar(
              physics: BouncingScrollPhysics(),
              indicatorColor: Constants.primary.withAlpha(70),
              labelColor: Constants.primary,
              unselectedLabelColor: Constants.textColor,
              indicatorAnimation: TabIndicatorAnimation.elastic,

              tabs: [
                Tab(
                  child: Text(
                    'Analytics',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: Constants.textColor,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Leaderboard',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: Constants.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [AnalyticsTab(), LeaderboardScreen()]),
        ),
      ),
    );
  }
}
