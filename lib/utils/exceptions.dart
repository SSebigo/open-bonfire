abstract class BonfireException implements Exception {
  final String message;
  BonfireException([this.message]);
}

class UserNotFoundException extends BonfireException {
  UserNotFoundException([String message]) : super(message);
}

class UsernameMappingUndefinedException extends BonfireException {
  UsernameMappingUndefinedException([String message]) : super(message);
}

class UsernameAlreadyExistsException extends BonfireException {
  UsernameAlreadyExistsException([String message]) : super(message);
}

class EmailAlreadyUsedException extends BonfireException {
  EmailAlreadyUsedException([String message]) : super(message);
}

class EmailUserNotFoundException extends BonfireException {
  EmailUserNotFoundException([String message]) : super(message);
}

class SendConfirmationEmailFailedException extends BonfireException {
  SendConfirmationEmailFailedException([String message]) : super(message);
}

class EmailNotVerifiedException extends BonfireException {
  EmailNotVerifiedException([String message]) : super(message);
}

class DownloadFailedException extends BonfireException {
  DownloadFailedException([String message]) : super(message);
}

class InvalidPasswordException extends BonfireException {
  InvalidPasswordException([String message]) : super(message);
}

class FollowingLimitReachedException extends BonfireException {
  FollowingLimitReachedException([String message]) : super(message);
}
