
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gram_app/page_screens/profile_screen_society.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/model/users.dart';
import 'package:college_gram_app/providers/user_provider.dart';
import 'package:college_gram_app/resources/firestore_methods.dart';
import 'package:college_gram_app/page_screens/comments_screen.dart';
import 'package:college_gram_app/utils/colors.dart';
import 'package:college_gram_app/utils/global_variables.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class GridPostCard extends StatefulWidget {
  final snap;
  const GridPostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<GridPostCard> createState() => _GridPostCard();
}

class _GridPostCard extends State<GridPostCard> {
  int commentsLength = 0;
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
    getComments();
    if (widget.snap['description'].length > 150) {
      firstHalf = widget.snap['description'].substring(0, 150);
      secondHalf = widget.snap['description']
          .substring(50, widget.snap['description'].length);
    } else {
      firstHalf = widget.snap['description'];
      secondHalf = "";
    }
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap['postId'])
          .collection("comments")
          .get();

      commentsLength = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const BackButton(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: MediaQuery.of(context).size.width > webScreenSize
                        ? secondaryColor
                        : primaryColor),
                color: Theme.of(context).scaffoldBackgroundColor),
            padding: const EdgeInsets.symmetric(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 35.0),
              child: Card(
                elevation: 4.0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, top: 20.0),
                        child: Row(
                          children: [
                            
                            CircleAvatar(
                              backgroundColor: Color(0xFFd9d9d9),
                              radius: 20.0,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  widget.snap["profImage"],
                                ),
                                radius: 15.0,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      child: Text(
                                        //widget.snap['username'],
                                        widget.snap['name'],
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          //textStyle: TextStyle(color: Colors.black),
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreenSociety(
                                                      uid: widget.snap['uid'])),
                                        );
                                      },
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        //widget.snap['username'],
                                        'Bhagwan Parshuram Institute Of Technology',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          //textStyle: TextStyle(color: Colors.black),
                                          fontSize: 11.0,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreenSociety(
                                                      uid: widget.snap['uid'])),
                                        );
                                      },
                                    ),
                                    Container(
                                      child: Text(
                                        DateFormat.yMMMd().format(
                                          widget.snap['datePublished'].toDate(),
                                        ),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: secondaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  widget.snap['uid'] == user.uid
                                      ? showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: ListView(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shrinkWrap: true,
                                              children: [
                                                'Delete',
                                              ]
                                                  .map(
                                                    (e) => InkWell(
                                                      onTap: () async {
                                                        String res =
                                                            await FirestoreMethods()
                                                                .deletePost(widget
                                                                        .snap[
                                                                    'postId']);
                                                        Navigator.of(context)
                                                            .pop();
                                                        if (res == 'success') {
                                                          showSnackBar(
                                                              "Post deleted.",
                                                              context);
                                                        } else {
                                                          showSnackBar(
                                                              res, context);
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 16),
                                                        child: Text(e),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        )
                                      : showSnackBar(
                                          "You cannot delete this post.",
                                          context);
                                },
                                icon: const Icon(Icons.more_vert))
                          ],
                        ),
                      ),
                    ),

                    //Description & No. of comments
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 8),
                              
                              child: secondHalf.isEmpty
                                  ? Text(
                                      firstHalf,
                                    )
                                  : Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            flag
                                                ? ("$firstHalf...")
                                                : (firstHalf + secondHalf),
                                            style: TextStyle(height: 1.5),
                                          ),
                                        ),
                                        InkWell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                flag
                                                    ? "show more"
                                                    : "show less",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              flag = !flag;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                             
                             
                            ),

                            
                          ],
                        ),
                      ),
                    ),
                    //Image Section
                    GestureDetector(
                     
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InteractiveViewer(
                            panEnabled:
                                false, // Set it to false to prevent panning.
                            boundaryMargin: EdgeInsets.all(80),
                            //minScale: 0.5,
                            maxScale: 4,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.50,
                              width: double.infinity,
                              child: Image.network(
                                widget.snap['postUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Likes Comment Scetion
                    Divider(),
                    Row(
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton.icon(
                            // <-- TextButton
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                snap: widget.snap,
                              ),
                            )),
                            icon: const Icon(
                              Icons.comment,
                              size: 24.0,
                              color: Color.fromARGB(255, 113, 112, 112),
                            ),
                            label: const Text(
                              'Comment',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 113, 112, 112)),
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                snap: widget.snap,
                              ),
                            )),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "$commentsLength comments",
                                style: const TextStyle(
                                    fontSize: 16, color: secondaryColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
