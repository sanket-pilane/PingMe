import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/app/app_colors.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/view/login.dart';
import 'package:pingme/features/auth/widgets/logo.dart';
import 'package:pingme/features/auth/widgets/my_button.dart';
import 'package:pingme/features/auth/widgets/my_textfield.dart';
import 'package:pingme/features/auth/widgets/or_divider.dart';
import 'package:pingme/features/auth/widgets/snackbar.dart';
import 'package:pingme/features/home/view/home_screen.dart';
import 'package:pingme/features/profile/view/profile_setup_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (_passwordController.text != _confirmPassword.text) {
      showCustomSnackbar(context, 'Passwords do not match.', isError: true);
      return;
    }

    context.read<AuthBloc>().add(
      AuthSignUpRequested(
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
            state.errorMessage ?? "Signup failed",
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

                    Text('Create account', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up and improve your health today',
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

                    CustomTextField(
                      controller: _confirmPassword,
                      labelText: 'Confirm password',
                      hintText: 'Re-type your password',
                      obscureText: _obscureConfirmPassword,
                      enabled: !isLoading,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textGrey,
                        ),
                        onPressed: () {
                          if (isLoading) return;
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    PrimaryButton(
                      text: isLoading ? "Creating..." : "Create account",
                      onPressed: isLoading ? null : _onCreateAccount,
                    ),

                    const SizedBox(height: 40),
                    const OrDivider(),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                          child: const Text(
                            'Log in',
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
