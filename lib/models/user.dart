// External
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  // final String uid;
  final String nickname;
  final String country;
  // final String telephone;
  final String gender;
  final String ageRange;
  final String eduBG;
  // final int textsRead;
  // final int validations;
  // final int invitations;

  const User({
    // @required this.uid,
    @required this.nickname,
    @required this.country,
    // @required this.telephone,
    @required this.gender,
    @required this.ageRange,
    @required this.eduBG,
    // @required this.textsRead,
    // @required this.validations,
    // @required this.invitations,
  });

  // User.fromFireStore(DocumentSnapshot user)
  //     : uid = user.documentID,
  //       country = user['country'],
  //       // telephone = user['telephone'],
  //       gender = user['gender'],
  //       age = user['age'],
  //       eduBG = user['edubg'],
  //       // textsRead = user['textsread'],
  //       // validations = user['validations'],
  //       // invitations = user['invitations'];

  // Map<String, dynamic> get userAsMap {
  //   return {
  //     // 'uid': this.uid,
  //     'country': this.country,
  //     // 'telephone': this.telephone,
  //     'gender': this.gender,
  //     'age': this.age,
  //     'edubg': this.eduBG,
  //     // 'textsread': this.textsRead,
  //     // 'validations': this.validations,
  //     // 'invitations': this.invitations,
  //   };
  // }

  User.fromSharedPreference(Map<String, dynamic> user)
      : this.nickname = user['nickname'],
        this.country = user['country'],
        // telephone = user['telephone'],
        this.gender = user['gender'],
        this.ageRange = user['age'],
        this.eduBG = user['edubg'];
  // textsRead = user['textsread'],
  // validations = user['validations'],
  // invitations = user['invitations'];

}
