import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String uid;
  final String choice;
  final String phototUrl;

  const User({
    required this.name,
    required this.email,
    required this.uid,
    required this.choice,
    required this.phototUrl,
  });

  Map<String, dynamic> toJson() => {
        'name':name,
        'email': email,
        'uid': uid,
        'choice': choice,
        'photoUrl': phototUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      name: snapshot['name'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      choice: snapshot['choice'],
      phototUrl: snapshot['photoUrl'],
    );
  }
}
