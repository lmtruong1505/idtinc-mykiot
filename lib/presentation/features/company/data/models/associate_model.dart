import 'company_model.dart';

class AssociateModel {
  final CompanyModel? workspace;
  final String? associateCode;
  final CompanyModel? workspaceAssociate;
  final bool connected;

  AssociateModel({
    this.workspace,
    this.associateCode,
    this.workspaceAssociate,
    this.connected = false,
  });

  AssociateModel copyWith({
    CompanyModel? workspace,
    String? associateCode,
    CompanyModel? workspaceAssociate,
    bool? connected,
  }) =>
      AssociateModel(
        workspace: workspace ?? this.workspace,
        associateCode: associateCode ?? this.associateCode,
        workspaceAssociate: workspaceAssociate ?? this.workspaceAssociate,
        connected: connected ?? this.connected,
      );

  factory AssociateModel.fromJson(Map<String, dynamic> json) => AssociateModel(
        workspace: json['workspace'] != null
            ? CompanyModel.fromJson(json['workspace'])
            : null,
        associateCode: json['code_associate'],
        workspaceAssociate: json['workspace_associate'] != null
            ? CompanyModel.fromJson(json['workspace_associate'])
            : null,
        connected: json['connected'] ?? false,
      );
}
