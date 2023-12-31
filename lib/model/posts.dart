import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String description;
  final String uid;
  final String name;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Posts({
    required this.description,
    required this.uid,
    required this.name,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
     required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'name': name,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
      };

  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Posts(
      description: snapshot['description'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
