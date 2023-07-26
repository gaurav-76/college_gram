import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/utils/global_variables.dart';

import '../utils/colors.dart';

class WebSreenLayout extends StatefulWidget {
  const WebSreenLayout({Key? key}) : super(key: key);

  @override
  State<WebSreenLayout> createState() => _WebSreenLayoutState();
}

class _WebSreenLayoutState extends State<WebSreenLayout> {
  int _page = 0;
  late PageController pageController;
  String choice = "";

  void getChoice() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      choice = (snapshot.data() as Map<String, dynamic>)['choice'];
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getChoice();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    getChoice();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset(
          "assets/logo.png",
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            icon: const ImageIcon(
              AssetImage('assets/images/home_2.png'),
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(1),
            icon: const ImageIcon(
              AssetImage('assets/images/noticeb.png'),
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(2),
            icon: const ImageIcon(
              AssetImage('assets/images/Event.png'),
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(3),
            icon: const ImageIcon(
              AssetImage('assets/images/profile.png'),
              size: 35,
            ),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: choice == 'Student' ? homeScreenItemsSt : homeScreenItemsSo,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}
