
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/page_screens/notice/notice_card.dart';
import 'package:college_gram_app/page_screens/notice/upload_notice.dart';
import 'package:college_gram_app/utils/global_variables.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';


class NoticeList extends StatefulWidget {
  static final String title = 'Notices';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<NoticeList> {
 
  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(NoticeList.title),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w600),
        centerTitle: true,
      ), //if(user.choice == 'Society' )

      floatingActionButton: userProvider.getUser.choice == 'Society'
          ? FloatingActionButton.extended(
              backgroundColor: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadNotice()),
                );
              },
              label: const Text(' + New Notice'),
            )
          : const Text(''),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('notices')
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
                    'No Notice',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  width > webScreenSize ? width * 0.3 : 0,
                              vertical: width > webScreenSize ? 10 : 0,
                            ),
                            child: NoticeCard(
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
}
