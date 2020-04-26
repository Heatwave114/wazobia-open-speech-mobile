import 'package:flutter/cupertino.dart';

class SoundTin with ChangeNotifier {
  String donatedVoicePath;
  set setDonatedVoicePath(String donatedVoicePath) {
    this.donatedVoicePath = donatedVoicePath;
    notifyListeners();
  }
  get getDonatedVoicePath => this.donatedVoicePath;
}
