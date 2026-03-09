import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features/company/data/models/bank_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    int? id,
    String? email,
    String? code,
    @JsonKey(name: 'phone_number')
    String? phoneNumber,
    @JsonKey(name: 'full_name')
    String? fullName,
    @JsonKey(name: 'is_active')
    bool? isActive,
    String? gender,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
    @JsonKey(name: 'updated_at')
    DateTime? updatedAt,
    String? website,
    @JsonKey(name: 'date_of_birth')
    DateTime? dateOfBirth,
    @JsonKey(name: 'identify_number')
    String? identifyNumber,
    @JsonKey(name: 'provided_date')
    DateTime? providedDate,
    @JsonKey(name: 'provided_place')
    String? providedPlace,
    @JsonKey(name: 'tax_number')
    String? taxNumber,
    @JsonKey(name: 'fax_number')
    String? faxNumber,
    @JsonKey(name: 'is_supplier')
    bool? isSupplier,
    @JsonKey(name: 'account_name')
    String? accountName,
    @JsonKey(name: 'account_number')
    String? accountNumber,
    BankModel? bank,
    AddressModel? address,
    @JsonKey(name: 'account_type')
    String? accountType,
    String? avatar,
    @JsonKey(name: 'is_delete')
    bool? isDelete,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}



