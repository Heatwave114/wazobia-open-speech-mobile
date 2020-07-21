// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Donation {
  final String name;
  final Map reader;
  final DateTime donationDateLocal;
  final double duration;
  // final String cqi;
  // final String snr;
  int bias;
  int validCount;
  final String resourceId;
  List invalidReasons;
  final String url;

  Donation({
    @required this.name,
    @required this.reader,
    @required this.donationDateLocal,
    @required this.duration,
    // @required this.cqi,
    // @required this.snr,
    @required this.bias,
    @required this.validCount,
    @required this.resourceId,
    @required this.invalidReasons,
    @required this.url,
  });

  // setInvalidReasons helps with firebase in validation_screen
  set setInvalidReasons(List<Map<String, dynamic>> invalidReasons) =>
      this.invalidReasons = invalidReasons;

  // addInvalidReason helps with firebase in validation_screen
  void addInvalidReason(Map<String, dynamic> reason) {
    this.invalidReasons.add(reason);
  }

  Donation.fromFireStore(DocumentSnapshot donation)
      : this.name = donation.documentID,
        this.reader = donation['reader'],
        this.donationDateLocal = DateTime.parse(donation['donationdatelocal']),
        this.duration = donation['duration'],
        // this.cqi = donation['cqi'],
        // this.snr = donation['snr'],
        this.bias = donation['bias'],
        this.validCount = donation['validcount'],
        this.resourceId = donation['resourceid'],
        this.invalidReasons = donation['invalidreasons'],
        this.url = donation['url'];

  String get formatedDurationTime {
    final imin = (this.duration ~/ 60).toString();
    final isec = (this.duration % 60).toInt().toString();
    final omin =
        imin == '0' ? '' : (imin + 'min${(int.parse(imin) == 1) ? '' : 's'}');
    final osec =
        isec == '0' ? '' : (isec + 'sec${(int.parse(isec) == 1) ? '' : 's'}');

    return omin + ' ' + osec;
  }
}
