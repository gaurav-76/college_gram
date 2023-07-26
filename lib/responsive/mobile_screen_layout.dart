import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  var userData = {};
  String choice = "";

  @override
  void initState() {
    super.initState();
    //_page = 0;
    pageController = PageController();
    getChoice();
  }

  getChoice() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    userData = snapshot.data()!;

    setState(() {
      choice = (snapshot.data() as Map<String, dynamic>)['choice'];
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    //getChoice.dispose();
    getChoice();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        body: PageView(
          children: choice == 'Student' ? homeScreenItemsSt : homeScreenItemsSo,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,

            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            unselectedItemColor: Colors.white,
            currentIndex: _page, // new
            fixedColor: Color.fromRGBO(255, 153, 0, 1),
            
            items: choice == 'Student'
                ? <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage('assets/images/home_2.png'),
                          size: 35,
                          
                        ),
                        label: 'Home',
                        backgroundColor: Theme.of(context).primaryColor),
                   
                    BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage('assets/images/noticeb.png'),
                          size: 35,
                        ),
                        label: 'Notices',
                        backgroundColor: Theme.of(context).primaryColor),

                    BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage('assets/images/Event.png'),
                          size: 35,
                        ),
                        label: 'Events',
                        backgroundColor: Theme.of(context).primaryColor),
                    BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage('assets/images/profile.png'),
                          size: 35,
                        ),
                        label: 'Profile',
                        backgroundColor: Theme.of(context).primaryColor),
                  ]
                : <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage('assets/images/home_2.png'),
                          size: 35,
                        ),
                        label: 'Home',
                        backgroundColor: Theme.of(context).primaryColor),
                    BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage('assets/images/noticeb.png'),
                          size: 35,
                        ),
                        label: 'Notices',
                        backgroundColor: Theme.of(context).primaryColor),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.add, size: 32),
                        label: 'Post',
                        backgroundColor: Theme.of(context).primaryColor),
                    BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage('assets/images/Event.png'),
                          size: 35,
                        ),
                        label: 'Events',
                        backgroundColor: Theme.of(context).primaryColor),
                    BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage('assets/images/profile.png'),
                          size: 35,
                        ),
                        label: 'Profile',
                        backgroundColor: Theme.of(context).primaryColor),
                  ],
            onTap: navigationTapped,
          ),
        ));
  }
}
