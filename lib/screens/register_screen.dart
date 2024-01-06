import 'package:flutter/material.dart';
import 'package:todd_flutter_app/screens/dashboard_screen.dart';
import 'package:todd_flutter_app/widgets/text_form.dart';
import 'package:todd_flutter_app/widgets/password_field.dart';
import 'package:todd_flutter_app/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextForm(
                labelText: "Email",
                hintText: "Enter Valid Email",
                iconData: Icons.email,
                textInputType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              SizedBox(height: 20),
              PasswordField(
                iconData: Icons.password,
                LabelText: "Password",
                hintText: "Enter your Password",
                obscureText: obscureText,
                controller: _passwordController,
                onTap: setPasswordVisibility
              ),
              SizedBox(height: 20),
              PasswordField(
                iconData: Icons.password,
                LabelText: "Confirm Password",
                hintText: "Comfirm your Password",
                obscureText: obscureText,
                controller: _confirmPasswordController,
                onTap: setPasswordVisibility
              ),
              SizedBox(height: 20),
              PrimaryButton(
                text: "Register",
                iconData: Icons.person_add,
                onPressed: () {
                  register();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setPasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void register() async {
    if(_passwordController.text == _confirmPasswordController.text) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Incorrect Password"),
            duration: Duration(seconds: 3),
          ),
        );
    }
    
  }
}
