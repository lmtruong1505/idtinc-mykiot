import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/features/address/cubit/location/location_bloc.dart';

class CustomerParam {
  int? workspace;
  CustomerData? customer;
  AdditionData? addition;
  RelationData? relation;
  BankData? bank;
  List<XFile>? files;

  CustomerParam({
    this.workspace,
    this.customer,
    this.addition,
    this.relation,
    this.bank,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workspace'] = workspace;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (addition != null) {
      data['addition'] = addition!.toJson();
    }
    if (relation != null) {
      data['relation'] = relation!.toJson();
    }
    if (bank != null) {
      data['bank'] = bank!.toJson();
    }
    if (files != null) {
      data['files'] = files
          ?.map(
            (e) => MultipartFile.fromFile(
              e.path,
              filename: e.name,
            ),
          )
          .toList();
    }
    return data;
  }
}

class CustomerData {
  String? customerCode;
  String? customerName;
  String? customerPhone;
  int? customerType;
  int? customerGroup;
  String? email;
  String? dateOfBirth;
  int? gender;
  Address? address;

  CustomerData({
    this.customerCode,
    this.customerName,
    this.customerPhone,
    this.customerType,
    this.customerGroup,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_code'] = customerCode;
    data['customer_name'] = customerName;
    data['customer_phone'] = customerPhone;
    data['customer_type'] = customerType;
    data['customer_group'] = customerGroup;
    data['email'] = email;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  int? latitude;
  int? longitude;
  BackAddress? address;

  Address({
    this.latitude,
    this.longitude,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address?.toJson();
    return data;
  }
}

class AdditionData {
  String? identifyNumber;
  String? providedDate;
  String? providedPlace;
  String? prefixName;

  AdditionData({
    this.identifyNumber,
    this.providedDate,
    this.providedPlace,
    this.prefixName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['identify_number'] = identifyNumber;
    data['provided_date'] = providedDate;
    data['provided_place'] = providedPlace;
    data['prefix_name'] = prefixName;
    return data;
  }
}

class RelationData {
  String? fullname;
  String? phoneNumber;
  String? email;
  String? prefixName;
  Address? address;

  RelationData({
    this.fullname,
    this.phoneNumber,
    this.email,
    this.prefixName,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullname'] = fullname;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['prefix_name'] = prefixName;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class BankData {
  String? bankName;
  String? bankNumber;
  String? bankBranch;

  BankData({this.bankName, this.bankNumber, this.bankBranch});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_name'] = bankName;
    data['bank_number'] = bankNumber;
    data['bank_branch'] = bankBranch;
    return data;
  }
}
