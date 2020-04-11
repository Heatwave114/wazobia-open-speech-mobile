// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireBaseHelper with ChangeNotifier {
  final _databaseRoot = Firestore.instance;

  /////////////
  /// Bulk Get
  ////////////

  // All Users cFireS
  get users => this._databaseRoot.collection('users'); // Read Only
}
