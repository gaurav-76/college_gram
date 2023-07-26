import 'package:flutter/material.dart';
import 'package:college_gram_app/model/users.dart';
import 'package:college_gram_app/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? _user1; //Must be private variable tp prevent bugs
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;
  //User get getUser => _user1!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}
