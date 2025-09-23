import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';

class UploadOnboardingScreen extends StatefulWidget {
  const UploadOnboardingScreen({super.key});

  @override
  State<UploadOnboardingScreen> createState() => _UploadOnboardingScreenState();
}

class _UploadOnboardingScreenState extends State<UploadOnboardingScreen> {
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Constants.primary,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "lib/assets/images/upload-file.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Smart Content Upload",
                    style: TextStyle(
                      fontFamily: Constants.inter,
                      fontSize: Constants.mediumSize,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Constants.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Center(
                          child: Text(
                            "Accepted File Formats",
                            style: TextStyle(
                              fontFamily: Constants.inter,
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSelectedFormats(
                              Icons.format_size,

                              "PDF Formats",
                            ),
                            const SizedBox(width: 32),
                            _buildSelectedFormats(
                              Icons.format_size,
                              "PPTX Formats",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    textAlign: TextAlign.center,
                    "Upload your class slides, lecture notes, or textbook pages. Our AI will analyze and understand your content instantly.",
                    style: TextStyle(
                      fontFamily: Constants.inter,
                      fontSize: Constants.smallSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAppCore(
                    Icons.upload,
                    "Upload files.",
                    "From your notes & textbooks.",
                  ),
                  _buildAppCore(
                    Icons.auto_awesome,
                    "Generate examinable questions.",
                    "From your uploaded content.",
                  ),
                  _buildAppCore(
                    Icons.quiz_outlined,
                    "Take quizzes.",
                    "From generated questions.",
                  ),
                  _buildAppCore(
                    Icons.format_size,
                    "Get real-time scores and insights.",
                    "A reflection of quiz performance.",
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

  Widget _buildSelectedFormats(IconData icon, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Constants.primary),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: Constants.inter,
          ),
        ),
      ],
    );
  }
}
