bool isPhoneNumberValid(String phoneNumber) {
  // Biểu thức chính quy để kiểm tra số điện thoại
  final regex = RegExp(r'^(0|\+?84|84)?[98753]\d{8}$');

  // Kiểm tra khớp biểu thức chính quy
  return regex.hasMatch(phoneNumber);
}

bool isAlphabetic(String input) {
  final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');
  return !regex.hasMatch(input);
}

bool doesNotContainSpecialCharsOrSpaces(String input) {
  final RegExp regex = RegExp(r'^[a-zA-Z0-9]*$');
  return regex.hasMatch(input);
}

bool isEmailValid(String email) {
  // Biểu thức chính quy để kiểm tra email
  final regex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
  );

  // Kiểm tra khớp biểu thức chính quy
  return regex.hasMatch(email);
}