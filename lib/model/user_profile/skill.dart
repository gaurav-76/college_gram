import 'package:cloud_firestore/cloud_firestore.dart';

class Skill{
  final String uid;
  final String skill;

  const Skill({
    required this.uid,
    required this.skill,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'skill': skill,
      };

  static Skill fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Skill(
        uid: snapshot['uid'],
        skill: snapshot['skill']);
  }
}
