import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'form_submit_button.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  const EmailSignInFormChangeNotifier({Key key, @required this.model})
      : super(key: key);

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
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
              enabled: !model.isLoading,
              labelText: 'E-mail',
              hintText: 'test@test.com',
              errorText: model.emailErrorText,
            ),
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: widget.model.updateEmail,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(
                model.isEmailValid ? _passwordFocusNode : _emailFocusNode,
              );
            },
          ),
          SizedBox(height: 8),
          TextField(
            autocorrect: false,
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              enabled: !model.isLoading,
              labelText: 'Password',
              errorText: model.passwordErrorText,
            ),
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            onChanged: widget.model.updatePassword,
            onEditingComplete: _submit,
          ),
          SizedBox(height: 16),
          FormSubmitButton(
            onPressed: model.canSubmit ? _submit : null,
            text: model.primaryActionText,
          ),
          TextButton(
            onPressed: !model.isLoading ? _toggleFormType : null,
            child: Text(model.secondaryActionText),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    try {
      await widget.model.submit();

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _toggleFormType() {
    widget.model.toggleFormType();

    _emailController.clear();
    _passwordController.clear();
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
