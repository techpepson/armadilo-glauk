import 'package:flutter/material.dart';
import 'package:glauk/routes/student_routes.dart';
import 'package:glauk/screens/auth/login_screen.dart';
import 'package:glauk/screens/auth/register_screen.dart';
import 'package:glauk/screens/quiz/quiz_results_screen.dart';
import 'package:glauk/screens/quiz/quiz_review_screen.dart';
import 'package:glauk/screens/quiz/student_quiz_screen.dart';
import 'package:glauk/screens/performance/student_progress.dart';
import 'package:glauk/screens/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/quiz-review',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return QuizReviewScreen(
          courseSlides: args['course'],
          courseDisplayImage: args['displayImage'],
        );
      },
    ),
    GoRoute(
      path: '/quiz-results',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return QuizResultsScreen(
          courseSlides: args['course'],
          courseDisplayImage: args['displayImage'],
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return StudentRoutes(navigationShell: navigationShell);
      },
      branches: [
        // Exams Branch
        StatefulShellBranch(
          initialLocation: '/student-performance',
          routes: [
            GoRoute(
              path: '/student-performance',
              builder:
                  (context, state) => FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) => const StudentProgress(),
                  ),
            ),
          ],
        ),
        // Quiz Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student-quiz',
              builder:
                  (context, state) => FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) => const StudentQuizScreen(),
                  ),
            ),
          ],
        ),
        // Groups Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student-groups',
              builder:
                  (context, state) => FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) => const Placeholder(),
                  ),
            ),
          ],
        ),
        // Analytics Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student-analytics',
              builder:
                  (context, state) => FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) => const Placeholder(),
                  ),
            ),
          ],
        ),
        // Deck Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student-deck',
              builder:
                  (context, state) => FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) => const Placeholder(),
                  ),
            ),
          ],
        ),
      ],
    ),
  ],
);
