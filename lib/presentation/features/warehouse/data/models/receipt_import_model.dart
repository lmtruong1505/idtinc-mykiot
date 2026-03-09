import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_import_model.freezed.dart';
part 'receipt_import_model.g.dart';

@freezed
class ReceitExportModel with _$ReceitExportModel {
  const factory ReceitExportModel({
    final int? id,
    final String? code,
    final String? reason,
    final String? provider,
    @JsonKey(name: 'user_check') final String? userCheck,
    @JsonKey(name: 'warehouse_id') final int? warehouseId,
    @JsonKey(name: 'total_price') final num? totalPrice,
    @JsonKey(name: 'status_balance_warehouse')
    final bool? statusBalanceWarehouse,
    @JsonKey(name: 'status_id') final int? statusId,
    @JsonKey(name: 'transfer_receipt_id') final int? transferReceiptId,
    @JsonKey(name: 'check_receipt_id') final int? checkReceiptId,
    @JsonKey(name: 'user_created') final num? userCreated,
    @JsonKey(name: 'user_updated') final num? userUpdated,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'warehouse_data') final dynamic warehouseData,
    @JsonKey(name: 'status_data') final StatusData? statusData,
    @JsonKey(name: 'file_data') final List<FileDataModel>? files,
    @JsonKey(name: 'user_created_data') final UserAtedData? userCreatedData,
    @JsonKey(name: 'user_updated_data') final UserAtedData? userUpdatedData,
    @JsonKey(name: 'checker_data') final UserAtedData? checkerData,
  }) = _ReceitExportModel;

  factory ReceitExportModel.fromJson(Map<String, dynamic> json) =>
      _$ReceitExportModelFromJson(json);
}

@freezed
class StatusData with _$StatusData {
  const factory StatusData({
    final int? id,
    final String? title,
    final String? code,
  }) = _StatusData;

  factory StatusData.fromJson(Map<String, dynamic> json) =>
      _$StatusDataFromJson(json);
}

@freezed
class UserAtedData with _$UserAtedData {
  const factory UserAtedData({
    final int? id,
    @JsonKey(name: 'full_name') final String? fullName,
    final String? code,
    @JsonKey(name: 'phone_number') final String? phoneNumber,
    final String? email,
    @JsonKey(name: 'address_string') final String? addressString,
    @JsonKey(name: 'identify_number') final dynamic identifyNumber,
  }) = _UserAtedData;

  factory UserAtedData.fromJson(Map<String, dynamic> json) =>
      _$UserAtedDataFromJson(json);
}

@freezed
class FileDataModel with _$FileDataModel {
  const factory FileDataModel({
    final int? id,
    final String? alt,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    final String? image,
  }) = _FileDataModel;

  factory FileDataModel.fromJson(Map<String, dynamic> json) =>
      _$FileDataModelFromJson(json);
}
