part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged({this.user});
  final firebase_auth.User? user;
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
