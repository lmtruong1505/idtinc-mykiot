import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/address/data/models/district_model.dart';
import 'package:pharmago/presentation/features/address/data/models/province_model.dart';
import 'package:pharmago/presentation/features/address/data/models/ward_model.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel with _$AddressModel {
  const AddressModel._();

  const factory AddressModel({
    int? id,
    double? lat,
    double? lng,
    ProvinceModel? province,
    DistrictModel? district,
    WardModel? ward,
    String? title,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

extension AddressModelExt on AddressModel {
  String get fullAddress {
    return '${title ?? ''}, ${ward?.name ?? ''}, ${district?.name ?? ''}, ${province?.name ?? ''}';
  }
}
