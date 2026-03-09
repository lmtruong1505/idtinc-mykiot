import 'package:pharmago/shared/ext/ext_string.dart';

import '../../presentation/features/company/domain/entities/company_entity.dart';
import '../../shared/constants/pref_key.dart';
import '../../shared/constants/storage/shared_preference.dart';

int? get getCompanyId =>
    AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
int? get parentId =>
    AppSharedPreference.instance.getValue(PrefKeys.parentId) as int?;

String? get getCompanyName =>
    AppSharedPreference.instance.getValue(PrefKeys.companyName) as String?;
int? get getAccountId =>
    AppSharedPreference.instance.getValue(PrefKeys.accountId) as int?;

bool get isWorkspace =>
    AppSharedPreference.instance.getValue(PrefKeys.isWorkspace) as bool? ??
    false;

bool get isCAD =>
    AppSharedPreference.instance.getString(PrefKeys.companyType) == 'C&D';

String get userAvatar =>
    AppSharedPreference.instance.getString(PrefKeys.avatar) ?? '';

String get userCode =>
    AppSharedPreference.instance.getString(PrefKeys.userCode) ??
    'Chưa có thông tin';

String get userFullName =>
    AppSharedPreference.instance.getString(PrefKeys.userFullName) ??
    'Chưa có thông tin';

String? get companyType =>
    AppSharedPreference.instance.getString(PrefKeys.companyType);

bool? get isDrugStore =>
    AppSharedPreference.instance.getString(PrefKeys.companyType) == 'DRUGSTORE';

bool get isPhamacy =>
    AppSharedPreference.instance.getString(PrefKeys.companyType) == 'PHARMACY';

bool get showAppointment => ['CLINIC', 'GYM', 'SPA', 'C&D']
    .contains(AppSharedPreference.instance.getString(PrefKeys.companyType));

setCompanyData(
  CompanyEntity value, {
  CompanyEntity? parent,
}) async {
  final share = AppSharedPreference.instance;
  share
    ..setValue(PrefKeys.companyCode, value.code)
    ..setValue(PrefKeys.company, value.id)
    ..setValue(PrefKeys.companyName, value.name)
    ..setValue(PrefKeys.companyType, value.typeCode)
    ..setValue(PrefKeys.isWorkspace, value.parentId == null)
    ..setValue(PrefKeys.parentId, value.parentId)
    ..setValue(PrefKeys.parentName, parent?.name)
    ..setValue(PrefKeys.parentType, parent?.typeCode)
    ..setValue(
      PrefKeys.addressCompany,
      '${value.address?.title?.validator}, ${value.address?.ward?.name.validator}, ${value.address?.district?.name.validator}, ${value.address?.province?.name.validator}',
    );
  print('====share====$companyType');
}

String? get parentName =>
    AppSharedPreference.instance.getString(PrefKeys.parentName);

String? get parentType =>
    AppSharedPreference.instance.getString(PrefKeys.parentType);
