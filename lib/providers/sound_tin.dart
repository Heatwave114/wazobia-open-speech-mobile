// Core
// import 'dart:math';

// External
import 'package:flutter/cupertino.dart';

// Internal
import '../models/resource.dart';

class SoundTin with ChangeNotifier {
  String donatedVoicePath;
  String validatingVoiceURL;
  Resource currentDonatingResource;
  Resource currentValidatingResource;
  int _currentDonatingResourceIndex;
  int _currentValidatingResourceIndex;
  bool _shouldRefreshDonatingResourceIndex;
  bool _shouldRefreshValidatingResourceIndex;

  ///////////
  // Control
  //////////

  // _shouldRefreshDonatingResourceIndex get
  get getShouldRefreshDonatingResourceIndex =>
      this._shouldRefreshDonatingResourceIndex;

  // _shouldRefreshDonatingResourceIndex set
  set setShouldRefreshDonatingResourceIndex(bool shouldResfresh) {
    this._shouldRefreshDonatingResourceIndex = shouldResfresh;
    // notifyListeners();
  }

  // _shouldRefreshValidatingResourceIndex get
  get getShouldRefreshValidatingResourceIndex =>
      this._shouldRefreshValidatingResourceIndex;

  // _shouldRefreshValidatingResourceIndex set
  set setShouldRefreshValidatingResourceIndex(bool shouldResfresh) {
    this._shouldRefreshValidatingResourceIndex = shouldResfresh;
    // notifyListeners();
  }

  //////////////////////
  // Donated Voice Path
  //////////////////////

  // set
  set setDonatedVoicePath(String donatedVoicePath) {
    this.donatedVoicePath = donatedVoicePath;
    // notifyListeners();
  }

  // get
  get getDonatedVoicePath => this.donatedVoicePath;

  ////////////////////////////
  // Current Donating Resource
  ////////////////////////////

  // set index
  set setCurrentDonatingResourceIndex(int index) {
    this._currentDonatingResourceIndex = index;
    // notifyListeners();
  }

  // set resource
  set setCurrentDonatingResource(Resource resource) {
    this.currentDonatingResource = resource;
    // notifyListeners();
  }

  // get index
  get getCurrentDonatingResourceIndex => this._currentDonatingResourceIndex;

  // get resource
  Resource get getCurrentDonatingResource => this.currentDonatingResource;

  ///////////////////////
  // Validating Voice url
  ///////////////////////

  // set
  set setValidatingVoiceURL(String validatingVoiceURL) {
    this.validatingVoiceURL = validatingVoiceURL;
    // notifyListeners();
  }

  // get
  get getValidatingVoiceURL => this.validatingVoiceURL;

  //////////////////////////////
  // Current Validating Resource
  //////////////////////////////

  // set index
  set setCurrentValidatingResourceIndex(int index) {
    this._currentValidatingResourceIndex = index;
    // notifyListeners();
  }

  // set resource
  set setCurrentValidatingResource(Resource resource) {
    this.currentValidatingResource = resource;
    // notifyListeners();
  }

  // get index
  get getCurrentValidatingResourceIndex => this._currentValidatingResourceIndex;

  // get resource
  Resource get getCurrentValidatingResource => this.currentValidatingResource;
}
