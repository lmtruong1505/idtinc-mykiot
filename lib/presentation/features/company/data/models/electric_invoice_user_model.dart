class ElectricInvoiceUserModel {
  String? vnptRes;
  UserData? data;

  ElectricInvoiceUserModel({this.vnptRes, this.data});

  ElectricInvoiceUserModel.fromJson(Map<String, dynamic> json) {
    vnptRes = json['vnpt_res'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vnpt_res'] = vnptRes;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  int? customId;
  String? system;
  String? userAdmin;
  String? passAdmin;
  String? userService;
  String? passService;
  String? taxCode;
  String? loginLink;
  String? lookupLink;
  int? type;
  bool? status;

  UserData({
    this.id,
    this.name,
    this.customId,
    this.system,
    this.userAdmin,
    this.passAdmin,
    this.userService,
    this.passService,
    this.taxCode,
    this.loginLink,
    this.lookupLink,
    this.type,
    this.status,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    customId = json['custom_id'];
    system = json['system'];
    userAdmin = json['user_admin'];
    passAdmin = json['pass_admin'];
    userService = json['user_service'];
    passService = json['pass_service'];
    taxCode = json['tax_code'];
    loginLink = json['login_link'];
    lookupLink = json['lookup_link'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['custom_id'] = customId;
    data['system'] = system;
    data['user_admin'] = userAdmin;
    data['pass_admin'] = passAdmin;
    data['user_service'] = userService;
    data['pass_service'] = passService;
    data['tax_code'] = taxCode;
    data['login_link'] = loginLink;
    data['lookup_link'] = lookupLink;
    data['type'] = type;
    data['status'] = status;
    return data;
  }
}

class ElectricInvoiceAccountModel {
  String? ownCA;
  String? serialNumber;
  String? validFrom;
  String? validTo;
  String? organizationCA;

  ElectricInvoiceAccountModel({
    this.ownCA,
    this.serialNumber,
    this.validFrom,
    this.validTo,
    this.organizationCA,
  });

  ElectricInvoiceAccountModel.fromJson(Map<String, dynamic> json) {
    ownCA = json['OwnCA'];
    serialNumber = json['SerialNumber'];
    validFrom = json['ValidFrom'];
    validTo = json['ValidTo'];
    organizationCA = json['OrganizationCA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OwnCA'] = ownCA;
    data['SerialNumber'] = serialNumber;
    data['ValidFrom'] = validFrom;
    data['ValidTo'] = validTo;
    data['OrganizationCA'] = organizationCA;
    return data;
  }
}
