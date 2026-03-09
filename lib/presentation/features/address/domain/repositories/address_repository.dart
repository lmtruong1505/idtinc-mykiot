import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/address/data/models/district_model.dart';
import 'package:pharmago/presentation/features/address/data/models/province_model.dart';
import 'package:pharmago/presentation/features/address/data/models/ward_model.dart';

abstract class AddressRepository {
  Future<BaseResponseModel<List<WardModel>>> getWards({
    required String districtCode,
  });

  Future<BaseResponseModel<List<DistrictModel>>> getDistricts({
    required String provinceCode,
  });

  Future<BaseResponseModel<List<ProvinceModel>>> getProvinces();
}
