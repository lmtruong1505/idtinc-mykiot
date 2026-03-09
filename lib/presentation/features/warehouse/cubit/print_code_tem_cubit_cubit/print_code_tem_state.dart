
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/receipt_import_detail_model.dart';

part 'print_code_tem_state.freezed.dart';

@freezed
class PrintCodeTemState with _$PrintCodeTemState {
  const factory PrintCodeTemState({
    @Default([]) List<ReceiptImportDetailModel> shipments,
  }) = _PrintCodeTemState;
}
