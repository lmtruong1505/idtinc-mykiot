
import '../../../features/company/data/models/company_model.dart';
import '../role/role_model.dart';

class WorkingDataModel {
  int? id;
  int? userId;
  int? workspaceId;
  String? startedWorking;
  String? finishedWorking;
  String? employeeCode;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? createdById;
  int? updatedById;
  CompanyModel? company;
  List<RoleListModel> roleData = [];
  int? appointments;

  //List<Null>? positionData;
  String? statusVn;

  WorkingDataModel({
    this.id,
    this.userId,
    this.workspaceId,
    this.startedWorking,
    this.finishedWorking,
    this.employeeCode,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdById,
    this.updatedById,
    this.company,
    this.roleData = const [],
    // this.positionData,
    this.statusVn,
    this.appointments,
  });

  WorkingDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    workspaceId = json['workspace_id'];
    startedWorking = json['started_working'];
    finishedWorking = json['finished_working'];
    employeeCode = json['employee_code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdById = json['created_by_id'];
    updatedById = json['updated_by_id'];
    company =
        json['company'] != null ? CompanyModel.fromJson(json['company']) : null;
    if (json['role_data'] != null) {
      roleData = <RoleListModel>[];
      json['role_data'].forEach((v) {
        roleData.add(RoleListModel.fromJson(v));
      });
    }
    // if (json['position_data'] != null) {
    //   positionData = <Null>[];
    //   json['position_data'].forEach((v) {
    //     positionData!.add(new Null.fromJson(v));
    //   });
    // }
    statusVn = json['status_vn'];
    appointments = json['appointments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['workspace_id'] = workspaceId;
    data['started_working'] = startedWorking;
    data['finished_working'] = finishedWorking;
    data['employee_code'] = employeeCode;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by_id'] = createdById;
    data['updated_by_id'] = updatedById;
    if (company != null) {
      data['company'] = company!.toJson();
    }
    data['role_data'] = roleData.map((v) => v.toJson()).toList();
      // if (this.positionData != null) {
    //   data['position_data'] =
    //       this.positionData!.map((v) => v.toJson()).toList();
    // }
    data['status_vn'] = statusVn;
    data['appointments'] = appointments;
    return data;
  }
}
