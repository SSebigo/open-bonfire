import 'package:bonfire/services/base_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthenticationService extends BaseService {
  Future<FirebaseUser> signInAnonymously();
  // Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signUpWithEmail(String email, String password);
  Future<FirebaseUser> convertUserWithEmail(String email, String password);
  Future<FirebaseUser> signInWithEmail(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Future<FirebaseUser> getCurrentUser();
  Future<bool> isSignedIn();
  Future<bool> isAnonymous();
  Future<void> updateEmail(String email);
  Future<void> updatePassword(String password);
}
