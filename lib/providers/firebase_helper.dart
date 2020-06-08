// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireBaseHelper with ChangeNotifier {
  final _databaseRoot = Firestore.instance;

  // QuerySnapshot sn;

  /////////////
  /// Bulk Get
  ////////////

  // All Users cFireS
  get users => this._databaseRoot.collection('users'); // Read Only

  // All resources cFireS
  get resources => this._databaseRoot.collection('resources'); // Read Only

  // All unvalidated URLs
  get unvalidatedURLs =>
      this._databaseRoot.collection('unvalidated'); // Read Only

  // All validated URLs
  get validatedURLs => this._databaseRoot.collection('validated'); // Read Only

  // All invalid URLs
  get invalidURLs => this._databaseRoot.collection('invalid'); // Read Only

}
