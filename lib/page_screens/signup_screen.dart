import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:college_gram_app/resources/auth_methods.dart';
import 'package:college_gram_app/page_screens/login_screen.dart';
import 'package:college_gram_app/utils/colors.dart';
import 'package:college_gram_app/utils/utils.dart';
import 'package:college_gram_app/widgets/constants.dart';
import 'package:image_picker/image_picker.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

const List<Widget> choices = <Widget>[
  Text('Student'),
  Text('Society'),
];

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Anvesham", child: Text("Anvesham")),
    const DropdownMenuItem(
      value: "Avaran , Dramatic Society Of BPIT",
      child: Text("Avaran , Dramatic Society Of BPIT"),
      //enabled: true,
    ),
    const DropdownMenuItem(
      value: "Bhagwan Parshuram Institute Of Technology",
      child: Text("Bhagwan Parshuram Institute Of Technology"),
      //enabled: false,
    ),
    const DropdownMenuItem(
        value: "Chromavita , Art Society Of BPIT",
        child: Text("Chromavita , Art Society Of BPIT")),
    const DropdownMenuItem(
        value: "CSI , Tech Society Of BPIT",
        child: Text("CSI , Tech Society Of BPIT")),
    const DropdownMenuItem(
        value: "Cultural Committee", child: Text("Cultural Committee")),
    const DropdownMenuItem(
        value: "Dristi , Roctract Club Of BPIT",
        child: Text("Dristi , Roctract Club Of BPIT")),
    const DropdownMenuItem(
        value: "Examination Cell", child: Text("Examination Cell")),
    
    const DropdownMenuItem(
        value: "GDSC (Google Developer Student Clubs)", child: Text("GDSC (Google Developer Student Clubs)")),

    const DropdownMenuItem(
        value: "Hash Define", child: Text("Hash Define")),

    const DropdownMenuItem(
        value: "IEEE , ComSoc BPIT",
        child: Text("IEEE , ComSoc BPIT")),

    const DropdownMenuItem(
        value: "IEEE , Tech Community Of BPIT",
        child: Text("IEEE , Tech Community Of BPIT")),

    const DropdownMenuItem(value: "IOSD", child: Text("IOSD")),
    const DropdownMenuItem(
        value: "Kalam , Literary Society Of BPIT",
        child: Text("Kalam , Literary Society Of BPIT")),
    const DropdownMenuItem(
        value: "Malhar , Annual Fest Of BPIT",
        child: Text("Malhar , Annual Fest Of BPIT")),
    const DropdownMenuItem(
        value: "Mavericks , Dance Society Of BPIT",
        child: Text("Mavericks , Dance Society Of BPIT")),
    const DropdownMenuItem(
        value: "Newton School Coding Club",
        child: Text("Newton School Coding Club")),

    const DropdownMenuItem(
        value: "Newark Research",
        child: Text("Newark Research")),

    const DropdownMenuItem(
        value: "Octave , Music Society Of BPIT",
        child: Text("Octave , Music Society Of BPIT")),
    const DropdownMenuItem(
        value: "Panache , Fashion Society Of BPIT",
        child: Text("Panache , Fashion Society Of BPIT")),
    const DropdownMenuItem(
        value: "School Of Business Administration",
        child: Text("School Of Business Administration")),
    const DropdownMenuItem(
        value: "Training and Placement Cell",
        child: Text("Training and Placement Cell")),
    const DropdownMenuItem(
        value: "VIBE , Diwali Fest Of BPIT",
        child: Text("VIBE , Diwali Fest Of BPIT")),

    const DropdownMenuItem(
        value: "Women In Big Data BPIT",
        child: Text("Women In Big Data BPIT")),
  ];
  return menuItems;
}

String selectedValue = "Anvesham";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirm_passController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;

  final List<bool> _selectedChoice = <bool>[true, false];

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirm_passController.dispose();
  }

  selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      name: _selectedChoice[0] == true ? _name.text : selectedValue,
      email: _emailController.text,
      password: _passwordController.text,
      confirm_pass: _confirm_passController.text,
      //_isStudent: ValueKey(value),
      file: _image,
      choice: _selectedChoice[0] == true ? 'Student' : 'Society',
    );

    if (res == "success") {
      setState(() {
       
        _isLoading = false;
      });

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebSreenLayout(),
            mobileScreenLayout: MobileScreenLayout()),
      ));
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(child: Container(), flex: 2),
                //SVG image
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Image.asset(
                    "assets/logo.png",
                    //color: Theme.of(context).primaryColor,
                    height: 64,
                  ),
                ),
                const SizedBox(height: 20),
                //Circuler widget to accept and show user profile image
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64, backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage('assets/profile_pic.png'),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => selectImage(),
                          icon: const Icon(Icons.add_a_photo),
                          color: blueColor,
                        ))
                  ],
                ),
                const SizedBox(height: 24),

                ToggleButtons(
                  onPressed: (int index) {
                    setState(() {
                      // The button that is tapped is set to true, and the others to false.
                      for (int i = 0; i < _selectedChoice.length; i++) {
                        if (index == i) {
                          _selectedChoice[i] = true;
                        } else {
                          _selectedChoice[i] = false;
                        }
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.black,
                  selectedColor: Colors.white,
                  splashColor: Colors.black,
                  fillColor: Colors.black,
                  color: const Color.fromARGB(255, 46, 31, 31),
                  constraints: const BoxConstraints(
                    minHeight: 30.0,
                    minWidth: 70.0,
                  ),
                  isSelected: _selectedChoice,
                  children: choices,
                ),

                _selectedChoice[0] == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Full Name',
                              style: kLabelStyle,
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle,
                              height: 60.0,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  hintText: 'Enter your Full Name',
                                  hintStyle: kHintTextStyle,
                                ),
                                controller: _name,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(
                              'Society',
                              style: kLabelStyle,
                            ),
                            const SizedBox(height: 10.0),
                            DecoratedBox(
                              decoration: kBoxDecorationStyle,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: DropdownButton(
                                  hint: const Text("Select your society"),
                                  value: selectedValue,
                                 
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValue = newValue!;
                                     
                                    });
                                  },
                                  items: dropdownItems,
                                  isExpanded:
                                      true, //make true to take width of parent widget
                                  underline: Container(), //empty line
                                  style: kHintTextStyle,
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.black,
                                ),
                              ),
                            ),
                          ]),

                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Email',
                        style: kLabelStyle,
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        height: 60.0,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hintText: 'Enter your Email',
                            hintStyle: kHintTextStyle,
                          ),
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@')) {
                              return 'Please Enter Valid Email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Password',
                        style: kLabelStyle,
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        height: 60.0,
                        child: TextFormField(
                          obscureText: true,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(top: 14.0),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            hintText: 'Enter your Password',
                            hintStyle: kHintTextStyle,
                          ),
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Password',
                        style: kLabelStyle,
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        height: 60.0,
                        child: TextFormField(
                          obscureText: true,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            hintText: 'Confirm Password',
                            hintStyle: kHintTextStyle,
                          ),
                          controller: _confirm_passController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 24),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: SizedBox(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width * 0.78,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(41, 49, 48, 1),
                            ),
                            onPressed: () => signupUser(),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                       color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFFffffff),
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an Account ? ",
                        style: kLabelStyle,
                      ),
                      TextButton(
                        onPressed: () => {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  LoginScreen(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          )
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
