import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class ImportRecieptUseCase {
  final WarehouseRepository _repository;

  ImportRecieptUseCase(this._repository);
  Future<BaseResponseModel<List<ReceitExportModel>>> getList(
    ImportReceiptInput input,
  ) async {
    final res = await _repository.getListImportReceipt(input);
    return res;
  }

  Future<BaseResponseModel> createReceipt(CreateReceiptInput input) async {
    final res = await _repository.createReceipt(input);
    return res;
  }
}

class ImportReceiptInput {
  final String? search;
  final int page;
  final String? status;
  final int? id;
  final String? typeCode;

  ImportReceiptInput({
    required this.search,
    required this.page,
    required this.status,
    required this.id,
    this.typeCode,
  });
}

class CreateReceiptInput {
  ImportReceiptModel? importReceipt;
  List<Shipment>? shipment;
  List<XFile>? images;

  CreateReceiptInput({this.importReceipt, this.shipment, this.images});

  CreateReceiptInput.fromJson(Map<String, dynamic> json) {
    importReceipt = json['import_receipt'] != null
        ? ImportReceiptModel.fromJson(json['import_receipt'])
        : null;
    if (json['shipment'] != null) {
      shipment = <Shipment>[];
      json['shipment'].forEach((v) {
        shipment!.add(Shipment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (importReceipt != null) {
      data['import_receipt'] = importReceipt!.toJson();
    }
    if (shipment != null) {
      data['shipment'] = shipment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImportReceiptModel {
  String? code;
  String? reason;
  int? warehouse;
  num? totalPrice;
  String? provider;
  num? checker;

  ImportReceiptModel({
    required this.code,
    required this.reason,
    required this.warehouse,
    required this.totalPrice,
    required this.provider,
    required this.checker,
  });

  ImportReceiptModel.fromJson(Map<String, dynamic> json) {
    // code = json['code'];
    reason = json['reason'];
    warehouse = json['warehouse'];
    totalPrice = json['total_price'];
    provider = json['provider'];
    checker = json['checker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['code'] = code;
    data['reason'] = reason;
    data['warehouse'] = warehouse;
    data['total_price'] = totalPrice;
    data['provider'] = provider;
    data['checker'] = checker;
    return data;
  }
}

class Shipment {
  String? slot;
  String? code;
  String? startDate;
  String? endDate;
  num? variant;
  num? storageUnit;
  num? inputUnit;
  // Null? typeItems;
  num? importPrice;
  num? totalImportPrice;
  num? inputQuantity;
  num? warehouseImport;

  Shipment({
    required this.slot,
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.variant,
    required this.storageUnit,
    required this.inputUnit,
    required this.importPrice,
    required this.totalImportPrice,
    required this.inputQuantity,
    required this.warehouseImport,
  });

  Shipment.fromJson(Map<String, dynamic> json) {
    // slot = json['slot'];
    code = json['code'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    variant = json['variant'];
    storageUnit = json['storage_unit'];
    inputUnit = json['input_unit'];
    importPrice = json['import_price'];
    totalImportPrice = json['total_import_price'];
    inputQuantity = json['input_quantity'];
    warehouseImport = json['warehouse_import'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['slot'] = slot;
    data['code'] = code;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['variant'] = variant;
    data['storage_unit'] = storageUnit;
    data['input_unit'] = inputUnit;
    data['import_price'] = importPrice;
    data['total_import_price'] = totalImportPrice;
    data['input_quantity'] = inputQuantity;
    data['warehouse_import'] = warehouseImport;
    return data;
  }
}
