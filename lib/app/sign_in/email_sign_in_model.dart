import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

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

enum EmailSignInFormType { register, signIn }
