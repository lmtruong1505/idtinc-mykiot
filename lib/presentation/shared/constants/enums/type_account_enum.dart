

import '../../../../shared/constants/pref_key.dart';

enum AccountTypeEnum {
  admin( id: 1, code: PrefKeys.codeAdmin),
  employee(id: 3, code: PrefKeys.codeEmployee);

  final String code;
  final int id;

  const AccountTypeEnum({required this.code, required this.id,});
}