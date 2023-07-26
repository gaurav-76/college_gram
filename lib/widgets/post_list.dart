import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/model/posts.dart';
import 'package:college_gram_app/utils/colors.dart';
import 'package:college_gram_app/utils/global_variables.dart';
import 'package:college_gram_app/utils/utils.dart';

import '../page_screens/notice/Upload files Modal/firebase_api.dart';
import '../page_screens/notice/Upload files Modal/firebase_storage.dart';

class PostList extends StatefulWidget {
  final String uid;
  final snap;
  const PostList({Key? key, required this.uid, required this.snap})
      : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Future<List<FirebaseFile>> futureFiles;

  bool isLikeAnimating = false;
  int commentsLength = 0;

  late Map<String, List<Posts>> _post;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll('posts/${widget.snap['uid']}')!;
    getComments();
  }

  void getComments() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("posts")
          .doc()
          .collection("comments")
          .get();

      final postSnap =
          await FirebaseFirestore.instance.collection('posts').get();

      for (var doc in postSnap.docs) {
        final postdata = doc.data();
        if (_post[postdata['uid']] == null) {
          _post[postdata['uid']] = [];
        }

        _post[postdata['uid']]!.add(postdata as Posts);
      }
      commentsLength = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {
      isLoading = false;
    });
  }

  List<Posts> _getPost(String uid) {
    return _post[uid] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    //final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: MediaQuery.of(context).size.width > webScreenSize
                  ? secondaryColor
                  : primaryColor),
          color: Theme.of(context).scaffoldBackgroundColor),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                final files = snapshot.data;

                return files!.isEmpty
                    ? const Text('No Post')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                               
                              },
                            ),
                          ),
                        ],
                      );
              }
          }
        },
      ),
    );
  }
}
