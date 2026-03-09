
import '../../../../features/address/cubit/location/location_bloc.dart';
import '../../../../shared/utils/get.dart';

class CreateOrUpdateParam {
  String? username;
  String? code;
  String? password;
  String? fullName;
  String? email;
  String? accountType;
  int? role;
  String? gender;
  String? licence;
  String? dob;
  BackAddress? address;
  int? company;
  bool? active;

  CreateOrUpdateParam({
    this.username,
    this.code,
    this.password,
    this.fullName,
    this.email,
    this.accountType,
    this.role,
    this.gender,
    this.licence,
    this.dob,
    this.address,
    this.company,
    this.active,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['code'] = code;
    data['password'] = password;
    data['full_name'] = fullName;
    data['email'] = email;
    data['account_type'] = accountType;
    data['role'] = role;
    data['gender'] = gender;
    data['licence'] = licence;
    data['dob'] = dob;
    if (address != null) {
      data['address'] = {
        'province': {
          'code': address?.province?.code,
          'name': address?.province?.title,
        },
        'district': {
          'code': address?.district?.code,
          'name': address?.district?.title,
        },
        'ward': {
          'code': address?.ward?.code,
          'name': address?.ward?.title,
        },
        'title': address?.address,
      };
    }
    data['company'] = company ?? getCompany;
    data['active'] = active ?? true;

    return data;
  }
}
