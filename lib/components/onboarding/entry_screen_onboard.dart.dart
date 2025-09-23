import 'package:flutter/material.dart';
import 'package:glauk/core/constants/constants.dart';

class EntryScreenOnboard extends StatefulWidget {
  const EntryScreenOnboard({super.key});

  @override
  State<EntryScreenOnboard> createState() => _EntryScreenOnboardState();
}

class _EntryScreenOnboardState extends State<EntryScreenOnboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Group Study Image
                Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                      image: AssetImage('lib/assets/images/study-group.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),

                Text(
                  " Study Groups",
                  style: TextStyle(
                    fontSize: Constants.mediumSize,
                    fontWeight: FontWeight.w900,
                    fontFamily: Constants.inter,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                _buildFeatureTile(
                  icon: Icons.group_add,
                  title: "Join Study Groups",
                  subtitle: "Connect with peers in your courses",
                ),
                _buildFeatureTile(
                  icon: Icons.forum,
                  title: "Ask Questions",
                  subtitle: "Get help from your study group",
                ),
                _buildFeatureTile(
                  icon: Icons.share,
                  title: "Share Resources",
                  subtitle: "Exchange notes and materials",
                ),
                _buildFeatureTile(
                  icon: Icons.event_note,
                  title: "Group Study Sessions",
                  subtitle: "Schedule and join study sessions",
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Constants.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Constants.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: Constants.smallSize,
          fontFamily: Constants.inter,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: Constants.smallSize,
          fontFamily: Constants.inter,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
