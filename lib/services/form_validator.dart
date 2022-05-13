import 'package:form_validator/form_validator.dart';

class FormValidator {
  static final _validateEmail =
      ValidationBuilder().email().maxLength(50).build();
  static final _validatePassword = ValidationBuilder()
      .regExp(RegExp('(?=.*[0-9a-zA-Z]).{6,}'),
          'Password must be minimum 6 characters')
      .build();
  static final _validateDisplayName =
      ValidationBuilder().minLength(1).maxLength(15).build();

  static String? validateSignUp(String email, String password,
      String repeatedPassword, String displayName) {
    if (_validateEmail(email) != null) {
      return _validateEmail(email);
    } else if (_validatePassword(password) != null) {
      return _validatePassword(password);
    } else if (repeatedPassword != password) {
      return 'Make sure passwords match';
    } else if (_validateDisplayName(displayName) != null) {
      return _validateDisplayName(displayName);
    } else {
      return null;
    }
  }
}
