import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String country;
  final String telephone;
  final String gender;
  final int textsRead;
  final int validations;
  final int invitations;

  const User({
    this.uid,
    this.country,
    this.telephone,
    this.gender,
    this.textsRead,
    this.validations,
    this.invitations,
  });

  User.fromFireStore(DocumentSnapshot user)
      : uid = user.documentID,
        country = user['country'],
        telephone = user['telephone'],
        gender = user['gender'],
        textsRead = user['textsread'],
        validations = user['validations'],
        invitations = user['invitations'];

  Map<String, dynamic> get userAsMap {
    return {
      'uid': this.uid,
      'country': this.country,
      'telephone': this.telephone,
      'gender': this.telephone,
      'textsread': this.textsRead,
      'validations': this.validations,
      'invitations': this.invitations,
    };
  }
}
