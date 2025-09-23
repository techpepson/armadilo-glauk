import 'package:flutter/material.dart';
import 'package:glauk/components/onboarding/intro_screen.dart';
import 'package:glauk/components/onboarding/entry_screen_onboard.dart.dart';
import 'package:glauk/components/onboarding/upload_onboarding_screen.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3; // Total number of onboarding screens

  final List<Widget> _screens = [
    const IntroScreen(),
    const UploadOnboardingScreen(),
    const EntryScreenOnboard(),
  ];

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to student-exams on the last page
      context.go('/student-performance');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for onboarding screens
          PageView.builder(
            controller: _pageController,
            itemCount: _screens.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) => _screens[index],
          ),

          // Navigation controls
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button (hidden on first page)
                if (_currentPage > 0)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: _previousPage,
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: Constants.smallSize,
                        fontFamily: Constants.inter,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 80), // Placeholder for alignment
                // Page indicator
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    _totalPages,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                      ),
                    ),
                  ),
                ),

                // Next/Enter App button
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? 'Enter App' : 'Next',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: Constants.smallSize,
                      fontFamily: Constants.inter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
