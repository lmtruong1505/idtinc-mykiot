import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/address/data/models/district_model.dart';
import 'package:pharmago/presentation/features/address/data/models/province_model.dart';
import 'package:pharmago/presentation/features/address/data/models/ward_model.dart';
import 'package:pharmago/presentation/features/address/domain/repositories/address_repository.dart';

@LazySingleton(as: AddressRepository)
class AddressRepositoryImpl extends AddressRepository {
  AddressRepositoryImpl(this._dio);
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<List<DistrictModel>>> getDistricts({
    required String provinceCode,
  }) async {
    try {
      final res = await _dio
          .post('${Api.address}/district', data: {'province': provinceCode});
      final data = (res.data['details'] as List)
          .map((e) => DistrictModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<ProvinceModel>>> getProvinces() async {
    try {
      final res = await _dio.post('${Api.address}/province');
      final data = (res.data['details'] as List)
          .map((e) => ProvinceModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponseModel<List<WardModel>>> getWards({
    required String districtCode,
  }) async {
    try {
      final res = await _dio.post(
        '${Api.address}/ward',
        data: {'district': districtCode},
      );
      final data = (res.data['details'] as List)
          .map((e) => WardModel.fromJson(e))
          .toList();
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: data,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
