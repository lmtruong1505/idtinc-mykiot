import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../warehouse/widgets/receipt_import_create_item.dart';
import '../../../domain/entities/image_receipt_entity.dart';
import '../../../domain/entities/receipt_ai_extract_response.dart';
import '../../../domain/usecase/receipt_ai_extract_use_case.dart';
import 'image_picker_state.dart';

@injectable
class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit(
    this._receiptAiExtractUsecase,
  ) : super(const ImagePickerState()) {
    picker = ImagePicker();
  }

  final ReceiptAiExtractUsecase _receiptAiExtractUsecase;

  ImagePicker? picker;

  Future<void> imagePickerHandle(
    ImageReceiptSourceEnum source, {
    bool isMulti = false,
  }) async {
    final sourcePackage = switch (source) {
      ImageReceiptSourceEnum.camera => ImageSource.camera,
      ImageReceiptSourceEnum.gallery => ImageSource.gallery,
    };
    if (picker == null) return;
    final List<ImageReceiptEntity> imageFromPicker = List.from(state.images);
    if (isMulti) {
      final List<XFile>? images = await picker?.pickMultiImage();
      imageFromPicker.addAll(
        (images ?? []).map((e) {
          return ImageReceiptEntity(
            path: e.path,
            name: e.name,
            source: ImageReceiptSourceEnum.gallery,
          );
        }),
      );
    } else {
      final XFile? image = await picker?.pickImage(source: sourcePackage);
      if (image != null) {
        imageFromPicker.add(
          ImageReceiptEntity(
            path: image.path,
            name: image.name,
            source: source,
          ),
        );
      }
    }
    emit(state.copyWith(images: imageFromPicker));
  }

  void deleteImage(int index) {
    final List<ImageReceiptEntity> images = List.from(state.images);
    images.removeAt(index);
    emit(state.copyWith(images: images));
  }

  Future<void> receiptAiExtractHanel() async {
    final payload = ReceiptAiExtractPayload(
      files: state.images.map((e) => File(e.path!)).toList(),
      workspaceId: getCompany!.toString(),
    );
    final input = ReceiptAiExtractInput(payload: payload);
    final res = await _receiptAiExtractUsecase.execute(input);
    final listImageRes = res.response.data?.images ?? [];
    final listImageStateCopy = List<ImageReceiptEntity>.from(state.images);
    for (final item in listImageRes) {
      final index = listImageStateCopy.indexWhere(
        (e) => e.path?.contains(item.name ?? '') ?? false,
      );
      if (index == -1) continue;
      listImageStateCopy[index] = listImageStateCopy[index].copyWith(
        name: item.name,
        messageAi: item.messageAi,
        statusAi: item.messageAi == 'OK' ? 200 : 400,
        count: item.count,
      );
    }
    // các đối tượng products được trả về từ response AI phải có đơn vị nằm trong list [unitsMetaData] thì mới được add vào state
    final productsStateCopy = List<ReceiptAiExtractItem>.from(state.products);
    for (final item in (res.response.data?.details ?? <ReceiptAiExtractItem>[])) {
      final check = unitsMetaData.indexWhere((e) => e.name == item.unitExtract);
      if (check == -1) {
        productsStateCopy.add(item.copyWith(unitExtract: 'Hộp'));
      } else {
        productsStateCopy.add(item);
      }
    }
    emit(
      state.copyWith(
        images: listImageStateCopy,
        products: productsStateCopy,
      ),
    );
  }
}
