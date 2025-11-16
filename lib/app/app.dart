import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/app/app_colors.dart';
import 'package:pingme/app/splash_screen.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/data/auth_repository.dart';
import 'package:pingme/features/auth/view/login.dart';
import 'package:pingme/features/auth/view/signup_screen.dart';
import 'package:pingme/features/home/view/home_screen.dart';
import 'package:pingme/features/profile/view/profile_setup_screen.dart';
import 'package:pingme/features/rooms/data/room_repository.dart';
import 'package:pingme/features/tasks/data/task_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authRepository,
    required this.roomRepository,
    required this.taskRepository,
  });

  final AuthRepository authRepository;
  final RoomRepository roomRepository;
  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: roomRepository),
        RepositoryProvider.value(value: taskRepository),
      ],
      child: BlocProvider(
        create: (_) => AuthBloc(authRepository: authRepository),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PingMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        primaryColor: AppColors.primaryPurple,

        fontFamily: 'Inter', // Assuming a clean sans-serif font

        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textLightGrey,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textGrey),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          hintStyle: const TextStyle(color: AppColors.textGrey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryPurple,
              width: 2,
            ),
          ),
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryPurple;
            }
            return AppColors.darkSurface;
          }),
          checkColor: WidgetStateProperty.all(AppColors.textWhite),
          side: const BorderSide(color: AppColors.darkBorder, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          switch (state.status) {
            case AuthStatus.unknown:
              return const SplashScreen();
            case AuthStatus.loading:
              return const SplashScreen();
            case AuthStatus.authenticated:
              if (state.user.username.isEmpty) {
                return const ProfileSetupScreen();
              }
              return const HomeScreen();
            case AuthStatus.unauthenticated:
              return const LoginScreen();
            case AuthStatus.failure:
              return LoginScreen();
          }
        },
      ),
    );
  }
}
