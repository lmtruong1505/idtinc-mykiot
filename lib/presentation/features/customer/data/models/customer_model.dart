import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features/conversation/data/models/conversation_model.dart';

import '../../../../features_v2/models/customer/user_zalo_model.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class CustomerModel with _$CustomerModel {
  const CustomerModel._();

  const factory CustomerModel({
    int? id,
    String? code,
    String? image,
    String? uuid,
    @JsonKey(name: 'full_name') String? fullName,
    int? company,
    AddressModel? address,
    String? phone,
    String? email,
    DateTime? birthday,
    int? gender,
    int? group,
    String? license,
    double? revenue,
    int? orders,
    String? title,
    @JsonKey(name: 'license_date') DateTime? licenseDate,
    @JsonKey(name: 'issued_by') String? issuedBy,
    @JsonKey(name: 'contact_name') String? contactName,
    @JsonKey(name: 'contact_title') String? contactTitle,
    @JsonKey(name: 'contact_phone') String? contactPhone,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'contact_address') AddressModel? contactAddress,
    @JsonKey(name: 'account_number') String? accountNumber,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'bank_branch') String? bankBranch,
    @JsonKey(name: 'user_created') String? userCreated,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'user_updated') String? userUpdated,
    @JsonKey(name: 'updated_at') String? updateAt,
    ConversationModel? conversation,
    @JsonKey(name: 'user_zalo') UserZaloModel? zalo,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
}
