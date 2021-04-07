import 'package:emoup/Models/user.dart';
import 'package:emoup/OnBoarding/profile.dart';
import 'package:emoup/Services/login.dart';
import 'package:emoup/const.dart';
import 'package:emoup/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  User user = new User();
  bool newUser = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'EmoUP!',
      logo: 'assets/images/logo.png',
      theme: LoginTheme(
        pageColorLight: Colors.white,
        pageColorDark: Colors.white,
        primaryColor: eblue,
        titleStyle: GoogleFonts.poppins(
          color: eorange
        )
      ),
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        return login(loginData);
      },
      onSignup: (loginData) {
        setState(() {
          newUser = true;          
        });
        return createUser(loginData);
      },
      loginAfterSignUp: true,
      onSubmitAnimationCompleted: () {
        print(newUser);
        navigateToPush(context, newUser ? Profile() : Home());
      },
      hideForgotPasswordButton: true,
      onRecoverPassword: null,
    );
  }
}