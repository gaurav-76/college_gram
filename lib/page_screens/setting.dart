import 'package:college_gram_app/page_screens/login/change_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../resources/auth_methods.dart';
import 'login_screen.dart';

class Setting extends StatefulWidget {
  const Setting({
    Key? key,
  }) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w600),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangePassword()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Change Password',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                )),
            Divider(),
            GestureDetector(
                onTap: () => showDialog(
                    context: this.context,
                    builder: (ctx) => Theme(
                        data: ThemeData.dark(),
                        child: CupertinoAlertDialog(
                          title: Text("Log out?"),
                          content: Text("Are you sure you want to log out?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                            CupertinoDialogAction(
                                textStyle: TextStyle(color: Colors.red),
                                isDefaultAction: true,
                                onPressed: () async {
                                  AuthMethods().signOut();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: "Successfully Logout"
                                              .text
                                              .size(14.0)
                                              .make()));
                                },
                                child: Text("Log out")),
                          ],
                        ))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Logout',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold)),
                )),
            Divider()
          ],
        ),
      ),
    );
  }
}
