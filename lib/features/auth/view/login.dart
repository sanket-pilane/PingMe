import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/app/app_colors.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/view/signup_screen.dart';
import 'package:pingme/features/auth/widgets/logo.dart';
import 'package:pingme/features/auth/widgets/my_button.dart';
import 'package:pingme/features/auth/widgets/my_textfield.dart';
import 'package:pingme/features/auth/widgets/or_divider.dart';
import 'package:pingme/features/auth/widgets/snackbar.dart';
import 'package:pingme/features/home/view/home_screen.dart';
import 'package:pingme/features/profile/view/profile_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    context.read<AuthBloc>().add(
      AuthLogInRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          showCustomSnackbar(
            context,
            state.errorMessage ?? "Authentication failed",
            isError: true,
          );
        }

        if (state.status == AuthStatus.authenticated) {
          final next = state.user.username.isEmpty
              ? const ProfileSetupScreen()
              : const HomeScreen();

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => next),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Center(
                      child: DoctolibLogo(size: 36, color: AppColors.textWhite),
                    ),
                    const SizedBox(height: 60),
                    Text('Welcome Back!', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Ready to step up your style? Log in now!',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 40),

                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: _obscurePassword,
                      enabled: !isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textGrey,
                        ),
                        onPressed: () {
                          if (isLoading) return;
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: isLoading
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                            ),
                            Text('Remember me', style: textTheme.bodyMedium),
                          ],
                        ),
                        TextButton(
                          onPressed: isLoading ? null : () {},
                          child: const Text(
                            'Forgot password',
                            style: TextStyle(color: AppColors.primaryPurple),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    PrimaryButton(
                      text: isLoading ? "Loading..." : "Login",
                      onPressed: isLoading ? null : _onLoginPressed,
                    ),

                    const SizedBox(height: 40),
                    const OrDivider(),
                    const SizedBox(height: 40),

                    // Social Buttons Placeholder
                    const SizedBox(height: 50),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SignUpScreen(),
                                    ),
                                  );
                                },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
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
    );
  }
}
