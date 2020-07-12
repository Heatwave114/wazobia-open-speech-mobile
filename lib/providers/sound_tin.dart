// Core
// import 'dart:math';

// External
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flauto.dart';

// Internal
import '../models/donation.dart';
import '../models/resource.dart';
import '../models/user.dart';

class SoundTin with ChangeNotifier {
  String donatedVoicePath;
  String validatingVoiceURL;
  String reasonForEvaluation;
  Resource currentDonatingResource;
  Resource currentValidatingResource;
  Donation currentValidatingDonation;
  int _currentDonatingResourceIndex;
  int _currentValidatingDonationIndex;
  bool _proceedWithDonationEvaluation = false;
  bool _shouldRefreshDonatingResourceIndex;
  bool _shouldRefreshValidatingDonationIndex;
  bool shouldInitDevil = false;
  bool inDanger = false;
  bool isRecording = false;
  bool isPlaying = false;
  bool shouldAllowValidation = false;
  User currentDonatingUser;

  ///////////
  // Control
  //////////

  // reasonForInvalidation set
  set setReasonForEvaluation(String reasonForEvaluation) =>
      this.reasonForEvaluation = reasonForEvaluation;

  // reasonForInvalidation get
  get getReasonForEvaluation => this.reasonForEvaluation;

  // _proceedWithDonationEvaluation set
  set setProceedWithDonationEvaluation(bool proceedWithDonationEvaluation) =>
      this._proceedWithDonationEvaluation = proceedWithDonationEvaluation;

  // _proceedWithDonationEvaluation get
  get getProceedWithDonationEvaluation => this._proceedWithDonationEvaluation;

  // _shouldInitDevil set
  set setShouldInitDevil(bool shouldInitDevil) {
    this.shouldInitDevil = shouldInitDevil;
    // notifyListeners();
  }

  // _shouldInitDevil get
  get getShouldInitDevil => this.shouldInitDevil;

  // _shouldRefreshDonatingResourceIndex get
  get getShouldRefreshDonatingResourceIndex =>
      this._shouldRefreshDonatingResourceIndex;
  // _shouldRefreshDonatingResourceIndex set
  set setShouldRefreshDonatingResourceIndex(bool shouldResfresh) {
    this._shouldRefreshDonatingResourceIndex = shouldResfresh;
    notifyListeners();
  }

  // _getShouldAllowValidate
  get getShouldAllowValidation => this.shouldAllowValidation;
  // _setShouldAllowValidate
  set setShouldAllowValidation(bool shouldAllowValidation) =>
      this.shouldAllowValidation = shouldAllowValidation;
  //  {
  // notifyListeners();
  // }

  // _getInDanger
  get getInDanger => this.inDanger;
  // _setInDanger
  set setInDanger(bool inDanger) {
    this.inDanger = inDanger;
    notifyListeners();
  }

  // _shouldRefreshValidatingResourceIndex get
  get getShouldRefreshValidatingDonationIndex =>
      this._shouldRefreshValidatingDonationIndex;

  // _shouldRefreshValidatingResourceIndex set
  set setShouldRefreshValidatingDonationIndex(bool shouldResfresh) {
    this._shouldRefreshValidatingDonationIndex = shouldResfresh;
    notifyListeners();
  }

  // _getIsRecording
  get getIsRecording => this.isRecording;

  // _setIsRecording
  set setIsRecording(bool isRecording) {
    this.isRecording = isRecording;
    notifyListeners();
  }

  // _getIsPlaying
  get getIsPlaying => this.isPlaying;
  // _setIsPlaying
  set setIsPlaying(bool isPlaying) => this.isPlaying = isPlaying;

  //////////////////////
  // Donated Voice Path
  //////////////////////

  // set
  set setDonatedVoicePath(String donatedVoicePath) =>
      this.donatedVoicePath = donatedVoicePath;
  // notifyListeners();

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
    notifyListeners();
  }

  // get index
  get getCurrentDonatingResourceIndex => this._currentDonatingResourceIndex;

  // get donation
  Resource get getCurrentDonatingResource => this.currentDonatingResource;

  // get Duration
  Future<double> getDonatedVoiceDuration() async {
    int d = await flutterSoundHelper.duration(this.donatedVoicePath);
    double _duration = d != null ? d / 1000.0 : null;
    return _duration;
  }

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
  // Current Validating Donation
  //////////////////////////////

  // set index
  set setCurrentValidatingDonationIndex(int index) {
    this._currentValidatingDonationIndex = index;
    // notifyListeners();
  }

  // get index
  get getCurrentValidatingDonationIndex => this._currentValidatingDonationIndex;

  // set donation
  set setCurrentValidatingDonation(Donation donation) {
    this.currentValidatingDonation = donation;
    // notifyListeners();
  }

  // get donation
  Donation get getCurrentValidatingDonation => this.currentValidatingDonation;

  //////////////////////////////
  // Current Validating Resource
  //////////////////////////////

  // set resource
  set setCurrentValidatingResource(Resource resource) {
    this.currentValidatingResource = resource;
    // notifyListeners();
  }

  // get resource
  Resource get getCurrentValidatingResource => this.currentValidatingResource;

  /////////////////////////
  // Currrent Donating User
  /////////////////////////

  // set donating user
  set setCurrentDonatingUser(User user) => this.currentDonatingUser = user;

  // get donating user
  get getCurrentDonatingUser => this.currentDonatingUser;
}
