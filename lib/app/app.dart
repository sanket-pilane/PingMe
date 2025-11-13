import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/data/auth_repository.dart';
import 'package:pingme/features/auth/view/login_screen.dart';
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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            if (state.user.username.isEmpty) {
              return const ProfileSetupScreen();
            }
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
