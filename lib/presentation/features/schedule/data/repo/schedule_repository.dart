import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';

import '../../../../../data/apis/end_point.dart';
import '../../../../../data/config/dio.dart';
import '../../../../features_v2/models/product/image_model.dart';
import '../../../../shared/utils/get.dart';
import '../models/appointment_payload_data.dart';
import '../models/diagnosis_model.dart';
import '../models/pathology_model.dart';
import '../models/prescription_model.dart';
import '../models/prescription_payload_model.dart';

abstract class ScheduleRepository {
  Future<BaseResponseModel<int>> create({
    required AppointmentPayloadData data,
    required List<File> images,
    required List<File> files,
  });

  Future<BaseResponseModel<int>> update({
    required int id,
    required AppointmentPayloadData data,
  });

  Future<BaseResponseModel<PrescriptionModel>> getPrescription({
    required int idSchedule,
  });

  Future<BaseResponseModel<int>> createPrescription({
    required PrescriptionPayloadModel data,
  });

  Future<BaseResponseModel<DiagnosisModel>> getDiagnosis({
    required int idSchedule,
  });

  Future<BaseResponseModel<List<PathologyModel>>> getPathologies({
    required int page,
    required int limit,
    String? search,
  });

  Future<BaseResponseModel<int>> createPathologies({
    required String name,
    required String code,
  });

  Future<BaseResponseModel<int>> updateConclusion({
    required int idSchedule,
    required String conclusion,
    required String note,
    required List<File> images,
    required List<File> files,
  });

  Future<BaseResponseModel<int>> createConclusionService({
    required int idService,
    required String conclusion,
    List<File>? files,
  });

  Future<BaseResponseModel<int>> updateConclusionService({
    required int id,
    required String conclusion,
    List<ImageModel>? filesUpdate,
    List<File>? files,
  });
}

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl extends ScheduleRepository {
  ScheduleRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<int>> create({
    required AppointmentPayloadData data,
    required List<File> images,
    required List<File> files,
  }) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode(data.toJson()),
      });
      for (final e in images) {
        final image = await MultipartFile.fromFile(e.path);
        formData.files.add(MapEntry('images', image));
      }
      for (final e in files) {
        final image = await MultipartFile.fromFile(e.path);
        formData.files.add(MapEntry('files', image));
      }
      final res = await _dio.post(
        Api.createSchedule,
        data: formData,
      );
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: res.data['details']['id'],
        extra: res.data['details']['uuid'],
      );
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> createPrescription({
    required PrescriptionPayloadModel data,
  }) async {
    try {
      final res = await _dio.post(
        Api.createPrescription,
        data: data.toJson(),
      );
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: res.data['data']['id'],
      );
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  @override
  Future<BaseResponseModel<PrescriptionModel>> getPrescription({
    required int idSchedule,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.detailPrescription}/$idSchedule',
      );
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: PrescriptionModel.fromJson(res.data['data']),
      );
    } catch (e) {
      print(e);
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  @override
  Future<BaseResponseModel<DiagnosisModel>> getDiagnosis({
    required int idSchedule,
  }) async {
    try {
      final res = await _dio.get(
        '${Api.diagnosis}/$idSchedule',
      );
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: DiagnosisModel.fromJson(res.data['data']),
      );
    } catch (e) {
      log('--- $e');
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> update({
    required int id,
    required AppointmentPayloadData data,
  }) async {
    try {
      final res = await _dio.put(
        '${Api.detailEvent}$id',
        data: data.toJson(),
      );
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: res.data['details']['id'],
        extra: res.data['details']['uuid'],
      );
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  @override
  Future<BaseResponseModel<List<PathologyModel>>> getPathologies({
    required int page,
    required int limit,
    String? search,
  }) async {
    try {
      final query = {
        'page': page,
        'limit': limit,
        'search': search,
      };
      final res = await _dio.get(Api.pathologies, data: query);
      final data = (res.data['details'] as List).map((e) {
        return PathologyModel.fromJson(e);
      }).toList();
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: data,
      );
    } catch (e) {
      log('--- $e');
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> updateConclusion({
    required int idSchedule,
    required String conclusion,
    required String note,
    required List<File> images,
    required List<File> files,
  }) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode({
          'conclusion': conclusion,
          'note': note,
        }),
      });
      for (final e in images) {
        final image = await MultipartFile.fromFile(e.path);
        formData.files.add(MapEntry('images', image));
      }
      for (final e in files) {
        final image = await MultipartFile.fromFile(e.path);
        formData.files.add(MapEntry('files', image));
      }
      final res = await _dio.put(
        '${Api.updateConclusion}/$idSchedule',
        data: formData,
      );
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: res.data['details']['id'],
      );
    } catch (e) {
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> createConclusionService({
    required int idService,
    required String conclusion,
    List<File>? files,
  }) async {
    try {
      final formData = FormData.fromMap({
        'data': jsonEncode({
          'appointment_service': idService,
          'conclusion': conclusion,
        }),
      });
      for (final file in files ?? []) {
        final e = await MultipartFile.fromFile(file.path);
        formData.files.add(MapEntry('files', e));
      }
      final res = await _dio.post(
        Api.serviceConclusion,
        data: formData,
      );
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> updateConclusionService({
    required int id,
    required String conclusion,
    List<ImageModel>? filesUpdate,
    List<File>? files,
  }) async {
    try {
      final formData = FormData.fromMap({
        'conclusion': conclusion,
        'files_update': (filesUpdate?.isEmpty ?? true)
            ? []
            : filesUpdate!.map((e) => e.toJson()).toList(),
      });
      for (final file in files ?? []) {
        final e = await MultipartFile.fromFile(file.path);
        formData.files.add(MapEntry('files_add', e));
      }
      final res = await _dio.put(
        '${Api.detailPhieuKham}$id',
        data: formData,
      );
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
        data: res.data['details'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<int>> createPathologies({
    required String name,
    required String code,
  }) async {
    try {
      final query = {
        'code': code,
        'name': name,
        'name_vn': name,
        'level': 1,
        'workspace': getCompany,
      };
      final res = await _dio.post(Api.pathologies, data: query);
      return BaseResponseModel(
        message: res.data['message'],
        code: res.data['code'],
        data: res.data['data']['id'],
      );
    } catch (e) {
      log('--- $e');
      return BaseResponseModel(
        message: e.toString(),
        code: 400,
      );
    }
  }
}
