import 'package:flutter/material.dart';

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

  @override
  int get hashCode =>
      hashValues(email, password, formType, isLoading, submitted);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final EmailSignInModel otherModel = other;

    return email == otherModel.email &&
        password == otherModel.password &&
        formType == otherModel.formType &&
        isLoading == otherModel.isLoading &&
        submitted == otherModel.submitted;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}

enum EmailSignInFormType { register, signIn }
