// External
import 'package:flutter/cupertino.dart';

// Internal
import '../models/resource.dart';

class SoundTin with ChangeNotifier {
  String donatedVoicePath;
  Resource currentDonatingResource;
  Resource currentValidatingResource;

  //////////////////////
  // Donated Voice Path
  //////////////////////
  
  // set
  set setDonatedVoicePath(String donatedVoicePath) {
    this.donatedVoicePath = donatedVoicePath;
    notifyListeners();
  }

  // get
  get getDonatedVoicePath => this.donatedVoicePath;


  /////////////////////////////
  // Current Donating Resource
  /////////////////////////////

  // set
  set setCurrentcurrentRecordingResource(Resource resource) {
    this.currentDonatingResource = resource;
    notifyListeners();
  }

  // get
  get getCurrentcurrentRecordingResource => this.currentDonatingResource;


  ///////////////////////////////
  // Current Validating Resource
  //////////////////////////////

  // set
  set setCurrentcurrentValidatingResource(Resource resource) {
    this.currentValidatingResource = resource;
    notifyListeners();
  }

  // get
  get getCurrentcurrentValidatingResource => this.currentValidatingResource;
}
