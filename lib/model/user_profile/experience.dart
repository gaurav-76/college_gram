import 'package:cloud_firestore/cloud_firestore.dart';

class Experience{
  final String uid;
  final String company;
  final String cduration;
  final String role;
  final String workExperience;

  const Experience({
    required this.uid,
    required this.company,
    required this.cduration,
    required this.role,
    required this.workExperience,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'company': company,
        'cduration': cduration,
        'role': role,
        'workExperience': workExperience,
      };

  static Experience fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Experience(
        uid: snapshot['uid'],
        company: snapshot['company'],
        cduration: snapshot['cduration'],
        role: snapshot['role'],
        workExperience: snapshot['workExperience']);
  }
}
