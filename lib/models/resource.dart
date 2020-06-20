// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Resource {
  final String uid;
  final String title;
  final String author;
  final String genre;
  final String text;
  final Duration readTime;
  final String paperName;
  final String paperDate;
  final String credit;

  const Resource({
    @required this.uid,
    @required this.title,
    this.author,
    @required this.genre,
    @required this.text,
    @required this.readTime,
    this.paperName,
    this.paperDate,
    this.credit,
  });

  Resource.fromFireStore(DocumentSnapshot resource)
      : uid = resource.documentID,
        title = resource['title'],
        author = resource['author'],
        genre = resource['genre'],
        text = resource['text'],
        readTime = Duration(seconds: resource['readtime'] as int),
        paperName = resource['papername'],
        paperDate = resource['paperdate'],
        credit = resource['credit']??'';

  Map<String, dynamic> get resourceAsMap {
    return {
      'uid': this.uid,
      'title': this.title,
      'genre': this.genre,
      'text': this.text,
      'readtime': this.readTime,
    };
  }

  String get formatedReadTime {
    final imin = this.readTime.inMinutes.toString();
    final isec = (this.readTime.inSeconds % 60).toString();
    final omin =
        imin == '0' ? '' : (imin + 'min${(int.parse(imin) == 1) ? '' : 's'}');
    final osec =
        isec == '0' ? '' : (isec + 'sec${(int.parse(isec) == 1) ? '' : 's'}');

      return omin + ' ' + osec;
  }
}
