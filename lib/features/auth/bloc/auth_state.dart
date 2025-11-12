part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

@immutable
class AuthState {
  final AuthStatus status;
  final firebase_auth.User? user;

  const AuthState._({required this.status, this.user});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated({required firebase_auth.User user})
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);
}
