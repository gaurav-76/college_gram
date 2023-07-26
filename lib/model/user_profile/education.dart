import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  final String uid;
  final String degree;
  final String duration;
  final String cgpa;
 

  const Education({
    required this.uid,
    required this.degree,
    required this.duration,
    required this.cgpa,
    
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'degree': degree,
        'duration': duration,
        'cgpa': cgpa,
      };

  static Education fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Education(
        uid: snapshot['uid'],
        degree: snapshot['degree'],
        duration: snapshot['duration'],
        cgpa: snapshot['cgpa']);
  }
}
