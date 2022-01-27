import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

void main() {
  test('non empty string', () {
    final validator = NotEmptyStringValidator();

    expect(validator.isValid('true'), true);
  });

  test('empty string', () {
    final validator = NotEmptyStringValidator();

    expect(validator.isValid(''), false);
  });

  test('null string', () {
    final validator = NotEmptyStringValidator();

    expect(validator.isValid(null), false);
  });
}
