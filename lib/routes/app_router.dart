import 'package:flutter/material.dart';
import 'package:glauk/routes/student_routes.dart';
import 'package:glauk/screens/analytics/analytics_screen.dart';
import 'package:glauk/screens/auth/login_screen.dart';
import 'package:glauk/screens/auth/register_screen.dart';
import 'package:glauk/screens/notifications/notifications_screen.dart';
import 'package:glauk/screens/profile/profile_screen.dart';
import 'package:glauk/screens/quiz/quiz_results_screen.dart';
import 'package:glauk/screens/quiz/quiz_review_screen.dart';
import 'package:glauk/screens/quiz/student_quiz_screen.dart';
import 'package:glauk/screens/performance/student_progress.dart';
import 'package:glauk/screens/onboarding/onboarding_screen.dart';
import 'package:glauk/screens/quiz/take_quiz_screen.dart';
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
      path: '/notifications',
      pageBuilder:
          (context, state) => CustomTransitionPage(
            child: NotificationsScreen(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ),
                ),
                child: child,
              );
            },
          ),
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
    GoRoute(
      path: '/take-quiz',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return TakeQuizScreen(questions: args['questions']);
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
              pageBuilder:
                  (context, state) => CustomTransitionPage(
                    child: StudentProgress(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
            ),
          ],
        ),
        // Quiz Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student-quiz',
              pageBuilder:
                  (context, state) => CustomTransitionPage(
                    child: StudentQuizScreen(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
            ),
          ],
        ),
        // Analytics Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student-analytics',
              pageBuilder:
                  (context, state) => CustomTransitionPage(
                    child: AnalyticsScreen(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
            ),
          ],
        ),
        // Deck Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student-profile',
              pageBuilder:
                  (context, state) => CustomTransitionPage(
                    child: ProfileScreen(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
            ),
          ],
        ),
      ],
    ),
  ],
);
