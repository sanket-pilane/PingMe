import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pingme/features/auth/data/auth_repository.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserModel>? _userSubscription;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState.unknown()) {
    // Listen to the live stream
    _userSubscription = _authRepository.user.listen((user) {
      add(AuthUserChanged(user: user));
    });
    on<AuthSignUpRequested>((event, emit) async {
      emit(const AuthState.loading());
      debugPrint('AuthBloc: AuthSignUpRequested -> email: ${event.email}');
      try {
        await _authRepository.signUp(
          email: event.email,
          password: event.password,
        );

        debugPrint(
          'AuthBloc: signUp completed, waiting for auth stream update...',
        );
      } catch (e, st) {
        debugPrint('AuthBloc: signUp error: $e\n$st');
        emit(AuthState.failure(e.toString()));
      }
    });
    on<AuthLogInRequested>((event, emit) async {
      emit(const AuthState.loading());
      debugPrint('AuthBloc: AuthLogInRequested -> email: ${event.email}');
      try {
        await _authRepository.logInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        debugPrint(
          'AuthBloc: login completed, waiting for auth stream update...',
        );
      } catch (e, st) {
        debugPrint('AuthBloc: login error: $e\n$st');
        emit(AuthState.failure(e.toString()));
      }
    });

    on<AuthUserChanged>((event, emit) {
      debugPrint(
        'AuthBloc: AuthUserChanged event.user => uid: "${event.user.uid}", email: "${event.user.email}", username: "${event.user.username}"',
      );
      debugPrint(
        'AuthBloc: isEmpty=${event.user.isEmpty}, isNotEmpty=${event.user.isNotEmpty}',
      );

      if (event.user.isNotEmpty) {
        emit(AuthState.authenticated(user: event.user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });

    on<AuthLogoutRequested>((event, emit) {
      _authRepository.logOut();
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
