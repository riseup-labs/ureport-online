import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginStatus {
  SUCCESS,
  NOT_FOUND,
  WRONG_DETAILS,
  ERROR,
}

enum RegisterStatus {
  SUCCESS,
  ERROR,
  EMAIL_EXISTS,
  WEAK_PASSWORD,
}

class FirebaseApis {
  static final FirebaseApis _instance = FirebaseApis._internal();
  factory FirebaseApis() => _instance;
  FirebaseApis._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<LoginStatus> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return LoginStatus.SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return LoginStatus.NOT_FOUND;
      } else if (e.code == 'wrong-password') {
        return LoginStatus.WRONG_DETAILS;
      } else {
        return LoginStatus.ERROR;
      }
    }
  }

  Future<RegisterStatus> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      //   'name': name,
      //   'email': email,
      //   'createdAt': DateTime.now(),
      // });

      return RegisterStatus.SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return RegisterStatus.WEAK_PASSWORD;
      } else if (e.code == 'email-already-in-use') {
        return RegisterStatus.EMAIL_EXISTS;
      } else {
        return RegisterStatus.ERROR;
      }
    }
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
