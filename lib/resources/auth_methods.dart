import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: library_prefixes
import 'package:college_gram_app/model/users.dart' as userModel;
import 'package:college_gram_app/model/user_profile/profile.dart' as pr;
import 'package:college_gram_app/model/user_profile/about.dart' as abt;
import 'package:college_gram_app/model/user_profile/education.dart' as edu;
import 'package:college_gram_app/model/user_profile/experience.dart' as exp;
import 'package:college_gram_app/model/user_profile/certification.dart' as cert;

import 'package:college_gram_app/model/user_profile/skill.dart' as skl;

import 'package:college_gram_app/model/user_profile/achievement.dart' as ach;

import 'package:college_gram_app/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<userModel.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return userModel.User.fromSnap(snap);
  }

  //SignUp User
  Future<String> signUpUser({
    required String name,
    required String email,
    required String password,
    // ignore: non_constant_identifier_names
    required String confirm_pass,
    required String choice,
    Uint8List? file,
  }) async {
    String res = "Some error occurred";

    if (file == null) {
      return res = "Please chosse profile image.";
    }

    try {
      if (password != confirm_pass) {
        return res = "Password and Confirm Password doesn't match.";
      } else if (name.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          confirm_pass.isNotEmpty ||
          choice.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          file != null) {
        //Register User
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        print(userCredential.user!.uid);
        //Add user to our database

        userModel.User user = userModel.User(
            name: name,
            email: email,
            uid: userCredential.user!.uid,
            choice: choice,
            phototUrl: photoUrl);

        //Using this method UsersId and docId would be same
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());


        res = "success";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'weak-password':
          return res = 'The password provided is too weak.';
        case 'society-already-in-use':
          return res = 'The account for selected society already exists.';
        case 'email-already-in-use':
          return res = 'The account already exists for that email.';
      }
      // return res = 'Unexpected firebase error, Please try again.';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //Logging in user
  Future<String> loginUser(
      {
        required String email, required String password}) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return res = 'Invalid email address.';

        case 'wrong-password':
          return res = 'Wrong password.';
        case 'user-not-found':
          return res = 'No user corresponding to the given email address.';
        case 'user-disabled':
          return res = 'This user has been disabled.';
        case 'too-many-requests':
          return res = 'Too many attempts to sign in as this user.';
      }
      // return res = 'Unexpected firebase error, Please try again.';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }


  // Student Profile Section

  // Profile Detail
  Future<String> profile({
    required String uid,
    required String enrollment,
    required String branch,
    required String section,
  }) async {
    String res = "Some error occurred";

    try {
      if (enrollment.isNotEmpty && branch.isNotEmpty && section.isNotEmpty) {
        pr.Profile user = pr.Profile(
          uid: uid,
          enrollment: enrollment,
          branch: branch,
          section: section,
        );

        //var userCredential;
        await _firestore.collection('profile').doc(uid).set(user.toJson());

        res = "Profile detail updated successfully!";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // About
  Future<String> about({
    required String uid,
    required String about,
  }) async {
    String res = "Some error occurred";

    try {
      if (about.isNotEmpty) {
        abt.About user = abt.About(uid: uid, about: about);

        //var userCredential;
        await _firestore.collection('about').doc(uid).set(user.toJson());

        res = "About detail updated successfully!";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Education Detail
  Future<String> education({
    required String uid,
    required String degree,
    required String duration,
    required String cgpa,
  }) async {
    String res = "Some error occurred";

    try {
      if (degree.isNotEmpty && duration.isNotEmpty && cgpa.isNotEmpty) {
        edu.Education user = edu.Education(
            uid: uid, degree: degree, duration: duration, cgpa: cgpa);

        //var userCredential;
        await _firestore.collection('education').doc(uid).set(user.toJson());

        res = "Education detail updated successfully!";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Expereince Detail
  Future<String> experience(
      {required String uid,
      required String company,
      required String cduration,
      required String role,
      required String workExperience}) async {
    String res = "Some error occurred";

    try {
      if (company.isNotEmpty &&
          cduration.isNotEmpty &&
          role.isNotEmpty &&
          workExperience.isNotEmpty) {
        exp.Experience user = exp.Experience(
            uid: uid,
            company: company,
            cduration: cduration,
            role: role,
            workExperience: workExperience);

        //var userCredential;
        await _firestore.collection('experience').doc(uid).set(user.toJson());

        res = "Internship detail updated successfully!";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Certification Detail
  Future<String> certification({
    required String uid,
    required String course_name,
    required String course_duration,
    required String link,
  }) async {
    String res = "Some error occurred";

    try {
      if (course_name.isNotEmpty &&
          course_duration.isNotEmpty &&
          link.isNotEmpty) {
        cert.Certification user = cert.Certification(
          uid: uid,
          course_name: course_name,
          course_duration: course_duration,
          link: link,
        );

        //var userCredential;
        await _firestore
            .collection('certification')
            .doc(uid)
            .set(user.toJson());

        res = "Certification detail updated successfully!";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Skill Detail
  Future<String> skill({
    required String uid,
    required String skill,
  }) async {
    String res = "Some error occurred";

    try {
      if (skill.isNotEmpty) {
        skl.Skill user = skl.Skill(
          uid: uid,
          skill: skill,
        );

        //var userCredential;
        await _firestore.collection('skills').doc(uid).set(user.toJson());

        res = "Skill detail updated successfully!";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Achievement Detail
  Future<String> achievement({
    required String uid,
    required String achievement,
  }) async {
    String res = "Some error occurred";

    try {
      if (achievement.isNotEmpty) {
        ach.Achievement user = ach.Achievement(
          uid: uid,
          achievement: achievement,
        );

        //var userCredential;
        await _firestore.collection('achievements').doc(uid).set(user.toJson());

        res = "Achievements detail updated successfully!";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
