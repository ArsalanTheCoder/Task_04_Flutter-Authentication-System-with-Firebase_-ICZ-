import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:registration_and_login_screens_with_firebase_authentication/HomeScreen.dart';

import 'SignUp_Screen.dart';

//Login Screen with firebase authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> UserloginThroughFirebase() async{
    String userEmail = emailController.text.toString();     // Two controllers for taking inputs like email and password
    String password = passwordController.text.toString().trim();

    if(userEmail.isEmpty || password.isEmpty){  // Function that check if the field is empty then fill it
      Fluttertoast.showToast(
        msg: "Please Fill all the fields!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.black,
        backgroundColor: Colors.white,
      );
    } else{     // if field is not empty then go for login
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: userEmail, password: password);
        if (userCredential != null) {
          Fluttertoast.showToast(
            msg: "Login Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black,
            backgroundColor: Colors.white,
          );
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => Homescreen()),
                  (route) => false); // it means remove all previous screens
        }
      } on FirebaseAuthException catch(e){
        Fluttertoast.showToast(
          msg: "${e.code.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.black,
          backgroundColor: Colors.white,
        );
      }
    }
  }



  List<Color> _circleColors = [   // List of colors to change the glowing circles dynamically
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
    Colors.orangeAccent,
  ];


  int circleColorIndex = 0;  // Variable to keep track of the current color index for the circles

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (timer) {  // Change circle colors every 2 seconds
      setState(() {
        circleColorIndex = (circleColorIndex + 1) % _circleColors.length;   // Change to the next color in the lis
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(designIndex: circleColorIndex),  // Animated Background with  amazing wonderful design

          // Login beautiful card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 280,
                  height: 330,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.withOpacity(0.2), Colors.amber.withOpacity(0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black.withOpacity(0.5),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.6),
                        blurRadius: 10,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "LOGIN",  // Login text heading
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: TextField(  // Textfield for taking email as an input
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.attach_email_sharp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.elliptical(2, 2),
                                right: Radius.elliptical(2, 2),
                              ),
                              borderSide: BorderSide(width: 1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: TextField(        //Textfield for taking password as an input
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.security_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.elliptical(2, 2),
                                right: Radius.elliptical(2, 2),
                              ),
                              borderSide: BorderSide(width: 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(  // Login button for performing an action to do login through firebase
                        onPressed: () {
                          UserloginThroughFirebase();
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 15,
                          ),
                        ),
                      ),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                      }, child: Text("Don't have account", style: TextStyle(color: Colors.black, fontSize: 13),))
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Glowing Circles at Corners (with changing colors)
          Positioned(
            top: 30,
            left: 30,
            child: _GlowingCircle(color: _circleColors[circleColorIndex]),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: _GlowingCircle(color: _circleColors[circleColorIndex]),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: _GlowingCircle(color: _circleColors[circleColorIndex]),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: _GlowingCircle(color: _circleColors[circleColorIndex]),
          ),
        ],
      ),
    );
  }
}

// It is a widget where circle is glowing
class _GlowingCircle extends StatelessWidget {
  final Color color;

  const _GlowingCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.8),
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

// Great animated background show like dynamic designs
class AnimatedBackground extends StatelessWidget {
  final int designIndex;

  const AnimatedBackground({required this.designIndex});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Design 1
        if (designIndex == 0)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: DynamicShapes(color: Colors.purpleAccent.withOpacity(0.6)),
            ),
          ),
        // Design 2
        if (designIndex == 1)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueGrey, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: DynamicShapes(color: Colors.cyanAccent.withOpacity(0.6)),
            ),
          ),
        // Design 3
        if (designIndex == 2)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.indigo],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: DynamicShapes(color: Colors.pinkAccent.withOpacity(0.6)),
            ),
          ),
      ],
    );
  }
}

// Dynamic shapes for a 3D-shape effect
class DynamicShapes extends StatelessWidget {
  final Color color;

  const DynamicShapes({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 30,
          child: RotatingShape(color: color),
        ),
        Positioned(
          bottom: 100,
          right: 40,
          child: RotatingShape(color: color),
        ),
        Positioned(
          top: 200,
          left: 100,
          child: RotatingShape(color: color),
        ),
      ],
    );
  }
}

// Rotating and glowing shapes
class RotatingShape extends StatelessWidget {
  final Color color;

  RotatingShape({required this.color});

  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}
