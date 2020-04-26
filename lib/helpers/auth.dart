// External
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Stream<FirebaseUser> get onAuthStateChanged;
  Future<FirebaseUser> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<FirebaseUser> createUserWitEmailAndPassword(
    String email,
    String password,
  );
  Future<FirebaseUser> currentUser();
  Future<void> signOut();
  // Future<String> signInWithGoogle();
  Future<void> verifyPhoneNumber(String phoneNumber);
  Future<FirebaseUser> signInWithCredentials(
    String verfId,
    String smsCode,
  );
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final GooverifyPhoneNumberIn _googleSignIn = GoogleSignIn();

  FirebaseAuth get getInstance {
    return _firebaseAuth;
  }

  Future<FirebaseUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    FirebaseUser user =  authResult.user;
    return user;
  }
  
  

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    String _smsCode;
    String _verificationId;

    final PhoneCodeAutoRetrievalTimeout _codeAutoRetrievalTimeout =
        (String verId) {
      _verificationId = verId;
    };
    final PhoneCodeSent _codeSent = (String verId, [int forceResendingToken]) {
      _verificationId = verId;
    };
    final PhoneVerificationCompleted _phoneVerificationCompleted =
        (AuthCredential credential) {
      print('sucess');
    };
    final PhoneVerificationFailed _verificationFailed =
        (AuthException exception) {
      print(exception.message);
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: _phoneVerificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout);

    // await _firebaseAuth.signInWithCredential(_credential);
  }

  @override
  Future<FirebaseUser> signInWithCredentials(String verfId,
    String smsCode,) {
    // _firebaseAuth.signInWithCredential()
  }

  @override
  Stream<FirebaseUser> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged;
  //  _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);

  @override
  Future<FirebaseUser> createUserWitEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
  }

  @override
  Future<FirebaseUser> currentUser() async {
    return (await _firebaseAuth.currentUser());
  }

  @override
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return user;
    } catch (error) {
      throw error; //authExcp.AuthException(error.message);
    }
  }

  // @override
  // Future<String> signInWithGoogle() async {
  //   final GoogleSignInAccount account = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication _auth = await account.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: _auth.accessToken,
  //     idToken: _auth.idToken,
  //   );
  //   return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  // }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
