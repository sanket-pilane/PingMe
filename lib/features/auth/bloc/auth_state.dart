part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

@immutable
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel user; // Changed from UserModel?

  const AuthState._({required this.status, required this.user});

  const AuthState.unknown()
    : this._(status: AuthStatus.unknown, user: UserModel.empty);

  const AuthState.authenticated({required UserModel user})
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated, user: UserModel.empty);

  @override
  List<Object> get props => [status, user];
}
