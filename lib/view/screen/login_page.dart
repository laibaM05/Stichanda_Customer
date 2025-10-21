import 'package:flutter/material.dart';
import '../base/text_field.dart';
import '../base/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _onLoginPressed() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 👈 Access global theme
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top header section with title centered and logo on top-right
              SizedBox(
                height: 140,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0, top: 10),
                        child: Image.asset(
                          'assets/images/Stitchanda Customer logo.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // 🔹 Welcome text
              Center(
                child: Column(
                  children: [
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please enter your details to sign in',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium, // 👈 Uses theme
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 🔹 Email Field
              CustomTextField(
                controller: _emailController,
                hintText: 'Email or username',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // 🔹 Password Field
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot Password?',
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColor, // 👈 Use theme color
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Login Button
              PrimaryButton(
                text: 'Login',
                isLoading: _isLoading,
                onPressed: _onLoginPressed,
              ),
              const SizedBox(height: 30),

              // 🔹 Signup Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Sign up",
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}