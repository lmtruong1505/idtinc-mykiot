import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';
import 'package:pharmago/presentation/features_v2/models/employee/working_data_model.dart';

class EmpModel {
  int? employeeId;
  UserDataModel? userData;
  List<WorkingDataModel>? workingData = [];

  EmpModel({
    this.userData,
    this.workingData,
    this.employeeId,
  });

  EmpModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee'];
    userData = json['user_data'] != null
        ? UserDataModel.fromJson(json['user_data'])
        : null;
    if (json['working_data'] != null) {
      workingData = <WorkingDataModel>[];
      json['working_data'].forEach((v) {
        workingData!.add(WorkingDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    if (workingData != null) {
      data['working_data'] = workingData!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  EmpModel copyWith({
    UserDataModel? userData,
    List<WorkingDataModel>? workingData,
  }) {
    return EmpModel(
      userData: userData ?? this.userData,
      workingData: workingData ?? this.workingData,
    );
  }
}
