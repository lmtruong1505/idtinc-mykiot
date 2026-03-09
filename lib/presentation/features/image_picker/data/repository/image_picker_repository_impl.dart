import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/image_picker/data/models/receipt_ai_extract_response_model.dart';
import 'package:pharmago/presentation/features/image_picker/domain/entities/receipt_ai_extract_response.dart';
import 'package:pharmago/presentation/features/image_picker/domain/repository/image_picker_repository.dart';

import '../../../../../data/apis/end_point.dart';

@LazySingleton(as: ImagePickerRepository)
class ImagePickerRepositoryImpl extends ImagePickerRepository {
  ImagePickerRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<ReceiptAiExtractResponse>> extractInvoice(
    ReceiptAiExtractPayload payload,
  ) async {
    try {
      final data = FormData.fromMap(
        {
          'workspace_id': payload.workspaceId,
        },
      );
      for (final item in payload.files) {
        data.files.add(
          MapEntry(
            'file', // hoặc 'files[$i]' nếu API yêu cầu
            await MultipartFile.fromFile(
              item.path,
              filename: item.path.split('/').last,
            ),
          ),
        );
      }
      final res = await _dio.postWithUrl(
        Api.invoiceAiExtract,
        data: data,
      );
      final resData = ReceiptAiExtractResponseModel.fromJson(res.data);
      return BaseResponseModel(
        data: resData,
      );
    } catch (e) {
      log('--- extractInvoice/err: $e');
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
