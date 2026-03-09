class RegexConstant {
  RegexConstant._();

  static const String regexPhoneNumber = r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
  static const String regexPassword = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&\s]{8,}$';
  static const String regexEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}