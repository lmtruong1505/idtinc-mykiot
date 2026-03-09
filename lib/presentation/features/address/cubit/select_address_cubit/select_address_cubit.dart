import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';
import 'package:pharmago/presentation/features/address/domain/usecases/get_districts_use_case.dart';
import 'package:pharmago/presentation/features/address/domain/usecases/get_province_use_case.dart';
import 'package:pharmago/presentation/features/address/domain/usecases/get_wards_use_case.dart';

import 'select_address_state.dart';

extension More on ScrollController {
  void scrollToTop() {
    animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}

@injectable
class SelectAddressCubit extends Cubit<SelectAddressState> {
  SelectAddressCubit(
    this._getProvinceUseCase,
    this._getDistrictUseCase,
    this._getWardUseCase,
  ) : super(const SelectAddressState());

  final GetProvinceUseCase _getProvinceUseCase;
  final GetDistrictUseCase _getDistrictUseCase;
  final GetWardUseCase _getWardUseCase;

  final scrollController = ScrollController();

  void init({
    AddressItemEntity? province,
    AddressItemEntity? district,
    AddressItemEntity? ward,
    String? detail,
  }) {
    emit(
      state.copyWith(
        province: province,
        district: district,
        ward: ward,
        detail: detail ?? '',
      ),
    );
  }

  void detailChange(String value) {
    emit(state.copyWith(detail: value));
  }

  Future<void> selectAddressItem(AddressItemEntity value) async {
    if (state.province == null) {
      emit(state.copyWith(province: value));
      await getDistrict();
      scrollController.scrollToTop();
      return;
    }
    if (state.district == null) {
      emit(state.copyWith(district: value));
      await getWard();
      scrollController.scrollToTop();
      return;
    }
    emit(state.copyWith(ward: value));
  }

  Future<void> clearDataAddress(AddressUnit value) async {
    switch (value) {
      case AddressUnit.province:
        emit(
          state.copyWith(
            province: null,
            district: null,
            ward: null,
            detail: '',
          ),
        );
        await getProvince();
        scrollController.scrollToTop();
        return;
      case AddressUnit.district:
        emit(
          state.copyWith(
            district: null,
            ward: null,
            detail: '',
          ),
        );
        await getDistrict();
        scrollController.scrollToTop();
        return;
      default:
        emit(
          state.copyWith(
            ward: null,
            detail: '',
          ),
        );
        await getWard();
        scrollController.scrollToTop();
        return;
    }
  }

  Future<void> getProvince() async {
    final input = GetProvinceInput();
    final res = await _getProvinceUseCase.execute(input);
    (res.response.data ?? [])
        .sort((a, b) => a.nameEn![0].compareTo(b.nameEn![0]));
    emit(
      state.copyWith(
        isLoading: false,
        listAddress: res.response.data ?? [],
      ),
    );
  }

  Future<void> getDistrict() async {
    if (state.province?.code == null) {
      return;
    }
    final input = GetDistrictInput(provinceCode: state.province!.code!);
    final res = await _getDistrictUseCase.execute(input);
    (res.response.data ?? [])
        .sort((a, b) => a.nameEn![0].compareTo(b.nameEn![0]));
    emit(
      state.copyWith(
        isLoading: false,
        listAddress: res.response.data ?? [],
      ),
    );
  }

  Future<void> getWard() async {
    if (state.district?.code == null) {
      return;
    }
    final input = GetWardInput(districtCode: state.district!.code!);
    final res = await _getWardUseCase.execute(input);
    (res.response.data ?? [])
        .sort((a, b) => a.nameEn![0].compareTo(b.nameEn![0]));
    emit(
      state.copyWith(
        isLoading: false,
        listAddress: res.response.data ?? [],
      ),
    );
  }
}
