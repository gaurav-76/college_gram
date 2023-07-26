import 'package:cloud_firestore/cloud_firestore.dart';

class Achievement{
  final String uid;
  final String achievement;

  const Achievement({
    required this.uid,
    required this.achievement,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'achievement': achievement,
      };

  static Achievement fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Achievement(
        uid: snapshot['uid'],
        achievement: snapshot['achievement']);
  }
}
