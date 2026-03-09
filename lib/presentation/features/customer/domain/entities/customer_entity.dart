import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';

import '../../../conversation/domain/entities/conversation_entity.dart';

part 'customer_entity.freezed.dart';

@freezed
class CustomerEntity with _$CustomerEntity {
  const CustomerEntity._();

  const factory CustomerEntity({
    int? id,
    String? code,
    String? name,
    String? phone,
    String? email,
    int? company,
    AddressEntity? address,
    DateTime? birthday,
    int? gender,
    int? group,
    String? license,
    double? revenue,
    int? orders,
    String? title,
    DateTime? licenseDate,
    String? contactName,
    String? contactTitle,
    String? contactPhone,
    String? contactEmail,
    AddressEntity? contactAddress,
    String? accountNumber,
    String? bankName,
    String? bankBranch,
    ConversationEntity? conversation,
  }) = _CustomerEntity;
}
