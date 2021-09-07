import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitnessfire/structures/user_model.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserModel _userInstance = UserModel().getInstance();

  User get currentUser => _firebaseAuth.currentUser;

  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> sendPasswordResetEmail({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithEmailAndPassword(
      {String email, String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    _firebaseFirestore
        .collection("Users")
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((value) => {
          _userInstance.fromMap(value.data())
    });

  }

  Future<void> createUserWithEmailAndPassword(
      {String email, String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    _userInstance.userId = userCredential.user.uid;
    _userInstance.userEmail = email;
    //_userInstance.userName = 'User';
    Map<String, dynamic> userMap = _userInstance.toMap();
    /*_firebaseFirestore
        .collection("Users")
        .doc(userCredential.user.uid)
        .set({"test": "test"});
    print('object');*/
    _firebaseFirestore
        .collection("Users")
        .doc(userCredential.user.uid)
        .set(userMap);
    print('object');
  }

  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        return userCredential.user;
      }
    } else {
      throw FirebaseAuthException(
        message: "Sign in aborded by user",
        code: "ERROR_ABORDER_BY_USER",
      );
    }
  }

  Future<void> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token));
        return userCredential.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: "ERROR_ABORDER_BY_USER",
          message: "Sign in aborder by user",
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: "ERROR_FACEBOOK_LOGIN_FAILED",
          message: response.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
