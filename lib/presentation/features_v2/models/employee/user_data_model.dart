import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features/company/data/models/bank_model.dart';

class UserDataModel {
  int? id;
  String? email;
  String? code;
  String? phoneNumber;
  String? fullName;
  bool? isActive;
  String? gender;
  String? createdAt;
  String? updatedAt;
  String? website;
  String? dateOfBirth;
  String? identifyNumber;
  String? providedDate;
  String? providedPlace;
  String? taxNumber;
  String? faxNumber;
  bool? isSupplier;
  String? accountName;
  String? accountNumber;
  BankModel? bank;
  AddressModel? address;
  String? accountType;
  String? avatar;
  bool? isDelete;
  String? addressString;

  UserDataModel({
    this.id,
    this.email,
    this.code,
    this.phoneNumber,
    this.fullName,
    this.isActive,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.website,
    this.dateOfBirth,
    this.identifyNumber,
    this.providedDate,
    this.providedPlace,
    this.taxNumber,
    this.faxNumber,
    this.isSupplier,
    this.accountName,
    this.accountNumber,
    this.bank,
    this.address,
    this.accountType,
    this.avatar,
    this.isDelete,
    this.addressString,
  });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    code = json['code'];
    phoneNumber = json['phone_number'];
    fullName = json['full_name'];
    isActive = json['is_active'];
    gender = json['gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    website = json['website'];
    dateOfBirth = json['date_of_birth'];
    identifyNumber = json['identify_number'];
    providedDate = json['provided_date'];
    providedPlace = json['provided_place'];
    taxNumber = json['tax_number'];
    faxNumber = json['fax_number'];
    isSupplier = json['is_supplier'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    bank = json['bank'] != null ? BankModel.fromJson(json['bank']) : null;
    address =
        json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    accountType = json['account_type'];
    avatar = json['avatar'];
    isDelete = json['is_delete'];
    addressString = json['address_string'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['code'] = code;
    data['phone_number'] = phoneNumber;
    data['full_name'] = fullName;
    data['is_active'] = isActive;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['website'] = website;
    data['date_of_birth'] = dateOfBirth;
    data['identify_number'] = identifyNumber;
    data['provided_date'] = providedDate;
    data['provided_place'] = providedPlace;
    data['tax_number'] = taxNumber;
    data['fax_number'] = faxNumber;
    data['is_supplier'] = isSupplier;
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    if (bank != null) {
      data['bank'] = bank!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['account_type'] = accountType;
    data['avatar'] = avatar;
    data['is_delete'] = isDelete;
    data['address_string'] = addressString;
    return data;
  }
}
