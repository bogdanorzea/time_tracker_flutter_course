import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;

    notifyListeners();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(
          email,
          password,
        );
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void toggleFormType() => updateWith(
        isLoading: false,
        email: '',
        password: '',
        submitted: false,
        formType: this.formType == EmailSignInFormType.register
            ? EmailSignInFormType.signIn
            : EmailSignInFormType.register,
      );

  String get primaryActionText => this.formType == EmailSignInFormType.signIn
      ? 'Sign in'
      : 'Create an account';

  String get secondaryActionText => this.formType == EmailSignInFormType.signIn
      ? 'Need an account? Register!'
      : 'Have an account? Sign in!';

  bool get isEmailValid => emailValidator.isValid(email);
  bool get isPasswordValid => passwordValidator.isValid(password);

  bool get canSubmit => isEmailValid && isPasswordValid && !isLoading;

  String get emailErrorText =>
      submitted && isEmailValid ? invalidEmailErrorText : null;
  String get passwordErrorText =>
      submitted && isPasswordValid ? invalidPasswordErrorText : null;
}
