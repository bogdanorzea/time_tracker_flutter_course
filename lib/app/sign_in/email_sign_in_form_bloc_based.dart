import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_model.dart';
import 'form_submit_button.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
    );
  }

  const EmailSignInFormBlocBased({Key key, @required this.bloc})
      : super(key: key);

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        initialData: EmailSignInModel(),
        stream: widget.bloc.modelStream,
        builder: (context, snapshot) {
          final model = snapshot.data;

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
                  onChanged: widget.bloc.updateEmail,
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
                  onChanged: widget.bloc.updatePassword,
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
        });
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();

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
    widget.bloc.toggleFormType();

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
