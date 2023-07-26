import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFile {
  
  final String uid;
  final String description;
  final String noticeId;
  final datePublished;
  final Reference ref;
  final String name;
  final String url;

  const FirebaseFile({
     required this.uid,
     required this.description,
     required this.noticeId,
     required this.datePublished,
     required this.ref,
     required this.name,
     required this.url,
  });

  Map<String, dynamic> toJson() => {       
        'uid': uid,
        'description': description,
        'noticeId': noticeId,
        'datePublished': datePublished,
        'noticeurl': url,
        'ref':ref,
        'name':name
      };
  static FirebaseFile fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return FirebaseFile(
      uid: snapshot['uid'],
      description: snapshot['description'],
      noticeId: snapshot['noticeId'],
      datePublished: snapshot['datePublished'],
      url: snapshot['url'],
      ref: snapshot['ref'],
      name: snapshot['name'],
    );
  }
}