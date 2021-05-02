import 'package:flutter/material.dart';

import '../../services/auth.dart';
import 'email_sign_in_page.dart';
import 'sign_in_button.dart';
import 'social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 48),
            SocialSignInButton(
              assetName: 'images/google-logo.png',
              color: Colors.white,
              onPressed: _signInWithGoogle,
              text: 'Sign in with Google',
              textColor: Colors.black87,
            ),
            SizedBox(height: 8),
            SocialSignInButton(
              assetName: 'images/facebook-logo.png',
              color: Color(0xFF334D92),
              onPressed: _signInWithFacebook,
              text: 'Sign in with Facebook',
              textColor: Colors.white,
            ),
            SizedBox(height: 8),
            SignInButton(
              color: Colors.teal[700],
              onPressed: () => _signInWithEmail(context),
              text: 'Sign in with e-mail',
              textColor: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              'or',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
            SizedBox(height: 8),
            SignInButton(
              color: Colors.lime[300],
              onPressed: _signInAnonymously,
              text: 'Sign in anonymously',
              textColor: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => EmailSignInPage(auth: auth),
      ),
    );
  }

  void _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }
}
