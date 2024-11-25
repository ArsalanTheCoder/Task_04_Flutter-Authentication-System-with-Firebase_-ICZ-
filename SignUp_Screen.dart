import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController nameController = TextEditingController();  //// Four controllers for taking inputs like username, email, password and Confirm_password
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  Future<void> registerAtFirebase() async {  //Function that register the user into firebase, after taking input from user
    String userName = nameController.text.toString().trim();
    String userEmail = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String confirmPassword = confirmPasswordController.text.toString().trim();

    if(userName.isEmpty || userEmail.isEmpty || password.isEmpty || confirmPassword.isEmpty ){  //check the field is empty or not, if it is then show toast
      print("Please Fill all the fields!");
      Fluttertoast.showToast(
        msg: "Please Fill all the fields!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.red,
      );
    } else if(password != confirmPassword ){  // Check,well the password is same or not
      print("Password is not matching!");
      Fluttertoast.showToast(
        msg: "Password is not matching!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.red,
      );
    }else{  // Register user into firebase database
      try{
       await saveDataUsingSharedPreference(userName, userEmail);
       UserCredential userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userEmail, password: password);
       if(userCredential!=null){
         Fluttertoast.showToast(
           msg: "Account Created Successfully.",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           backgroundColor: Colors.white,
           textColor: Colors.red,
         );
         Navigator.pop(context);
       }

      } on FirebaseAuthException catch(e){
        print(e.code.toString());
        Fluttertoast.showToast(
          msg: "${e.code.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.red,
        );
      }
    }
  }

  Future<void> saveDataUsingSharedPreference(String userName, String userEmail) async{
    final preference = await SharedPreferences.getInstance();
    preference.setString('userName', userName);
    preference.setString('userEmail', userEmail);
    print("Data Save Successfully");

  }

  List<Color> _circleColors = [  // List of colors to change the glowing circles dynamically
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
    Colors.orangeAccent,
  ];

  int _circleColorIndex = 0;   // Variable to keep track of the current color index for the circles

  @override
  void initState() {
    super.initState();
    // Change circle colors every 2 seconds
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _circleColorIndex = (_circleColorIndex + 1) % _circleColors.length; //// Change to the next color in the list just like what we done in login screen
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          AnimatedBackground(designIndex: _circleColorIndex),   // Animated Background will show with good designs

          // Login Card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 280,
                  height: 450,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Registration",
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
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Name",
                              prefixIcon: Icon(Icons.person),
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
                          child: TextField(
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
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.security_rounded),
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
                          child: TextField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
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
                        ElevatedButton(
                          onPressed: () {
                            registerAtFirebase();
                    
                    
                          },
                          child: Text(
                            "Register",
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Glowing Circles at Corners (with changing colors)
          Positioned(
            top: 30,
            left: 30,
            child: _GlowingCircle(color: _circleColors[_circleColorIndex]),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: _GlowingCircle(color: _circleColors[_circleColorIndex]),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: _GlowingCircle(color: _circleColors[_circleColorIndex]),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: _GlowingCircle(color: _circleColors[_circleColorIndex]),
          ),
        ],
      ),
    );
  }
}

// Glowing Circle Widget
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

// Animated Background with dynamic design
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
              child: _DynamicShapes(color: Colors.purpleAccent.withOpacity(0.6)),
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
              child: _DynamicShapes(color: Colors.cyanAccent.withOpacity(0.6)),
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
              child: _DynamicShapes(color: Colors.pinkAccent.withOpacity(0.6)),
            ),
          ),
      ],
    );
  }
}

// Dynamic shapes for a 4D-like effect
class _DynamicShapes extends StatelessWidget {
  final Color color;

  const _DynamicShapes({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 30,
          child: _RotatingShape(color: color),
        ),
        Positioned(
          bottom: 100,
          right: 40,
          child: _RotatingShape(color: color),
        ),
        Positioned(
          top: 200,
          left: 100,
          child: _RotatingShape(color: color),
        ),
      ],
    );
  }
}

// Rotating and glowing shapes
class _RotatingShape extends StatelessWidget {
  final Color color;

  const _RotatingShape({required this.color});

  @override
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
