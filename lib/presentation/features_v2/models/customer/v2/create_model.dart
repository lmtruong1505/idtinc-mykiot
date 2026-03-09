import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';

class CreateCustomerV2Model {
  int? company;
  String? fullName;
  String? phone;
  //YYYY-MM-DD
  String? birthday;
  String? gender;
  AddressEntity? address;

  CreateCustomerV2Model({
    this.company,
    this.fullName,
    this.phone,
    this.birthday,
    this.gender,
    this.address,
  });

  CreateCustomerV2Model.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    fullName = json['full_name'];
    phone = json['phone'];
    birthday = json['birthday'];
    gender = json['gender'];
    address = json['address'] == null ? null : AddressEntity.fromJson(json['address']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company'] = company;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['address'] = address?.toJson();
    return data;
  }
}
