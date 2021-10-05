import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_model.dart';
import 'form_submit_button.dart';
import 'validators.dart';

class EmailSignInFormStateful extends StatefulWidget {
  const EmailSignInFormStateful({Key key}) : super(key: key);

  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful>
    with EmailAndPasswordValidators {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  var _formType = EmailSignInFormType.signIn;

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  var _submitted = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final primaryActionText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryActionText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register!'
        : 'Have an account? Sign in!';

    final isEmailValid = emailValidator.isValid(_email);
    final isPasswordValid = passwordValidator.isValid(_password);
    final isSubmitEnabled = isEmailValid && isPasswordValid && !_isLoading;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            autocorrect: false,
            controller: _emailController,
            decoration: InputDecoration(
              enabled: !_isLoading,
              labelText: 'E-mail',
              hintText: 'test@test.com',
              errorText:
                  _submitted && !isEmailValid ? invalidEmailErrorText : null,
            ),
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (value) => setState(() {}),
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(
                  isEmailValid ? _passwordFocusNode : _emailFocusNode);
            },
          ),
          SizedBox(height: 8),
          TextField(
            autocorrect: false,
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              enabled: !_isLoading,
              labelText: 'Password',
              errorText: _submitted && !isPasswordValid
                  ? invalidPasswordErrorText
                  : null,
            ),
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            onChanged: (value) => setState(() {}),
            onEditingComplete: _submit,
          ),
          SizedBox(height: 16),
          FormSubmitButton(
            onPressed: isSubmitEnabled ? _submit : null,
            text: primaryActionText,
          ),
          TextButton(
            onPressed: !_isLoading ? _toggleFormType : null,
            child: Text(secondaryActionText),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 3));

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;

      if (_formType == EmailSignInFormType.register) {
        _formType = EmailSignInFormType.signIn;
      } else {
        _formType = EmailSignInFormType.register;
      }

      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }
}
