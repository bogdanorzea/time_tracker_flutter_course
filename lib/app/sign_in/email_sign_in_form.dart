import 'package:flutter/material.dart';

import '../../services/auth.dart';
import 'form_submit_button.dart';
import 'validators.dart';

enum EmailSignInFormType { register, signIn }

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key key, @required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> with EmailAndPasswordValidators {
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
    final primaryActionText = _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';
    final secondaryActionText =
        _formType == EmailSignInFormType.signIn ? 'Need an account? Register!' : 'Have an account? Sign in!';

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
              errorText: _submitted && !isEmailValid ? invalidEmailErrorText : null,
            ),
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (value) => setState(() {}),
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(isEmailValid ? _passwordFocusNode : _emailFocusNode);
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
              errorText: _submitted && !isPasswordValid ? invalidPasswordErrorText : null,
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

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 3));

    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }

      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
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
}
