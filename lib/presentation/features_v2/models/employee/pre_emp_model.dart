import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';

import 'working_data_model.dart';

class PreEmpModel {
  int? id;
  int? employee;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserDataModel? userData;
  List<WorkingDataModel> workingData = [];

  PreEmpModel({
    this.id,
    this.employee,
    this.createdAt,
    this.updatedAt,
    this.userData,
    this.workingData = const [],
  });

  PreEmpModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employee = json['employee'];
    if (json['created_at'] != null) {
      createdAt = DateTime.parse(json['created_at']);
    }
    if (json['updated_at'] != null) {
      updatedAt = DateTime.parse(json['updated_at']);
    }
    userData = json['user_data'] != null
        ? UserDataModel.fromJson(json['user_data'])
        : null;
    if (json['working_data'] != null) {
      workingData = <WorkingDataModel>[];
      json['working_data'].forEach((v) {
        workingData.add(WorkingDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee'] = employee;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    data['working_data'] = workingData.map((v) => v.toJson()).toList();
    return data;
  }
}
