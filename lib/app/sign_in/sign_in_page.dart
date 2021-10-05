import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_page.dart';
import 'sign_in_button.dart';
import 'social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc bloc;

  const SignInPage({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) => SignInPage(bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Tracker'), elevation: 2.0),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingSteam,
        initialData: false,
        builder: (context, snapshot) {
          final isLoading = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 48,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          "Sign In",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                SizedBox(height: 48),
                SocialSignInButton(
                  assetName: 'images/google-logo.png',
                  color: Colors.white,
                  onPressed:
                      isLoading ? null : () => _signInWithGoogle(context),
                  text: 'Sign in with Google',
                  textColor: Colors.black87,
                ),
                SizedBox(height: 8),
                SocialSignInButton(
                  assetName: 'images/facebook-logo.png',
                  color: Color(0xFF334D92),
                  onPressed:
                      isLoading ? null : () => _signInWithFacebook(context),
                  text: 'Sign in with Facebook',
                  textColor: Colors.white,
                ),
                SizedBox(height: 8),
                SignInButton(
                  color: Colors.teal[700],
                  onPressed: isLoading ? null : () => _signInWithEmail(context),
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
                  onPressed:
                      isLoading ? null : () => _signInAnonymously(context),
                  text: 'Sign in anonymously',
                  textColor: Colors.black87,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => EmailSignInPage(),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }

    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  void _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }
}
