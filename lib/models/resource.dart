// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Resource {
  final String uid;
  final String title;
  final String genre;
  final String text;
  final dynamic readTime;

  const Resource({
    @required this.uid,
    @required this.title,
    @required this.genre,
    @required this.text,
    @required this.readTime,
  });

  Resource.fromFireStore(DocumentSnapshot resource)
      : uid = resource.documentID,
        title = resource['title'],
        genre = resource['genre'],
        text = resource['text'],
        readTime = resource['readtime'];
        

  Map<String, dynamic> get resourceAsMap {
    return {
      'uid': this.uid,
      'title': this.title,
      'genre': this.genre,
      'text': this.text,
      'readtime': this.readTime,
    };
  }
}
