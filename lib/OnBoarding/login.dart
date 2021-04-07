import 'package:emoup/Models/user.dart';
import 'package:emoup/Services/login.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  final String role;

  Login({this.role});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  User user = new User();

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
        return createUser(loginData);
      },
      loginAfterSignUp: true,
      onSubmitAnimationCompleted: () {
        
      },
      hideForgotPasswordButton: true,
      onRecoverPassword: null,
    );
  }
}