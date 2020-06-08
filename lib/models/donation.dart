// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Donation {
  final String name;
  final Map reader;
  final DateTime donationDateNIGLocal;
  final double duration;
  final String cqi;
  final String snr;
  int validCount;
  final String resourceId;
  final String url;

  Donation({
    @required this.name,
    @required this.reader,
    @required this.donationDateNIGLocal,
    @required this.duration,
    @required this.cqi,
    @required this.snr,
    @required this.validCount,
    @required this.resourceId,
    @required this.url,
  });

  Donation.fromFireStore(DocumentSnapshot donation)
      : this.name = donation.documentID,
        this.reader = donation['reader'],
        this.donationDateNIGLocal = DateTime.parse(donation['donationdateniglocal']),
        this.duration = donation['duration'],
        this.cqi = donation['cqi'],
        this.snr = donation['snr'],
        this.validCount = donation['validcount'],
        this.resourceId = donation['resourceid'],
        this.url = donation['url'];
}
