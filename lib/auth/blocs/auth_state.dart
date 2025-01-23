abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthSignedInState extends AuthState{
  final String displayName;
  final String email;
  final String accessToken;

  AuthSignedInState({
    required this.displayName,
    required this.email,
    required this.accessToken,
  });
}

class AuthSignedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);
}

class AuthLoadingState extends AuthState {}