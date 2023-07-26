import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram_app/page_screens/setting.dart';
import 'package:college_gram_app/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/resources/auth_methods.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreenUser extends StatefulWidget {
  final String uid;
  const ProfileScreenUser({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  _ProfileScreenUserState createState() => _ProfileScreenUserState();
}

class _ProfileScreenUserState extends State<ProfileScreenUser> {
  final String enrollment = "Update Enrollment Number";
  final TextEditingController _enrollment = TextEditingController();

  final String branch = "Update your branch";
  final TextEditingController _branch = TextEditingController();

  final String section = "Update your section";
  final TextEditingController _section = TextEditingController();

  final String about = "Update About";
  final TextEditingController _about = TextEditingController();

  final String degree = "Update Degree";
  final TextEditingController _degree = TextEditingController();

  final String duration = "Update Duration";
  final TextEditingController _duration = TextEditingController();

  final String cgpa = "Update CGPA";
  final TextEditingController _cgpa = TextEditingController();

  final String company_name = "Update Company Name";
  final TextEditingController _company_name = TextEditingController();

  final String role = "Update Your Role";
  final TextEditingController _role = TextEditingController();

  final String cduration = "Update Company Duration";
  final TextEditingController _cduration = TextEditingController();

  final String experience_infro = "Update Experience Detail";
  final TextEditingController _experience_info = TextEditingController();

  final String course = "Update Course Name";
  final TextEditingController _course = TextEditingController();

  final String course_duration = "Update Course Duration";
  final TextEditingController _course_duration = TextEditingController();

  final String certificate_link = "Update CGPA";
  final TextEditingController _certificate_link = TextEditingController();

  final String skill = "Update Skill Detail";
  final TextEditingController _skill = TextEditingController();

  final String achievement = "Update Achievement Detail";
  final TextEditingController _achievement = TextEditingController();
  
  

  var userData = {};
  bool isLoading = false;
  var profileData = {};
  var aboutData = {};
  var educationData = {};
  var experienceData = {};
  var certificationData = {};
  var skillData = {};
  var achievementData = {};

  @override
  void initState() {
    super.initState();
    getData();
  }
  
  Uint8List? _image;
  selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
      
    });
     String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', _image!, false);

     userData['photourl'] = photoUrl;       
  }
  
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      userData = userSnapshot.data()!;

      var profileSnap = await FirebaseFirestore.instance
          .collection("profile")
          .doc(widget.uid)
          .get();

      profileData = profileSnap.data()!;

      var aboutSnap = await FirebaseFirestore.instance
          .collection("about")
          .doc(widget.uid)
          .get();

      aboutData = aboutSnap.data()!;

      var educationSnap = await FirebaseFirestore.instance
          .collection("education")
          .doc(widget.uid)
          .get();

      educationData = educationSnap.data()!;

      var experienceSnap = await FirebaseFirestore.instance
          .collection("experience")
          .doc(widget.uid)
          .get();

      experienceData = experienceSnap.data()!;

      var certificationSnap = await FirebaseFirestore.instance
          .collection("certification")
          .doc(widget.uid)
          .get();

      certificationData = certificationSnap.data()!;

      var skillSnap = await FirebaseFirestore.instance
          .collection("skills")
          .doc(widget.uid)
          .get();

      skillData = skillSnap.data()!;

      var achievementSnap = await FirebaseFirestore.instance
          .collection("achievements")
          .doc(widget.uid)
          .get();

      achievementData = achievementSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  // Profile
  saveProfile(
    String uid,
  ) async {
    try {
      String res = await AuthMethods().profile(
          uid: uid,
          enrollment: _enrollment.text,
          branch: _branch.text,
          section: _section.text);
      showSnackBar(res, context);

      //setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // About
  saveAbout(
    String uid,
  ) async {
    try {
      String res = await AuthMethods().about(uid: uid, about: _about.text);
      showSnackBar(res, context);

      //setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // Education
  saveEducation(
    String uid,
  ) async {
    try {
      String res = await AuthMethods().education(
          uid: uid,
          degree: _degree.text,
          duration: _duration.text,
          cgpa: _cgpa.text);
      showSnackBar(res, context);

      //setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // Save Expereince
  saveExperience(
    String uid,
  ) async {
    try {
      String res = await AuthMethods().experience(
          uid: uid,
          company: _company_name.text,
          cduration: _cduration.text,
          role: _role.text,
          workExperience: _experience_info.text);
      showSnackBar(res, context);

      //setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // Save Certification
  saveCertification(
    String uid,
  ) async {
    try {
      String res = await AuthMethods().certification(
        uid: uid,
        course_name: _course.text,
        course_duration: _course_duration.text,
        link: _certificate_link.text,
      );
      showSnackBar(res, context);

      //setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // Save Skill
  saveSkill(
    String uid,
  ) async {
    try {
      String res = await AuthMethods().skill(
        uid: uid,
        skill: _skill.text,
      );
      showSnackBar(res, context);

      //setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // Save Achievement
  saveAchievement(
    String uid,
  ) async {
    try {
      String res = await AuthMethods().achievement(
        uid: uid,
        achievement: _achievement.text,
      );
      showSnackBar(res, context);

      //setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // void dispose() {
  //   super.dispose();
  //   getData();
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
               color: Colors.black,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: false,
              leading: const BackButton(color: Colors.black),
              actions: [
                IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Setting()))
                  },
                  icon: Icon(Icons.settings),
                                  ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      
                      userData["photoUrl"] != null ?  Stack(
                        children: [
                         CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 47, 47, 47),
                          backgroundImage: NetworkImage(
                            userData["photoUrl"],
                          ),
                          radius: 64,
                        ),
                        Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => selectImage(),
                          icon: const Icon(Icons.add_a_photo),
                          color: Colors.red,
                        ))
                        ]
                      ):Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64, backgroundImage: MemoryImage(_image!))
                            
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage('assets/profile_pic.png'),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => selectImage(),
                          icon: const Icon(Icons.add_a_photo),
                          color: Colors.red,
                        ))
                  ],
                ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              userData["name"],
                              //userData["email"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text('Profile',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              trailing: Column(children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () => showDialog(
                                      context: this.context,
                                      builder: (ctx) => SingleChildScrollView(
                                        child: AlertDialog(
                                          title: const Text("Profile Detail"),
                                          content: Column(
                                            children: [
                                              buildTextField(
                                                  controller: _enrollment,
                                                  hint:
                                                      'Enter Enrollment Number'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField(
                                                  controller: _branch,
                                                  hint: 'Enter your branch'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField(
                                                  controller: _section,
                                                  hint: 'Enter your section'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: ElevatedButton(
                                                child: const Text("Update"),
                                                onPressed: () {
                                                  setState(() async {
                                                    saveProfile(
                                                        userData['uid']);

                                                    Navigator.pop(this.context);

                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             ProfileScreen(
                                                    //                 uid: userData[
                                                    //                     'uid'])));
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Enrollment Number : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: profileData.isEmpty
                                          ? enrollment
                                          : profileData['enrollment'],
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),

                            //  Text(
                            //   profileData.isEmpty
                            //       ? enrollment
                            //       : profileData['enrollment'],
                            //   style: TextStyle(fontSize: 16),
                            // ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Branch : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: profileData.isEmpty
                                          ? branch
                                          : profileData['branch'],
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Section : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: profileData.isEmpty
                                          ? section
                                          : profileData['section'],
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text('About',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              trailing: Column(children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () => showDialog(
                                      context: this.context,
                                      builder: (ctx) => SingleChildScrollView(
                                        child: AlertDialog(
                                          title: const Text("About Detail"),
                                          content: Column(
                                            children: [
                                              buildTextField1(
                                                  controller: _about,
                                                  hint: 'Enter About'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: ElevatedButton(
                                                child: const Text("Update"),
                                                onPressed: () {
                                                  setState(() async {
                                                    saveAbout(userData['uid']);

                                                    Navigator.pop(this.context);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              aboutData.isEmpty ? about : aboutData['about'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text('Education',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              trailing: Column(children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () => showDialog(
                                      context: this.context,
                                      builder: (ctx) => SingleChildScrollView(
                                        child: AlertDialog(
                                          title: const Text("Education Detail"),
                                          content: Column(
                                            children: [
                                              buildTextField(
                                                  controller: _degree,
                                                  hint: 'Enter Degree'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField(
                                                  controller: _duration,
                                                  hint: 'Enter Duration'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField(
                                                  controller: _cgpa,
                                                  hint: 'Enter CGPA'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: ElevatedButton(
                                                child: const Text("Update"),
                                                onPressed: () {
                                                  setState(() {
                                                    saveEducation(
                                                        userData['uid']);
                                                  });
                                                  Navigator.pop(this.context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                          // Text('Education',
                          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              educationData.isEmpty
                                  ? degree
                                  : educationData['degree'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: Text(
                              educationData.isEmpty
                                  ? duration
                                  : educationData['duration'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              //'cgpa : ' + {
                              educationData.isEmpty
                                  ? cgpa
                                  : educationData["cgpa"],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text('Experience',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              trailing: Column(children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () => showDialog(
                                      context: this.context,
                                      builder: (ctx) => SingleChildScrollView(
                                        child: AlertDialog(
                                          title:
                                              const Text("Internship Detail"),
                                          content: Column(
                                            children: [
                                              buildTextField(
                                                  controller: _company_name,
                                                  hint: 'Enter Company Name'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField(
                                                  controller: _role,
                                                  hint: 'Enter Your Role'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField(
                                                  controller: _cduration,
                                                  hint: 'Enter Duration'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField1(
                                                  controller: _experience_info,
                                                  hint:
                                                      'Enter your experience'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: ElevatedButton(
                                                child: const Text("Update"),
                                                onPressed: () {
                                                  setState(() {
                                                    saveExperience(
                                                        userData['uid']);
                                                  });
                                                  Navigator.pop(this.context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              experienceData.isEmpty
                                  ? company_name
                                  : experienceData['company'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: Text(
                              experienceData.isEmpty
                                  ? cduration
                                  : experienceData['cduration'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: Text(
                              experienceData.isEmpty
                                  ? role
                                  : experienceData['role'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: Text(
                              experienceData.isEmpty
                                  ? experience_infro
                                  : experienceData['workExperience'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text('Certifications',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              trailing: Column(children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () => showDialog(
                                      context: this.context,
                                      builder: (ctx) => SingleChildScrollView(
                                        child: AlertDialog(
                                          title: const Text("Course Detail"),
                                          content: Column(
                                            children: [
                                              buildTextField(
                                                  controller: _course,
                                                  hint: 'Enter course name'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField(
                                                  controller: _course_duration,
                                                  hint:
                                                      'Enter course Duration'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              buildTextField(
                                                  controller: _certificate_link,
                                                  hint:
                                                      'Enter certificate link'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: ElevatedButton(
                                                child: const Text("Update"),
                                                onPressed: () {
                                                  setState(() {
                                                    saveCertification(
                                                        userData['uid']);
                                                  });
                                                  Navigator.pop(this.context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                          // Text('Education',
                          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              certificationData.isEmpty
                                  ? course
                                  : certificationData['course_name'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: Text(
                              certificationData.isEmpty
                                  ? course_duration
                                  : certificationData['course_duration'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 10.0),
                            child: Text(
                              //'Link : $certificate_link',
                              certificationData.isEmpty
                                  ? certificate_link
                                  : certificationData['link'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text('Skills',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              trailing: Column(children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () => showDialog(
                                      context: this.context,
                                      builder: (ctx) => SingleChildScrollView(
                                        child: AlertDialog(
                                          title: const Text("Skills Detail"),
                                          content: Column(
                                            children: [
                                              buildTextField1(
                                                  controller: _skill,
                                                  hint: 'Enter skills'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: ElevatedButton(
                                                child: const Text("Update"),
                                                onPressed: () {
                                                  setState(() {
                                                    saveSkill(userData['uid']);
                                                  });
                                                  Navigator.pop(this.context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              skillData.isEmpty ? skill : skillData['skill'],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text('Achievements',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              trailing: Column(children: <Widget>[
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.black,
                                    onPressed: () => showDialog(
                                      context: this.context,
                                      builder: (ctx) => SingleChildScrollView(
                                        child: AlertDialog(
                                          title:
                                              const Text("Achievements Detail"),
                                          content: Column(
                                            children: [
                                              buildTextField1(
                                                  controller: _achievement,
                                                  hint: 'Enter Achievements'),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(this.context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: ElevatedButton(
                                                child: const Text("Update"),
                                                onPressed: () {
                                                  setState(() {
                                                    saveAchievement(
                                                        userData['uid']);
                                                  });
                                                  Navigator.pop(this.context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              achievementData.isEmpty
                                  ? achievement
                                  : achievementData['achievement'],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 47, 47, 47)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 47, 47, 47)),
          ),
        )
      ],
    );
  }

  Widget buildTextField({String? hint, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        labelText: hint ?? '',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
      ),
    );
  }

  Widget buildTextField1({String? hint, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      //textAlign: TextAlign.left,
      maxLines: 8,
      decoration: InputDecoration(
        labelText: hint ?? '',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        hintTextDirection: TextDirection.ltr,
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    Widget? child,
    double? all,
    Color? color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all!),
          color: color,
          child: child,
        ),
      );
}
