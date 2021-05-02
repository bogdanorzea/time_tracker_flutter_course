import 'package:flutter/material.dart';

import '../../services/auth.dart';
import 'email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key key, @required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: EmailSignInForm(auth: auth),
        ),
      ),
    );
  }
}
