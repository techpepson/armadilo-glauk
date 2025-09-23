import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "lib/assets/images/glauk-logo-removebg-preview.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome to Glauk",
                    style: TextStyle(
                      fontFamily: Constants.inter,
                      fontSize: Constants.mediumSize,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    textAlign: TextAlign.center,
                    "Transform your study materials into personalized quizzes and track your academic progress with AI-powered insights.",
                    style: TextStyle(
                      fontFamily: Constants.inter,
                      fontSize: Constants.smallSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAppCore(
                    Icons.auto_awesome,
                    "AI-Generated Quizzes",
                    "From your notes & textbooks.",
                  ),
                  _buildAppCore(
                    Icons.track_changes_outlined,
                    "Smart Progress Tracking",
                    "GPA Predictions and Insights.",
                  ),
                  _buildAppCore(
                    Icons.group_add_outlined,
                    "Group Activities",
                    "Collaborate with peers.",
                  ),
                  _buildAppCore(
                    Icons.exposure_outlined,
                    "Exams",
                    "Track your exam performance.",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppCore(IconData icon, String title, String description) {
    return ListTile(
      leading: Icon(icon, color: Constants.primary),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: Constants.inter,
          fontSize: Constants.smallSize,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          fontFamily: Constants.inter,
          fontSize: Constants.smallSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
