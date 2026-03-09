import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/image_receipt_entity.dart';
import '../../../domain/entities/receipt_ai_extract_response.dart';

part 'image_picker_state.freezed.dart';

@freezed
class ImagePickerState with _$ImagePickerState {
  const factory ImagePickerState({
    @Default([]) List<ImageReceiptEntity> images,
    @Default([]) List<ReceiptAiExtractItem> products,
  }) = _ImagePickerState;
}
