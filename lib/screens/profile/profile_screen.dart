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
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: Constants.mediumSize,
            fontWeight: FontWeight.w400,
            fontFamily: Constants.inter,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildProfileCard(),
                      SizedBox(height: 24),
                      _buildSettingsCard(),
                      SizedBox(height: 40),
                      _buildLogoutCard(),
                    ],
                  ),
                ),
              );
            },
          ),
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
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset.fromDirection(1.0),
            blurRadius: 5.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            spacing: 15.0,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0,
                    color: Colors.white,
                    style: BorderStyle.solid,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 1.0,
                      spreadRadius: 10.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    imageUrl: userProfileImage,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.person, color: Constants.primary),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: Constants.mediumSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    userEmail,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constants.greyedText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.workspace_premium, color: Constants.primary),
                      Text(
                        userLevel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Constants.greyedText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          //vertical spacing
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatsDisplay(
                Constants.bookIcon,
                'Quizzes',
                numberOfQuizzes.toString(),
              ),
              _buildStatsDisplay(
                Icons.trending_up,
                'Avg. Score',
                '${averageScore.toString()} %',
              ),
              _buildStatsDisplay(
                Icons.emoji_events_outlined,
                'Rank',
                rank.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      child: Column(
        spacing: 20.0,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: Constants.mediumSize,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) async {
              await _showEditProfileOptions(context);
            },
            child: _buildSettingsItem(
              Icons.person,
              'Edit Profile',
              'Update your personal information',
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) async {
              await _showEditPasswordOptions(context);
            },
            child: _buildSettingsItem(
              Icons.lock,
              'Change Password',
              'Update your password',
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) async {
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
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Constants.error, width: 1.0),
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Constants.error, size: 24),
            SizedBox(width: 24),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 23,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsDisplay(IconData icon, String title, String value) {
    return Column(
      spacing: 5,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Constants.primary.withAlpha(70),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Constants.primary),
        ),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Constants.greyedText),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: Constants.mediumSize,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subTitle) {
    return Row(
      spacing: 15.0,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Constants.primary.withAlpha(70),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Icon(icon, color: Constants.primary),
        ),

        Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              subTitle,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Spacer(),
        Icon(Icons.arrow_forward_ios, color: Constants.greyedText),
        SizedBox(width: 12),
      ],
    );
  }

  Future<dynamic> _showEditProfileOptions(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              constraints: BoxConstraints.expand(width: 500, height: 700),
              insetPadding: EdgeInsets.all(1),
              contentPadding: EdgeInsets.all(20),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  Text(
                    'Update your personal information',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.appBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 18,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Target GPA',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Major',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Constants.appBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Constants.textColor),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Constants.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<dynamic> _showEditPasswordOptions(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              constraints: BoxConstraints.expand(width: 500, height: 500),
              insetPadding: EdgeInsets.all(1),
              contentPadding: EdgeInsets.all(20),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Password',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  Text(
                    'Update your password information',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.appBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 18,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Password',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm New Password',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

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
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Constants.appBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Constants.textColor),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Constants.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<dynamic> _showSettingsOptions() {
    bool emailValue = true;
    bool pushValue = true;
    bool quizReminderValue = true;
    bool leaderboardValue = true;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              constraints: BoxConstraints.expand(width: 500, height: 400),
              insetPadding: EdgeInsets.all(1),
              contentPadding: EdgeInsets.all(20),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Your App Preferences',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Manage your account settings',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPreferenceItem(
                    'Email Notifications',
                    'Receive updates via email',
                    emailValue,
                    (value) {
                      setState(() => emailValue = value);
                    },
                  ),
                  _buildPreferenceItem(
                    'Push Notifications',
                    'Receive updates via push notifications',
                    pushValue,
                    (value) {
                      setState(() => pushValue = value);
                    },
                  ),
                  _buildPreferenceItem(
                    'Quiz Reminders',
                    'Get reminded about quizzes',
                    quizReminderValue,
                    (value) {
                      setState(() => quizReminderValue = value);
                    },
                  ),
                  _buildPreferenceItem(
                    'Leaderboard Updates',
                    'Get reminded about leaderboard updates',
                    leaderboardValue,
                    (value) {
                      setState(() => leaderboardValue = value);
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Constants.appBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Constants.textColor),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Constants.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subTitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Switch(
          value: defaultValue,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: Constants.primary,
          inactiveTrackColor: Constants.greyedText,
          inactiveThumbColor: Colors.white,
        ),
      ],
    );
  }
}
