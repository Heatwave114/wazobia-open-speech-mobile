// Core
import 'dart:io';

// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path;

// Internal
import '../resources.dart';
import '../models/donation.dart';
import '../providers/user.dart';

void downloadAllDonations() async {
  final QuerySnapshot allDonationsSnapshot =
      await Firestore.instance.collection('unvalidated').getDocuments();
  final mainDirectory = await path.getExternalStorageDirectory();
  final List urls = [];
  for (var document in allDonationsSnapshot.documents) {
    // final Donation donation = Donation.fromFireStore(document);
    print(document['url']);
    // final http.Response response = await http.get(donation.url);
    // final Directory fullDirectory =
    //     Directory('$mainDirectory/${donation.name.substring(0, 5)}');

    // if ((await fullDirectory.exists())) {
    //   File('$fullDirectory/${donation.name}.aac')
    //       .writeAsBytes(response.bodyBytes);
    //   print(donation.url);
    // } else {
    //   fullDirectory.create().then((fullDirectory) =>
    //       File('${fullDirectory.path}/${donation.name}.aac')
    //           .writeAsBytes(response.bodyBytes));
    //   print(donation.url);
    // }

  }
  File('${mainDirectory.path}/urls.txt').writeAsBytes(urls);
  print((await path.getApplicationDocumentsDirectory()).path);
}

void uploadAllResources() {
  final databaseRoot = User().databaseRoot;
  for (var resource in Resources) {
    if (resource.paperName != null &&
        resource.paperDate != null &&
        resource.author != null) {
      databaseRoot.collection('resources').document(resource.uid).setData({
        'title': resource.title,
        'author': resource.author,
        'genre': resource.genre,
        'text': resource.text,
        'readtimesecs': resource.readTime.inSeconds,
        'papername': resource.paperName,
        'paperdate': resource.paperDate,
        'credit': resource.credit,
      });
    } else if (resource.paperName != null &&
        resource.paperDate != null &&
        resource.author == null) {
      databaseRoot.collection('resources').document(resource.uid).setData({
        'title': resource.title,
        'genre': resource.genre,
        'text': resource.text,
        'readtime': resource.readTime.inSeconds,
        'credit': resource.credit,
      });
    } else {
      databaseRoot.collection('resources').document(resource.uid).setData({
        'title': resource.title,
        'author': resource.author,
        'genre': resource.genre,
        'text': resource.text,
        'readtime': resource.readTime.inSeconds,
        'credit': resource.credit,
      });
    }
  }
}
