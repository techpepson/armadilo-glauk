import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glauk/components/auth/auth_form.dart';
import 'package:glauk/core/constants/constants.dart';
import 'dart:developer' as dev;

import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  @override
  dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    //mimic loading or sending state
    setState(() {
      isSubmitting = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isSubmitting = false;
    });

    //navigate to onboarding screen
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Title Section
                      SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Constants.glaukImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),

                            const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Glauk",
                                  style: TextStyle(
                                    fontSize: Constants.largeSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Academic Hub",
                                  style: TextStyle(
                                    fontSize: Constants.smallSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Welcome Text
                      const Column(
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: Constants.mediumSize,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Log in to continue your learning journey',
                            style: TextStyle(
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Email Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: Constants.smallSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthForm(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Constants.greyedText,
                        ),
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (value) =>
                                value == null || !value.contains('@')
                                    ? 'Enter a valid email'
                                    : null,
                        onChanged: (value) {},
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: Constants.smallSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthForm(
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          color: Constants.greyedText,
                        ),
                        hintText: 'Enter your password',
                        suffixIcon: const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Constants.greyedText,
                        ),
                        isTextObscured: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator:
                            (value) =>
                                value == null || value.length < 8
                                    ? 'Password must be at least 8 characters long'
                                    : null,
                        onChanged: (value) {},
                      ),

                      const SizedBox(height: 15),

                      // Remember me and Forgot Password
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                rememberMe = value ?? false;
                                dev.log(rememberMe.toString());
                              });
                            },
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: Constants.smallSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              dev.log('Validated');
                              await handleSubmit();
                            }
                          },
                          child:
                              isSubmitting
                                  ? CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                  : Text(
                                    'Log In',
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      fontSize: Constants.smallSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Divider with "or" text
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              'Or',
                              style: TextStyle(
                                fontSize: Constants.smallSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Google Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Constants.googleImage,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Log In with Google',
                                style: TextStyle(
                                  fontSize: Constants.smallSize,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to sign up screen
                              context.go('/register');
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: Constants.smallSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
