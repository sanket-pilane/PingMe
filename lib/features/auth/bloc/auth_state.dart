part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, loading, failure, unknown }

@immutable
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel user; // Changed from UserModel?
  final String? errorMessage;

  const AuthState._({
    required this.status,
    required this.user,
    this.errorMessage,
  });
  const AuthState.loading()
    : this._(status: AuthStatus.loading, user: UserModel.empty);

  const AuthState.failure(String message)
    : this._(
        status: AuthStatus.failure,
        user: UserModel.empty,
        errorMessage: message,
      );

  const AuthState.unknown()
    : this._(status: AuthStatus.unknown, user: UserModel.empty);

  const AuthState.authenticated({required UserModel user})
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated, user: UserModel.empty);

  @override
  List<Object?> get props => [status, user, errorMessage];
}
