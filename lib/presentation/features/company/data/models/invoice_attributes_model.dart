import '../../domain/entities/invoice_attributes_entity.dart';

class InvoiceAttributesModel extends InvoiceAttributesEntity {
  InvoiceAttributesModel({
    super.defaultFlag,
    super.id,
    super.name,
    super.pattern,
    super.serial,
    super.workspace,
  });

  factory InvoiceAttributesModel.fromJson(Map<String, dynamic> json) =>
      InvoiceAttributesModel(
        id: json['id'],
        name: json['name'],
        pattern: json['pattern'],
        serial: json['serial'],
        workspace: json['workspace'],
        defaultFlag: json['default_flag'],
      );
}
