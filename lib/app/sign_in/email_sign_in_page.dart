import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key key}) : super(key: key);

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
          child: EmailSignInFormChangeNotifier.create(context),
        ),
      ),
    );
  }
}
