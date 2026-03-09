import '../../domain/entities/payload_create_export_receipt_entity.dart';

class PayloadCreateExportReceiptModel extends PayloadCreateExportReceiptEntity {
  PayloadCreateExportReceiptModel({
    super.exportInfor,
    super.exportReceipt,
  });

  Map<String, dynamic> toJson() => {
        'export_receipt': exportReceipt?.toJson(),
        'export_infor': exportInfor == null
            ? []
            : List<dynamic>.from(exportInfor!.map((x) => x.toJson())),
      };
}
