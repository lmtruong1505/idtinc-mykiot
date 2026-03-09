import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/invoice_attributes_entity.dart';

part 'e_invoice_state.freezed.dart';

@freezed
class EInvoiceState with _$EInvoiceState {
  const factory EInvoiceState({
    String? username,
    String? password,
    String? errMsg,
    int? status,
    @Default([]) List<InvoiceAttributesEntity> invoiceAttributes,
  }) = _EInvoiceState;
}
