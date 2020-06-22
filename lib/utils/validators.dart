mixin Validators {
  static final RegExp _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final RegExp _passwordRegex = RegExp(
      r"^(?=.*\d)(?=.*[~!@#$%^&*()_\-+=|\\{}[\]:;<>?/])(?=.*[A-Z])(?=.*[a-z])\S{6,256}$");
  static bool email(String input) => _emailRegex.hasMatch(input);
  static bool password(String input) => _passwordRegex.hasMatch(input);
  static bool name(String input) => input != null && input.isNotEmpty;
  static bool username(String input) => input != null && input.isNotEmpty;
}
