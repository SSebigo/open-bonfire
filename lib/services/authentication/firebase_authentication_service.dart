import 'package:bonfire/models/user_session.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/services/authentication/base_authentication_service.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/exceptions.dart';
import 'package:bonfire/utils/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:password/password.dart';
import 'package:uuid/uuid.dart';

class FirebaseAuthenticationService extends BaseAuthenticationService {
  Logger logger = Logger();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _firestore = Firestore.instance;

  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();

  static final FirebaseAuthenticationService _singleton =
      FirebaseAuthenticationService._internal();

  FirebaseAuthenticationService._internal();

  factory FirebaseAuthenticationService() => _singleton;

  @override
  Future<FirebaseUser> signInAnonymously() async {
    final Uuid uuid = Uuid();

    await _firebaseAuth.signInAnonymously();
    final FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    await _localStorageRepository?.setUserSession(UserSession(
      uid: firebaseUser.uid,
      name: 'Anonynous',
      username: 'anonymous-${uuid.v4()}',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      isAnonymous: firebaseUser.isAnonymous,
    ));
    return firebaseUser;
  }

  @override
  Future<FirebaseUser> signUpWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
      await Future.wait([
        _localStorageRepository?.setUserSessionData(
            Constants.sessionUid, firebaseUser.uid),
        firebaseUser.sendEmailVerification(),
      ]);
      return firebaseUser;
    } on PlatformException catch (error) {
      if (error.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        throw EmailAlreadyUsedException(error.message);
      } else {
        throw SendConfirmationEmailFailedException(
            'Sending of the confirmation email has failed');
      }
    }
  }

  @override
  Future<FirebaseUser> convertUserWithEmail(
      String email, String password) async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();

    final AuthCredential credential =
        EmailAuthProvider.getCredential(email: email, password: password);
    currentUser = (await currentUser.linkWithCredential(credential)).user;

    await Future.wait([
      _localStorageRepository?.setUserSessionData(
          Constants.sessionUid, currentUser.uid),
      _localStorageRepository?.setUserSessionData(
          Constants.sessionPassword, Password.hash(password, PBKDF2())),
    ]);
    return currentUser;
  }

  @override
  Future<FirebaseUser> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final FirebaseUser firebaseUser = await _firebaseAuth.currentUser();

      await Future.wait([
        _localStorageRepository?.setUserSessionData(
            Constants.sessionUid, firebaseUser.uid),
        _localStorageRepository?.setUserSessionData(
            Constants.sessionPassword, Password.hash(password, PBKDF2())),
      ]);
      if (firebaseUser.isEmailVerified) return firebaseUser;
      throw EmailNotVerifiedException();
    } catch (error) {
      if (error is EmailNotVerifiedException) {
        throw EmailNotVerifiedException(
            'Your account has not yet been verified, an email containing a verification link has been sent to the email address you used to register');
      }
      if (error.code == "ERROR_USER_NOT_FOUND") {
        throw EmailUserNotFoundException(error.message as String);
      }
    }
    return null;
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (error) {
      if (error.code == "ERROR_USER_NOT_FOUND") {
        throw EmailUserNotFoundException(error.message as String);
      }
    }
  }

  @override
  Future<void> signOut() async {
    return Future.wait([
      _localStorageRepository?.clearUserSession(),
      _localStorageRepository?.clearDailyQuest(),
      _localStorageRepository?.clearPenalty(),
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return _firebaseAuth.currentUser();
  }

  @override
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  @override
  Future<bool> isAnonymous() async {
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    return currentUser?.isAnonymous;
  }

  @override
  Future<void> updateEmail(String email) async {
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    try {
      final String uid = _localStorageRepository
          ?.getUserSessionData(Constants.sessionUid) as String;
      final DocumentReference ref =
          _firestore.collection(Paths.usersPath).document(uid);

      await Future.wait([
        currentUser.updateEmail(email),
        ref.setData({'email': email}, merge: true),
        _localStorageRepository?.setUserSessionData(
            Constants.sessionEmail, email),
      ]);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(String password) async {
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    try {
      await Future.wait([
        currentUser.updatePassword(password),
        _localStorageRepository?.setUserSessionData(
            Constants.sessionPassword, Password.hash(password, PBKDF2())),
      ]);
    } catch (error) {
      rethrow;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
