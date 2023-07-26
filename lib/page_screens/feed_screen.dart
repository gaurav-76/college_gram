import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/utils/colors.dart';
import 'package:college_gram_app/utils/global_variables.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:college_gram_app/widgets/post_card_copy.dart';


class FeedScreen1 extends StatefulWidget {
  const FeedScreen1({Key? key}) : super(key: key);

  @override
  State<FeedScreen1> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen1> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: width > webScreenSize
          ? webBackgroundColor
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              toolbarHeight: 75.0,
              // title: Text(
              //   "LOGO",
              // ),
              elevation: 0.0,
              title: Image.asset(
                "assets/logo.png",
                //color: Theme.of(context).primaryColor,
                height: 35,
              ),
              centerTitle: true,
              leading: const Icon(
                CupertinoIcons.bell_circle_fill,
                color: Colors.black,
                size: 38.0,
              ).p16(),
              actions: [
                //const ChangeThemeButtonWidget(),
                IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: "Messaging not suppported yet"
                            .text
                            .size(14.0)
                            .make()));
                  },
                  icon: const Icon(
                    Icons.message,
                    size: 32.0,
                  ),
                ).p16(),
              ],
            ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                   color: Colors.black,
                ),
              );
            }
            return snapshot.data!.docs.isEmpty
                ? const Center(
                    child: Text(
                    'No Post',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))
                : Column(
                    children: [
                      buildHeader(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  width > webScreenSize ? width * 0.3 : 0,
                              vertical: width > webScreenSize ? 10 : 0,
                            ),
                            child: PostCard1(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          }),
    );
  }

  Widget buildHeader() => Container(
      //height: 60.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Hey, Let See What's Going in "
              .text
              .xl2
              .bold
              // .color(context.theme.accentColor)
              .color(Colors.black)
              .make(),
          "Your College".text.xl2.bold.color(Colors.orange).make(),
        ],
      ).px32().pOnly(bottom: 10.0));
  
}
