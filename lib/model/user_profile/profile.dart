import 'package:cloud_firestore/cloud_firestore.dart';

class Profile{
  final String uid;
  final String enrollment;
  final String branch;
  final String section;

  const Profile({
    required this.uid,
    required this.enrollment,
    required this.branch,
    required this.section
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'enrollment': enrollment,
        'branch': branch,
        'section': section,
      };

  static Profile fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Profile(
        uid: snapshot['uid'],
        enrollment: snapshot['enrollment'],
        branch: snapshot['branch'],
        section: snapshot['section']);
  }
}
