import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram_app/page_screens/setting.dart';
import 'package:college_gram_app/widgets/gridview_post_card.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/storage_methods.dart';

class ProfileScreenSociety extends StatefulWidget {
  final String uid;
  const ProfileScreenSociety({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  _ProfileScreenSocietyState createState() => _ProfileScreenSocietyState();
}

class _ProfileScreenSocietyState extends State<ProfileScreenSociety> {
  var userData = {};
  int postLen = 0;
  bool isLoading = false;
  
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
      //Get post length

      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final UserProvider userProvider = Provider.of<UserProvider>(context);

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
                       userData['uid'] == userProvider.getUser.uid ? Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => selectImage(),
                          icon: const Icon(Icons.add_a_photo),
                          color: Colors.red,
                        )): Text('')
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
                    userData['uid'] == userProvider.getUser.uid ? Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => selectImage(),
                          icon: const Icon(Icons.add_a_photo),
                          color: Colors.red,
                        )) : Text(' ')
                  ],
                ),
                      // CircleAvatar(
                      //   backgroundColor: Color(0xFFd9d9d9),
                      //   radius: 65.0,
                      //   child: CircleAvatar(
                      //     backgroundImage: NetworkImage(
                      //       userData["photoUrl"],
                      //     ),
                      //     radius: 60.0,
                      //   ),
                      // ),
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
                      buildStatColumn(postLen, 'Posts')
                    ],
                  ),
                ),
                (postLen > 0)
                    ? FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("posts")
                            .where("uid", isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                 color: Colors.black,
                              ),
                            );
                          }

                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                return SingleChildScrollView(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => GridPostCard(
                                            snap: snap,
                                          ),
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Image(
                                            image:
                                                NetworkImage(snap['postUrl']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )),
                                );
                              });
                        })
                    : const Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          'No Post',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      )),
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
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
