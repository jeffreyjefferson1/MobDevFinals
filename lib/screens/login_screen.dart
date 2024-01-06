import 'package:flutter/material.dart';
import 'package:todd_flutter_app/screens/dashboard_screen.dart';
import 'package:todd_flutter_app/screens/placeholder_screen.dart';
import 'package:todd_flutter_app/screens/register_screen.dart';
import 'package:todd_flutter_app/widgets/text_form.dart';
import 'package:todd_flutter_app/widgets/password_field.dart';
import 'package:todd_flutter_app/widgets/primary_button.dart';
import 'package:todd_flutter_app/widgets/secondary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  void checkCurrentUser() async {
    User? user = _auth.currentUser;

    if (user != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Toddelicious Recipes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 100,
              ),
              CustomTextForm(
                  labelText: "Email",
                  hintText: "Enter Valid Email",
                  iconData: Icons.email,
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController
                  ),
              SizedBox(
                height: 20,
              ),
              PasswordField(
                  iconData: Icons.password,
                  LabelText: "Password",
                  hintText: "Enter your Password",
                  obscureText: obscureText,
                  controller: _passwordController,
                  onTap: setPasswordVisibility),
              SizedBox(
                height: 20,
              ),
              PrimaryButton(
                  text: "Login", iconData: Icons.login, onPressed: login),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(4.0),
                ),
                icon: Image.asset(
                  'lib/assets/google_logo.png',
                  height: 38,
                  width: 38,
                ),
                label: Container(
                  padding: EdgeInsets.all(8.0), // Set inner container padding to 8px
                  child: Text('Sign in with Google'),
                ),
                onPressed: () {
                  _signInWithGoogle();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SecondaryButton(
                      text: "Register", onPressed: register),
                  SecondaryButton(
                      text: "Forgot Password", onPressed: forgotPassword)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (userCredential.user != null) {
      Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$error"),
        duration: Duration(seconds: 3),
      ),
    );
    print(error);
  }
}

  void register() {
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }

  void forgotPassword() {
    Navigator.pushNamed(context, PlaceholderScreen.routeName);
  }

  void setPasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$error"),
          duration: Duration(seconds: 3),
        ),
      );
      print(error);
    }
  }
}