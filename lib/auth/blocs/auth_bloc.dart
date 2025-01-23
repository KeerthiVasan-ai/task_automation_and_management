import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_automation_and_management_system/feature_task_automation/utils/sharedpreference_helper.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: ['https://mail.google.com/']);

  AuthBloc() : super(AuthInitialState()) {
    on<AuthGoogleSignInEvent>(_onGoogleSignIn);
    on<AuthGoogleSignOutEvent>(_onGoogleSignOut);
  }

  Future<void> _onGoogleSignIn(
      AuthGoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(AuthErrorState("User canceled sign-in."));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final String email = userCredential.user!.email!;
      final String accessToken = googleAuth.accessToken!;

      SharedPreferencesHelper.storeAccessToken(email, accessToken);

      if (userCredential.user != null) {
        emit(AuthSignedInState(
          displayName: email,
          email: userCredential.user!.email!,
          accessToken: accessToken,
        ));
      } else {
        emit(AuthErrorState("Failed to sign in with Google."));
      }
    } catch (e) {
      emit(AuthErrorState("Error: ${e.toString()}"));
    }
  }

  Future<void> _onGoogleSignOut(
      AuthGoogleSignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      emit(AuthSignedOutState());
    } catch (e) {
      emit(AuthErrorState("Error: ${e.toString()}"));
    }
  }
}
