
import '../../../shared/constants/pref_key.dart';
import '../../../shared/constants/storage/shared_preference.dart';

int? get getCompany {
  return AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
}
String? get getPhone {
  return AppSharedPreference.instance.getValue(PrefKeys.username) as String?;
}
String? get getCompanyName {
  return AppSharedPreference.instance.getValue(PrefKeys.companyName) as String?;
}String? get getUserName {
  return AppSharedPreference.instance.getValue(PrefKeys.userFullName) as String?;
}

String? get getCompanyCode {
  return AppSharedPreference.instance.getValue(PrefKeys.companyCode) as String?;
}

String? get getAddressCompany {
  return AppSharedPreference.instance.getValue(PrefKeys.addressCompany) as String?;
}