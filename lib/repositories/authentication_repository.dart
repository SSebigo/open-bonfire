import 'package:bonfire/services/authentication/base_authentication_service.dart';
import 'package:bonfire/services/authentication/firebase_authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  final BaseAuthenticationService _authenticationService =
      FirebaseAuthenticationService();

  static final AuthenticationRepository _singleton =
      AuthenticationRepository._internal();

  AuthenticationRepository._internal();

  factory AuthenticationRepository() => _singleton;

  Future<FirebaseUser> signInAnonymously() =>
      _authenticationService.signInAnonymously();

  Future<FirebaseUser> signUpWithEmail(String email, String password) =>
      _authenticationService.signUpWithEmail(email, password);

  Future<FirebaseUser> convertUserWithEmail(String email, String password) =>
      _authenticationService.convertUserWithEmail(email, password);

  Future<FirebaseUser> signInWithEmail(String email, String password) =>
      _authenticationService.signInWithEmail(email, password);

  Future<void> resetPassword(String email) =>
      _authenticationService.resetPassword(email);

  Future<void> signOut() => _authenticationService.signOut();

  Future<FirebaseUser> getCurrentUser() =>
      _authenticationService.getCurrentUser();

  Future<bool> isSignedIn() => _authenticationService.isSignedIn();

  Future<bool> isAnonymous() => _authenticationService.isAnonymous();

  Future<void> updateEmail(String email) =>
      _authenticationService.updateEmail(email);

  Future<void> updatePassword(String password) =>
      _authenticationService.updatePassword(password);
}
