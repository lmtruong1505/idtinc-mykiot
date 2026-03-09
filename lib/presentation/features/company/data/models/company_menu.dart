class CompanyMenu {
  int? id;
  int? parentId;
  String? typeCode;
  String? workspaceName;
  String? workspaceCode;
  String? phoneNumber;

  CompanyMenu({
    this.id,
    this.parentId,
    this.typeCode,
    this.workspaceName,
    this.workspaceCode,
    this.phoneNumber,
  });

  CompanyMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    typeCode = json['type'];
    workspaceName = json['workspace_name'];
    workspaceCode = json['workspace_code'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['type'] = typeCode;
    data['workspace_name'] = workspaceName;
    data['workspace_code'] = workspaceCode;
    data['phone_number'] = phoneNumber;
    return data;
  }
}
