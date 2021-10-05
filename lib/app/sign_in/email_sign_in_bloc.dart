import 'dart:async';

import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:meta/meta.dart';

class EmailSignInBloc {
  final AuthBase auth;

  final _modelController = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  EmailSignInBloc({@required this.auth});

  void dispose() {
    _modelController.close();
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void toggleFormType() => updateWith(
        isLoading: false,
        email: '',
        password: '',
        submitted: false,
        formType: _model.formType == EmailSignInFormType.register
            ? EmailSignInFormType.signIn
            : EmailSignInFormType.register,
      );

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
          _model.email,
          _model.password,
        );
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
