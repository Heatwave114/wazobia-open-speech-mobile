// Core
import 'dart:convert';
import 'dart:async';
import 'dart:io';

// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Internal
import '../models/user.dart' as userM;
import '../helpers/auth.dart';
import '../screens/account_select_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/authenticate_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/centrally_used.dart';

class User with ChangeNotifier {
  Firestore databaseRoot = Firestore.instance;
  FirebaseStorage storageRoot = FirebaseStorage.instance;
  FirebaseUser _instance;
  Auth _auth = Auth();
  Future<SharedPreferences> _pref = () async {
    return SharedPreferences.getInstance();
  }();

  String userID; // SharedPreference;
  BuildContext context;

  // Set before providing i.e ..setInstance(Auth().currentUser());
  void setInstance(Future<FirebaseUser> instance) async {
    _instance = await instance;
  }

  //  Set before providing i.e ..setPref(SharedPreferences.getInstance());
  void setPref(Future<SharedPreferences> pref) async {
    _pref = pref;
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  // Get after providing
  FirebaseUser get instance => _instance;
  Future<SharedPreferences> get pref => _pref;

  ////////////////////
  // Firebase Storage
  ///////////////////

  // Upload voice
  Future<void> uploadVoice({
    @required File voiceToUpload,
    @required String resourceID,
    // @required userM.User reader,
  }) async {
    final uid = (await _auth.currentUser()).uid;
    final currentUser = await getCurrentUser();
    final String now = DateTime.now().toString();
    var voiceName = resourceID + '__${uid}__' + now;
    // var voiceName = title;
    final StorageReference firebaseStorageRef =
        storageRoot.ref().child('/unvalidated/$voiceName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(
        voiceToUpload,
        StorageMetadata(customMetadata: {
          'reader': json.encode({
            'country': currentUser['country'],
            'gender': currentUser['gender'],
            'age': currentUser['age'],
            'education': currentUser['edubg'],
          }),
          'cqi': 'NA',
          'snr': 'NA',
          'validcount': '0',
          'resource': resourceID,
        }));
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      databaseRoot.collection('unvalidated').document(voiceName).setData({
        'reader': json.encode({
          'country': currentUser['country'],
          'gender': currentUser['gender'],
          'age': currentUser['age'],
          'education': currentUser['edubg'],
        }),
        'cqi': 'NA',
        'snr': 'NA',
        'validcount': '0',
        'resource': resourceID,
        'url': url,
      });
      print(url);
      // return CloudStorageResult(
      //   imageUrl: url,
      //   imageFileName: imageFileName,
      //   );
    }
    return null;
  }

  //////////////////////
  // Shared Preferences
  /////////////////////

  // FirstPref set
  void setFirstTime(bool first) async {
    final pref = await this._pref;
    // final firstPref = _pref.getBool('firsttime');
    // if (!firstPref || firstPref == null) {}
    if (first) {
      pref.setBool('firsttime', true);
    } else {
      pref.setBool('firsttime', false);
    }
  }

  // FirstPref get
  Future<bool> getFirstTime() async {
    final pref = await this._pref;
    final firstPref = pref.getBool('firsttime');
    return firstPref;
  }

  // User add
  Future<void> addUser(userM.User user) async {
    final pref = await this._pref;
    final oldUsers = pref.getString('users');
    if (oldUsers == null) {
      var users = json.encode({
        user.nickname: {
          'country': user.country,
          'gender': user.gender,
          'age': user.age,
          'edubg': user.eduBG,
        },
      });
      pref.setString('users', users);
    } else if (json.decode(oldUsers)[user.nickname] != null) {
      // databaseRoot
      //     .collection('users')
      //     .document(await getCurrentUserID())
      //     .delete();
      // _showSnackBar('This nickname is already taken');
      throw PreferredException('This nickname is already taken');
    } else {
      final decodedOldUsers = json.decode(oldUsers);
      decodedOldUsers[user.nickname] = {
        'country': user.country,
        'gender': user.gender,
        'age': user.age,
        'edubg': user.eduBG,
      };
      final newUsers = json.encode(decodedOldUsers);
      pref.setString('users', newUsers);
    }
  }

// Updating snackbar
  void showSnackBar(String message) {
    Scaffold.of(this.context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(this.context).appBarTheme.color,
        // behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'ComicNeue',
          ),
        ),
        action: SnackBarAction(
          // textColor: Theme.of(this.context).primaryColor,
          label: 'ok',
          onPressed: () {
            Scaffold.of(this.context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

// // Updating dialog
//   void _showDialog(String title, String content) {
//     showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text(
//           title,
//           style: const TextStyle(
//               fontFamily: 'Abel', fontSize: 20.0, fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           content,
//           style: const TextStyle(
//             fontFamily: 'Abel',
//             fontSize: 17.0,
//             // fontWeight: FontWeight.bold
//           ),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: const Text('Okay'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }

  // User get by nick
  // Future<String> userIDByNickname(String nickname) async {
  //   final pref = await this._pref;
  //   final oldPref = pref.getString('users');
  //   final userId = json.decode(oldPref)[nickname];
  //   return userId;
  // }

  // User get by id
  // Future<String> userNickname() async {
  //   final pref = await this._pref;
  //   final userID = await getCurrentUserID();
  //   final users = pref.getString('users');
  //   final decodedUsers = json.decode(users);
  //   final nick =
  //       decodedUsers.entries.firstWhere((entry) => entry.value == userID).key;
  //   return nick;
  // }

  // Users get
  Future<Map<String, dynamic>> getUsers() async {
    final pref = await this._pref;
    final users = pref.getString('users');
    final decodedUsers = json.decode(users);
    return decodedUsers;
  }

  // curretUser get
  Future<Map<String, dynamic>> getCurrentUser() async {
    final pref = await this._pref;
    final currentUser = pref.getString('currentuser');
    // print(currentUser);
    // print(1);
    if (currentUser == null) return null;
    // print(2);
    final decodedCurrentUser = json.decode(currentUser);
    // print(decodedCurrentUser);
    return decodedCurrentUser;
  }

  // currentUser set
  void setCurrentUser(String nickname) async {
    final pref = await this._pref;
    final users = await this.getUsers();
    final encodedUser = json.encode(users[nickname]);

    if (nickname == null) {
      pref.setString('currentuser', null);
      return;
    }
    pref.setString('currentuser', encodedUser);
  }

  // CLear
  clear() async {
    final pref = await this._pref;
    pref.clear();
  }

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
    final _instance = (await _auth.currentUser());
    databaseRoot.collection('users').document(_instance.uid).setData({
      'country': country,
      'telephone': telephone,
      'gender': gender,
      'textsread': 0,
      'validations': 0,
      'invitations': 0,
    });
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Persistence
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Future<Widget> getLandingPage() async {
  //   // final _instance = (await _auth.currentUser());
  //   final firstTime = await getFirstTime();
  //   final currentUser = await getCurrentUser();
  //   return StreamBuilder<FirebaseUser>(
  //     stream: this._auth.onAuthStateChanged,
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CentrallyUsed().waitingCircle();
  //       }
  //       if (snapshot.hasData && !snapshot.data.isAnonymous) {
  //         return DashboardScreen();
  //       }
  //       return AuthenticateScreen();

  //     },
  //   );
  // }

  Future<void> connectionStatus() async {
    try {
      // final result =
      await InternetAddress.lookup('google.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //   print('connected');
      // }
    } on SocketException catch (_) {
      showSnackBar('Check your internet connection');
    }
  }

  Future<Widget> getLandingPage() async {
    final firstTime = await getFirstTime();
    final currentUser = await getCurrentUser();
    if (firstTime == null || firstTime) {
      // setFirstTime(false);
      return WelcomeScreen();
    } else if (currentUser == null) {
      return AccountSelectScreen();
    } else {
      return DashboardScreen();
    }
  }

  void signOut() async {
    final _instance = (await _auth.currentUser());
    _instance.delete();
    // this._auth.signOut();
    // this._instance.delete();
    setCurrentUser(null);
  }
}

class PreferredException implements Exception {
  final String message;

  PreferredException(this.message);

  @override
  String toString() {
    return message;
  }
}
