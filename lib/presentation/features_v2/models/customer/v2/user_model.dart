class UserV2Model {
  String? phoneNumber;
  String? fullName;
  bool? isActive;

  UserV2Model({this.phoneNumber, this.fullName, this.isActive});

  UserV2Model.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    fullName = json['full_name'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    data['full_name'] = fullName;
    data['is_active'] = isActive;
    return data;
  }
}
