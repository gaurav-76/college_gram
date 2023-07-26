import 'package:cloud_firestore/cloud_firestore.dart';

class About {
  final String uid;
  final String about;
  //final String resume;

  const About({
    required this.uid,
    required this.about,
    //required this.resume,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'about': about,
        //'resume': resume,
      };

  static About fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return About(uid: snapshot['uid'], about: snapshot['about']);
  }
}
