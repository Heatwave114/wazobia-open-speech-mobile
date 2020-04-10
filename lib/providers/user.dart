// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// Internal
import '../helpers/auth.dart';
import '../screens/authenticate_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/centrally_used.dart';

class User with ChangeNotifier {
  Firestore databaseRoot = Firestore.instance;
  FirebaseUser _instance;
  Auth _auth = Auth();

  // Set before providing i.e ..setInstance(Auth().currentUser());
  void setInstance(Future<FirebaseUser> instance) async {
    _instance = await instance;
  }

  // Get after providing
  FirebaseUser get instance => _instance;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // User Data related
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////
  // Instance Data
  ////////////////

  // SET
  void setUserdata({
    String country,
    String telephone,
    String gender,
  }) async {
    final _instance =  (await _auth.currentUser());
    databaseRoot.collection('users').document(_instance.uid).setData({
      'country': country,
      'telephone': telephone,
      'gender': gender,
    });
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Persistence
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<Widget> getLandingPage() async {
        final _instance =  (await _auth.currentUser());
    return StreamBuilder<FirebaseUser>(
      stream: this._auth.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CentrallyUsed().waitingCircle();
        }
        if (snapshot.hasData && !snapshot.data.isAnonymous && _instance.isEmailVerified) {
          return DashboardScreen();
        }
        return AuthenticateScreen();
      },
    );
  }
}
