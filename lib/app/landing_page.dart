import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import 'home_page.dart';
import 'sign_in/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, @required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();

    _updateUser(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        auth: widget.auth,
        onSignIn: _updateUser,
      );
    }

    return HomePage(
      auth: widget.auth,
      onSignOut: () => _updateUser(null),
    );
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }
}
