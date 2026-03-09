import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';

import '../../presentation/features_v2/blocs/profile_bloc/profile_edit_bloc.dart';

extension extString on String? {
  String get validator => this ?? '';
  String get capitalizeFirstLetter {
    if (validator.isEmpty) return validator;
    return validator[0].toUpperCase() + validator.substring(1).toLowerCase();
  }

  bool get isEmptyOrNull => this == null || this == 'null' || this!.isEmpty;
  bool get isTimeOfDay {
    if (isEmptyOrNull) {
      return false;
    }

    final res = this!.split(':');
    final left = int.tryParse(res.first) ?? 0;
    final right = int.tryParse(res.last) ?? 0;

    return left >= 0 && left <= 23 && right <= 60 && right >= 0;
  }

  double? get toDouble => double.tryParse(this ?? '');
  num? get toNum =>
      num.tryParse(this?.replaceAll('.', '').replaceAll(',', '.') ?? '');
  int? get toInt => int.tryParse(this ?? '');

  bool get copy {
    Clipboard.setData(ClipboardData(text: validator));
    return true;
  }

  String fomatDate2({
    String fomat = 'dd/MM/yyyy',
    String? parseFormat = 'yyyy-MM-dd',
    String defaultReturn = '',
    int hours = 0,
  }) {
    if (this != null) {
      try {
        final dateTime =
            DateFormat(parseFormat).parse(this!).add(Duration(hours: hours));
        return DateFormat(fomat).format(dateTime);
      } catch (e) {}
    }
    return defaultReturn;
  }

  DateTime? get toDate {
    if (this != null) {
      try {
        final date = DateTime.tryParse(this!);
        return date;
      } catch (e) {
        print(e.toString());
      }
    }
    return null;
  }

  DateTime? get toDateV2 {
    if (this == null) return null;
    try {
      final formatter = DateFormat('dd/MM/yyyy');
      return formatter.parse(this!);
    } catch (e) {
      print('Lỗi khi parse date: $e');
      return null;
    }
  }

  String? validatorTextField({
    String? msg,
    TextInputType type = TextInputType.text,
    String? textConfirm,
    int? minLength,
    int? maxLength,
  }) {
    if (validator.isEmpty) {
      return msg ?? 'Không bỏ trống';
    }
    if (maxLength != null && validator.length > maxLength) {
      return msg ?? 'Vui lòng nhập tối đa $maxLength kí tự';
    }
    if (minLength != null && validator.length < minLength) {
      return msg ?? 'Vui lòng nhập tối thiểu $minLength kí tự';
    }

    /// check phone
    final int? phone = int.tryParse(validator);
    if (phone == null && type == TextInputType.phone) {
      return msg ?? 'Số điện thoại không đúng định dạng';
    }
    if (validator.length != 10 && type == TextInputType.phone) {
      return msg ?? 'Số điện thoại không đúng định dạng';
    }
    if (!validator.startsWith('0') && type == TextInputType.phone) {
      return msg ?? 'Số điện thoại không đúng định dạng';
    }

    /// check email
    final isEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!isEmail.hasMatch(validator) && type == TextInputType.emailAddress) {
      return msg ?? 'Email không đúng định dạng';
    }

    /// check password
    if ((validator.length < 6 || validator.length > 12) &&
        type == TextInputType.visiblePassword) {
      return msg ?? 'Mật khẩu phải từ 6 -12 ký tự';
    }
    if (textConfirm != null &&
        this != textConfirm &&
        type == TextInputType.visiblePassword) {
      return msg ?? 'Mật khẩu không khớp';
    }
    return null;
  }

  String get autoConvertToHHmm {
    if (this == null) {
      return '00:00';
    }
    String time = this!;
    String temp = time;

    if (time.length == 1) {
      return '00:0$this';
    }
    time = time.replaceAll(':', '');
    if (time.length == 5) {
      time = time.substring(1, 5);
    }
    if (time.length == 3) {
      time = '0$time';
    }
    final cur = '${time.substring(0, 2)}:${time.substring(2)}';
    if (cur.isHourValid) {
      return cur;
    }
    if (temp.length == 6) {
      temp = temp.substring(0, 5);
    }
    return temp;
  }

  bool get isHourValid {
    // make sure the time is in the format HH:mm
    if (this == null) {
      return false;
    }
    final RegExp regex = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');
    return regex.hasMatch(this!);
  }

  String removeAllNonNumeric() {
    if (this == null) {
      return '';
    }
    return this!.replaceAll(RegExp(r'[^\d]'), '');
  }

  String removeAllDot() {
    if (this == null) {
      return '';
    }
    return this!.replaceAll(RegExp(r'[.]'), '');
  }

  String formatCurrency() {
    if (this == null) {
      return '';
    }
    final formatter =
        NumberFormat.simpleCurrency(locale: 'vi', name: '', decimalDigits: 0);
    return formatter.format(double.parse(this!));
  }

  StatusOrderKafa get toStatusOrder {
    switch (this) {
      case 'CXN':
        return StatusOrderKafa.pending;
      case 'DXN':
        return StatusOrderKafa.accept;
      case 'TC':
        return StatusOrderKafa.deny;
      case 'DH':
        return StatusOrderKafa.cancel;
      case 'HT':
        return StatusOrderKafa.complete;
      default:
        return StatusOrderKafa.pending;
    }
  }

  bool get validatePassword {
    if (this == null) {
      return false;
    }
    final RegExp regex = RegExp(r'^[a-zA-Z0-9!@#$%^&*()_+\-]{6,12}$');
    return regex.hasMatch(this!);
  }

  Gender get getGender {
    switch (this) {
      case 'MALE':
        return Gender.male;
      case 'FEMALE':
        return Gender.female;
      default:
        return Gender.male;
    }
  }

  bool isDigit() {
    if (this == null) {
      return false;
    }
    return this == '0' ||
        this == '1' ||
        this == '2' ||
        this == '3' ||
        this == '4' ||
        this == '5' ||
        this == '6' ||
        this == '7' ||
        this == '8' ||
        this == '9';
  }

  String toFixedLength(int length) {
    if (this == null) {
      return ''.padRight(length, ' ');
    }
    if (this!.length > length) {
      return this!.substring(0, length);
    } else if (this!.length < length) {
      return this!.padRight(length, ' ');
    }
    return this!;
  }

  String padLeftLength(int length) {
    if (this == null) {
      return '---'.padLeft(length, ' ');
    }
    if (this!.length > length) {
      return this!.substring(0, length);
    } else if (this!.length < length) {
      return this!.padLeft(length, ' ');
    }
    return this!;
  }

  String get utf8 {
    final Map<String, String> accentMap = {
      // Chữ a
      'à': 'a', 'á': 'a', 'ạ': 'a', 'ả': 'a', 'ã': 'a',
      'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ậ': 'a', 'ẩ': 'a', 'ẫ': 'a',
      'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ặ': 'a', 'ẳ': 'a', 'ẵ': 'a',
      
      // Chữ A
      'À': 'A', 'Á': 'A', 'Ạ': 'A', 'Ả': 'A', 'Ã': 'A',
      'Â': 'A', 'Ầ': 'A', 'Ấ': 'A', 'Ậ': 'A', 'Ẩ': 'A', 'Ẫ': 'A',
      'Ă': 'A', 'Ằ': 'A', 'Ắ': 'A', 'Ặ': 'A', 'Ẳ': 'A', 'Ẵ': 'A',
      
      // Chữ e
      'è': 'e', 'é': 'e', 'ẹ': 'e', 'ẻ': 'e', 'ẽ': 'e',
      'ê': 'e', 'ề': 'e', 'ế': 'e', 'ệ': 'e', 'ể': 'e', 'ễ': 'e',
      
      // Chữ E
      'È': 'E', 'É': 'E', 'Ẹ': 'E', 'Ẻ': 'E', 'Ẽ': 'E',
      'Ê': 'E', 'Ề': 'E', 'Ế': 'E', 'Ệ': 'E', 'Ể': 'E', 'Ễ': 'E',
      
      // Chữ i
      'ì': 'i', 'í': 'i', 'ị': 'i', 'ỉ': 'i', 'ĩ': 'i',
      
      // Chữ I
      'Ì': 'I', 'Í': 'I', 'Ị': 'I', 'Ỉ': 'I', 'Ĩ': 'I',
      
      // Chữ o
      'ò': 'o', 'ó': 'o', 'ọ': 'o', 'ỏ': 'o', 'õ': 'o',
      'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ộ': 'o', 'ổ': 'o', 'ỗ': 'o',
      'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ợ': 'o', 'ở': 'o', 'ỡ': 'o',
      
      // Chữ O
      'Ò': 'O', 'Ó': 'O', 'Ọ': 'O', 'Ỏ': 'O', 'Õ': 'O',
      'Ô': 'O', 'Ồ': 'O', 'Ố': 'O', 'Ộ': 'O', 'Ổ': 'O', 'Ỗ': 'O',
      'Ơ': 'O', 'Ờ': 'O', 'Ớ': 'O', 'Ợ': 'O', 'Ở': 'O', 'Ỡ': 'O',
      
      // Chữ u
      'ù': 'u', 'ú': 'u', 'ụ': 'u', 'ủ': 'u', 'ũ': 'u',
      'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ự': 'u', 'ử': 'u', 'ữ': 'u',
      
      // Chữ U
      'Ù': 'U', 'Ú': 'U', 'Ụ': 'U', 'Ủ': 'U', 'Ũ': 'U',
      'Ư': 'U', 'Ừ': 'U', 'Ứ': 'U', 'Ự': 'U', 'Ử': 'U', 'Ữ': 'U',
      
      // Chữ y
      'ỳ': 'y', 'ý': 'y', 'ỵ': 'y', 'ỷ': 'y', 'ỹ': 'y',
      
      // Chữ Y
      'Ỳ': 'Y', 'Ý': 'Y', 'Ỵ': 'Y', 'Ỷ': 'Y', 'Ỹ': 'Y',
      
      // Chữ đ
      'đ': 'd', 'Đ': 'D',
    };

    if (this?.isEmpty ?? true) return this ?? '';
      
    String result = this!;
    
    // Thay thế từng ký tự dựa trên bảng mapping
    accentMap.forEach((accented, normal) {
      result = result.replaceAll(accented, normal);
    });
    
    return result;
  }

}
