import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glauk/components/auth/auth_form.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:glauk/data/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int numberOfQuizzes = 10;
  double averageScore = 87.5;
  int rank = 5;
  final UserData userData = UserData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: Column(
                children: [
                  _buildProfileCard(),
                  _buildSettingsCard(),
                  _buildLogoutCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final userName = userData.userData['name'] ?? "";
    final userEmail = userData.userData['email'] ?? "";
    final userLevel = userData.userData['level'] ?? "";
    final userXP = userData.userData['xp'] ?? 0;
    final userTotalXP = userData.userData['totalXP'] ?? 0;
    final userCurrentNumberOfQuestions =
        userData.userData['currentNumberOfQuestions'] ?? 0;
    final userAverageScore = userData.userData['averageScore'] ?? 0.0;
    final userProfileImage = userData.userData['profileImage'] ?? "";
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle),

                child: CachedNetworkImage(
                  imageUrl: userProfileImage,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) =>
                          const Icon(Icons.person, color: Constants.primary),
                ),
              ),
              Column(
                children: [Text(userName), Text(userEmail), Text(userLevel)],
              ),
            ],
          ),

          //
          Row(
            children: [
              _buildStatsDisplay(
                Constants.bookIcon,
                'Quizzes',
                numberOfQuizzes.toString(),
              ),
              _buildStatsDisplay(
                Icons.trending_up,
                'Avg. Score',
                averageScore.toString(),
              ),
              _buildStatsDisplay(Icons.person, 'Rank', rank.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await _showEditProfileOptions(context);
            },
            child: _buildSettingsItem(
              Icons.person,
              'Edit Profile',
              'Update your personal information',
            ),
          ),
          GestureDetector(
            onTap: () async {
              await _showEditPasswordOptions(context);
            },
            child: _buildSettingsItem(
              Icons.lock,
              'Change Password',
              'Update your password',
            ),
          ),
          GestureDetector(
            onTap: () async {
              await _showSettingsOptions();
            },
            child: _buildSettingsItem(
              Icons.settings,
              'Settings',
              'Manage your account settings',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard() {
    return ElevatedButton(
      onPressed: () {},
      child: Row(children: [Icon(Icons.logout), Text('Logout')]),
    );
  }

  Widget _buildStatsDisplay(IconData icon, String title, String value) {
    return Container(
      child: Column(
        children: [Container(child: Icon(icon)), Text(title), Text(value)],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subTitle) {
    return Row(
      children: [
        Icon(icon),
        Column(children: [Text(title), Text(subTitle)]),
        Icon(Icons.arrow_forward_ios),
      ],
    );
  }

  Future<dynamic> _showEditProfileOptions(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            children: [
              Column(
                children: [
                  Text('Full Name'),
                  AuthForm(
                    hintText: userData.userData['name'],
                    maxLines: 1,
                    onChanged: (value) {},
                    validator: (value) {},
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Email'),
                  AuthForm(
                    hintText: userData.userData['email'],
                    maxLines: 1,
                    onChanged: (value) {},
                    validator: (value) {},
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Phone Number'),
                  AuthForm(
                    hintText: userData.userData['phone'],
                    maxLines: 1,
                    onChanged: (value) {},
                    validator: (value) {},
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Target GPA'),
                  AuthForm(
                    hintText: userData.userData['targetGPA'].toString(),
                    maxLines: 1,
                    onChanged: (value) {},
                    validator: (value) {},
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Major'),
                  AuthForm(
                    hintText: userData.userData['major'],
                    maxLines: 1,
                    onChanged: (value) {},
                    validator: (value) {},
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showEditPasswordOptions(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Password'),
          content: Column(
            children: [
              Column(
                children: [
                  Text('Current Password'),
                  AuthForm(
                    hintText: 'Current Password',
                    maxLines: 1,
                    onChanged: (value) {},
                    validator: (value) {},
                    keyboardType: TextInputType.visiblePassword,
                    isTextObscured: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Text('New Password'),
                  AuthForm(
                    hintText: 'New Password',
                    maxLines: 1,
                    onChanged: (value) {},
                    validator: (value) {},
                    keyboardType: TextInputType.visiblePassword,
                    isTextObscured: true,
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Confirm New Password'),
                  AuthForm(
                    hintText: 'Confirm New Password',
                    maxLines: 1,
                    onChanged: (value) {},
                    validator: (value) {},
                    keyboardType: TextInputType.visiblePassword,
                    isTextObscured: true,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showSettingsOptions() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Your App Preferences'),
          content: Column(
            children: [
              _buildPreferenceItem(
                'Email Notifications',
                'Receive updates via email',
                true,
                (value) {},
              ),
              _buildPreferenceItem(
                'Push Notifications',
                'Receive updates via push notifications',
                true,
                (value) {},
              ),
              _buildPreferenceItem(
                'Quiz Reminders',
                'Get reminded about quizzes',
                true,
                (value) {},
              ),
              _buildPreferenceItem(
                'Leaderboard Updates',
                'Get reminded about leaderboard updates',
                true,
                (value) {},
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPreferenceItem(
    String title,
    String subTitle,
    bool defaultValue,
    void Function(bool)? onChanged,
  ) {
    return Row(
      children: [
        Column(children: [Text(title), Text(subTitle)]),
        Switch(value: defaultValue, onChanged: onChanged),
      ],
    );
  }
}
