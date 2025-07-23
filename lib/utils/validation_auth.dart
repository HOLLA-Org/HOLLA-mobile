class ValidationAuth {
  static bool isUsernameOrEmailValid(String input) {
    if (input.contains('@')) {
      return isValidEmail(input);
    } else {
      return isUsernameValid(input);
    }
  }

  static bool isUsernameValid(String username) {
    return username.length > 8;
  }

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{6,}$',
  );
  static bool isStrongPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
