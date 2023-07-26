import 'package:college_gram_app/page_screens/profile_screen_society.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_gram_app/page_screens/add_post_screen.dart';
import 'package:college_gram_app/page_screens/events_meetings/screens/event_main.dart';
import 'package:college_gram_app/page_screens/feed_screen.dart';
import 'package:college_gram_app/page_screens/notice/notice_list.dart';
import 'package:college_gram_app/page_screens/profile_screen_user.dart';

const webScreenSize = 600;

List<Widget> homeScreenItemsSt = [
  FeedScreen1(),
  NoticeList(),
  EventScreen(),
  ProfileScreenUser(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

List<Widget> homeScreenItemsSo = [
  FeedScreen1(),
  NoticeList(),
  AddPostScreen(),
  EventScreen(),
  
  ProfileScreenSociety(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
