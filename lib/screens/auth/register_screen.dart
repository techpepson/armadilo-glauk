import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glauk/components/auth/auth_form.dart';
import 'package:glauk/core/constants/constants.dart';
import 'dart:developer' as dev;

import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool rememberMe = false;
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  @override
  dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  //submit function
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
                        height: 70,
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

                      // Create an account text
                      const Column(
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: Constants.mediumSize,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            textAlign: TextAlign.center,
                            'Join thousands of students improving their academic performance',
                            style: TextStyle(
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Full Name Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: Constants.smallSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      AuthForm(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Constants.greyedText,
                        ),
                        hintText: 'Enter your full name',
                        keyboardType: TextInputType.name,
                        validator:
                            (value) =>
                                value == null ? 'Enter your full name' : null,
                        onChanged: (value) {},
                      ),

                      const SizedBox(height: 20),

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
                        isTextObscured: true,
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (value) =>
                                value == null || !value.contains('@')
                                    ? 'Enter a valid email'
                                    : null,
                        onChanged: (value) {},
                      ),

                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: Constants.smallSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AuthForm(
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Constants.greyedText,
                        ),
                        hintText: '+233 123456789',
                        isTextObscured: true,
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) =>
                                value == null || value.length > 15
                                    ? 'Enter a valid phone number'
                                    : null,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 20),

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
                        isTextObscured: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator:
                            (value) =>
                                value == null || value.length < 8
                                    ? 'Password must be at least 8 characters long'
                                    : null,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10),

                      const SizedBox(height: 20),

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
                            'I agree to the Terms of Service',
                            style: TextStyle(
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Terms of Service',
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
                                    'Sign Up',
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
                              'or continue with',
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
                                'Sign Up with Google',
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
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: Constants.smallSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go('/');
                            },
                            child: Text(
                              'Login',
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
