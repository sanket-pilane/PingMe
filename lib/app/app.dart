import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/data/auth_repository.dart';
import 'package:pingme/features/auth/view/login_screen.dart';
import 'package:pingme/features/home/view/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key, required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: BlocProvider(
        create: (_) => AuthBloc(authRepository: _authRepository),
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
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
