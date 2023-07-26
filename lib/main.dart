import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:college_gram_app/providers/user_provider.dart';
import 'package:college_gram_app/responsive/mobile_screen_layout.dart';
import 'package:college_gram_app/responsive/responsive_layout_screen.dart';
import 'package:college_gram_app/responsive/web_screen_layout.dart';
import 'package:college_gram_app/page_screens/login_screen.dart';
import 'package:college_gram_app/utils/my_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyANL7Rm1gdRowSR8wlQC4mv-F32JoYfws8",
            projectId: "project-collegegram",
            storageBucket: "project-collegegram.appspot.com",
            messagingSenderId: "914179950148",
            appId: "1:914179950148:web:8c0bcad0ee3379832f5e11"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      builder: (context, _) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Collegegram',
            theme: MyTheme.lightTheme(),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponsiveLayout(
                        webScreenLayout: WebSreenLayout(),
                        mobileScreenLayout: MobileScreenLayout());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }

                return const LoginScreen();
              },
            ));
      },
    );
  }
}
