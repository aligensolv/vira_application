String? requiredValidator(String? value, {String message = 'This field is required.'}) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}

String? emailValidator(String? value, {String message = 'Invalid email address.'}) {
  if (value == null || value.trim().isEmpty) return null;
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value.trim())) {
    return message;
  }
  return null;
}

String? minLengthValidator(String? value, int min, {String? message}) {
  if (value == null || value.length < min) {
    return message ?? 'Minimum length is $min characters.';
  }
  return null;
}

String? maxLengthValidator(String? value, int max, {String? message}) {
  if (value != null && value.length > max) {
    return message ?? 'Maximum length is $max characters.';
  }
  return null;
}

String? phoneValidator(String? value, {String message = 'Invalid phone number.'}) {
  if (value == null || value.trim().isEmpty) return null;
  final phoneRegex = RegExp(r'^\+?\d{7,15}$');
  if (!phoneRegex.hasMatch(value.trim())) {
    return message;
  }
  return null;
}

String? matchValidator(String? value, String? otherValue, {String message = 'Values do not match.'}) {
  if (value != otherValue) {
    return message;
  }
  return null;
}

String? numberValidator(String? value, {String message = 'Enter a valid number.'}) {
  if (value == null || value.trim().isEmpty) return null;
  final numValue = num.tryParse(value);
  if (numValue == null) {
    return message;
  }
  return null;
}

String? urlValidator(String? value, {String message = 'Invalid URL.'}) {
  if (value == null || value.trim().isEmpty) return null;
  final urlRegex = RegExp(
    r'^(https?:\/\/)?' // protocol
    r'([\da-z\.-]+)\.([a-z\.]{2,6})' // domain name and extension
    r'([\/\w \.-]*)*\/?$' // path
  );
  if (!urlRegex.hasMatch(value.trim())) {
    return message;
  }
  return null;
}

String? passwordValidator(String? value, {int minLength = 8, String? message}) {
  if (value == null || value.length < minLength) {
    return message ?? 'Password must be at least $minLength characters.';
  }
  final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+$');
  if (!passwordRegex.hasMatch(value)) {
    return 'Password must include upper, lower, digit, and special character.';
  }
  return null;
}

/// FormValidators: groups all validators for easy access in forms.
class FormValidators {
  static final required = requiredValidator;
  static final email = emailValidator;
  static final minLength = minLengthValidator;
  static final maxLength = maxLengthValidator;
  static final phone = phoneValidator;
  static final match = matchValidator;
  static final number = numberValidator;
  static final url = urlValidator;
  static final password = passwordValidator;
}
