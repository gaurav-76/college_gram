import 'package:cloud_firestore/cloud_firestore.dart';

class Notices {
  final String title;
  final String description;
  final String uid;
  final String name;
  final String noticeId;
  final datePublished;
  final String noticeUrl;


  Notices({
    required this.title,
    required this.description,
    required this.uid,
    required this.name,
    required this.noticeId,
    required this.datePublished,
    required this.noticeUrl,
  
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'uid': uid,
        'name': name,
        'noticeId': noticeId,
        'datePublished': datePublished,
        'postUrl': noticeUrl,
      };

  static Notices fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Notices(
      title: snapshot['title'],
      description: snapshot['description'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      datePublished: snapshot['datePublished'],
      noticeId: snapshot['postId'],
      noticeUrl: snapshot['postUrl'],
    );
  }
}
