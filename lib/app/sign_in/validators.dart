abstract class StringValidator {
  bool isValid(String value);
}

class NotEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) => value != null && value.isNotEmpty;
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NotEmptyStringValidator();
  final StringValidator passwordValidator = NotEmptyStringValidator();

  final String invalidEmailErrorText = 'E-mail cannot be empty';
  final String invalidPasswordErrorText = 'Password cannot be empty';
}
