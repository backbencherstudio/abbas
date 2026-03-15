String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }

  /// Basic email validation
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  return null;
}

String? confirmPasswordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  return null;
}

String? selectedCourseValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a course';
  }
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}

String? phoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a valid phone number';
  }
  return null;
}

String? addressValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your address';
  }
  return null;
}

String? dateOfBirthValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select date of birth';
  }
  return null;
}
String? experienceLevelValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select experience level';
  }
  return null;
}

String? actingGoalsValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select experience level';
  }
  return null;
}
String? digitalSignatureValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a signature';
  }
  return null;
}

String? dateValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a date';
  }
  return null;
}

String? assignmentTitleValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter title name';
  }
  return null;
}

String? assignmentDescriptionValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter description';
  }
  return null;
}