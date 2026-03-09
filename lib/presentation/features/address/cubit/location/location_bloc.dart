import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features/address/data/models/district_model.dart';
import 'package:pharmago/presentation/features/address/data/models/province_model.dart';
import 'package:pharmago/presentation/features/address/data/models/ward_model.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/address/domain/repositories/address_repository.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../data/models/location_model.dart';
import '../../../../features_v2/blocs/enum/address_status.dart';
import '../../../../features_v2/blocs/state/init_state.dart';

class LocationBloc extends Cubit<CubitState> {
  LocationBloc() : super(CubitState());

  final _repo = getIt<AddressRepository>();
  final List<LocationModel> provinces = [];
  final List<LocationModel> districts = [];
  final List<LocationModel> wards = [];

  LocationModel? province;
  LocationModel? district;
  LocationModel? ward;
  String? address;

  getDataDefault({
    BackAddress? value,
  }) async {
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        addressStatus: AddressStatus.province,
      ),
    );
    provinces.clear();
    districts.clear();
    wards.clear();

    final resProvince = await _repo.getProvinces();
    provinces.addAll(mapList(provinces1: resProvince.data));

    if (value?.province != null) {
      final resDistrict =
          await _repo.getDistricts(provinceCode: value?.province?.code ?? '');
      districts.addAll(mapList(districts1: resDistrict.data));
    }

    if (value?.district != null) {
      final resWard =
          await _repo.getWards(districtCode: value?.district?.code ?? '');
      wards.addAll(mapList(wards1: resWard.data));
    }

    if (provinces.isNotEmpty && value?.province != null) {
      province = value?.province;
    }
    if (districts.isNotEmpty && value?.district != null) {
      district = value?.district;
    }
    if (wards.isNotEmpty && value?.ward != null) {
      ward = value?.ward;
    }
    if (value?.address != null) {
      address = value?.address;
    }

    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  getProvinces() async {
    provinces.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        addressStatus: AddressStatus.province,
      ),
    );
    final res = await _repo.getProvinces();
    provinces.addAll(mapList(provinces1: res.data));
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  getDistricts(String code) async {
    districts.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        addressStatus: AddressStatus.district,
      ),
    );
    final res = await _repo.getDistricts(provinceCode: code);
    districts.addAll(mapList(districts1: res.data));
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  getWards(String code) async {
    wards.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        addressStatus: AddressStatus.ward,
      ),
    );
    final res = await _repo.getWards(districtCode: code);
    wards.addAll(mapList(wards1: res.data));
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  List<LocationModel> mapList({
    List<ProvinceModel>? provinces1,
    List<DistrictModel>? districts1,
    List<WardModel>? wards1,
  }) {
    List<LocationModel> list = [];
    if (provinces1 != null) {
      list = provinces1
          .map(
            (e) => LocationModel(
              code: e.code,
              title: e.name,
              title2: e.nameEn,
            ),
          )
          .toList();
    }
    if (districts1 != null) {
      list = districts1
          .map(
            (e) => LocationModel(
              code: e.code,
              title: e.name,
              title2: e.nameEn,
            ),
          )
          .toList();
    }
    if (wards1 != null) {
      list = wards1
          .map(
            (e) => LocationModel(
              code: e.code,
              title: e.name,
              title2: e.nameEn,
            ),
          )
          .toList();
    }
    list.sort((a, b) => a.title2![0].compareTo(b.title2![0]));
    return list;
  }

  setProvince(LocationModel? value) {
    province = value;
    district = null;
    ward = null;
    address = null;
    districts.clear();
    wards.clear();

    getDistricts(value?.code ?? '');
  }

  setDistict(LocationModel? value) {
    district = value;
    ward = null;
    address = null;
    wards.clear();
    getWards(value?.code ?? '');
  }

  setWard(LocationModel? value) {
    ward = value;
    address = null;
    emit(state.copyWith(status: BlocStatus.success));
  }

  setAddress(String? value) {
    address = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  bool get addressOk =>
      province != null &&
      district != null &&
      ward != null &&
      !address.validator.trim().isEmptyOrNull;
}

class BackAddress {
  LocationModel? province;
  LocationModel? district;
  LocationModel? ward;
  String? address;
  BackAddress({
    this.province,
    this.district,
    this.ward,
    this.address,
  });
  factory BackAddress.mapData(AddressModel? value) {
    return BackAddress(
      address: value?.title,
      province: LocationModel(
        code: value?.province?.code,
        title: value?.province?.name,
      ),
      district: LocationModel(
        code: value?.district?.code,
        title: value?.district?.name,
      ),
      ward: LocationModel(
        code: value?.ward?.code,
        title: value?.ward?.name,
      ),
    );
  }

  factory BackAddress.mapAddressEntity(AddressEntity? value) {
    return BackAddress(
      address: value?.title,
      province: LocationModel(
        code: value?.province?.code,
        title: value?.province?.name,
      ),
      district: LocationModel(
        code: value?.district?.code,
        title: value?.district?.name,
      ),
      ward: LocationModel(
        code: value?.ward?.code,
        title: value?.ward?.name,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province': province?.code,
      'district': district?.code,
      'ward': ward?.code,
      'address': address,
    };
  }
}

extension BackAddressExt on BackAddress {
  String? get addressDetail {
    final String addressText = address == null ? '' : '$address, ';

    final String wardText = ward?.title == null ? '' : '${ward?.title}, ';
    final String districtText =
        district?.title == null ? '' : '${district?.title}, ';
    final String provinceText =
        province?.title == null ? '' : '${province?.title}';

    return '$addressText$wardText$districtText$provinceText';
  }
}
