import 'package:cloud_firestore/cloud_firestore.dart';

class Certification {
  final String uid;
  final String course_name;
  final String course_duration;
  final String link;

  const Certification({
    required this.uid,
    required this.course_name,
    required this.course_duration,
    required this.link,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'course_name': course_name,
        'course_duration': course_duration,
        'link': link,
      };

  static Certification fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Certification(
        uid: snapshot['uid'],
        course_name: snapshot['course_name'],
        course_duration: snapshot['course_duration'],
        link: snapshot['link']);
  }
}
