part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

@immutable
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel user;

  const AuthState._({required this.status, this.user = UserModel.empty});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated({required UserModel user})
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
