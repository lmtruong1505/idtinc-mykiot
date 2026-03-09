import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class CustomerV2Model {
  int? id;
  String? code;
  String? fullName;
  String? phone;
  String? birthday;
  bool? isActive;
  bool? isZalo;
  int? company;
  String? gender;
  int? orders;
  double? revenue;
  num? points;
  num? debt;
  AddressEntity? address;

  CustomerV2Model({
    this.id,
    this.code,
    this.fullName,
    this.company,
    this.gender,
    this.orders,
    this.revenue,
    this.phone,
    this.isZalo,
    this.birthday,
    this.isActive,
    this.points,
    this.debt,
    this.address,
  });

  CustomerV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    fullName = json['full_name'];
    phone = json['phone_number'];

    if (json['account_user'] != null) {
      phone = json['account_user']['phone_number'];
      isActive = json['account_user']['is_active'];
    }
    if (json['account_user_data'] != null) {
      phone = json['account_user_data']['phone_number'];
      isActive = json['account_user_data']['is_active'];
    }
    birthday = json['birthday'];
    isActive = json['is_active'];
    company = json['company'];
    gender = json['gender'];
    orders = json['orders'].toString().toInt;
    revenue = json['revenue'].toString().toDouble;
    isZalo = json['is_care_zalooa'];
    points = json['points'];
    debt = json['debt'];
    address = json['address'] == null ? null : AddressEntity.fromJson(json['address']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['full_name'] = fullName;
    data['phone_number'] = phone;
    data['birthday'] = birthday;
    data['is_active'] = isActive;
    data['company'] = company;
    data['gender'] = gender == 'Nam' ? 'MALE': 'FEMALE';
    data['orders'] = orders;
    data['revenue'] = revenue;
    data['is_care_zalooa'] = isZalo;
    data['points'] = points;
    data['debt'] = debt;
    data['address'] = address?.toJsonCreate();
    return data;
  }
}
