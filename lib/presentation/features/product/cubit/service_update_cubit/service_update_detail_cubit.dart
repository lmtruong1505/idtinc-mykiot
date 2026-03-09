import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../employee/employee/domain/entities/employee_entity.dart';
import '../../domain/entities/variant_entity.dart';
import '../../domain/usecase/service_detail_use_case.dart';
import 'service_update_detail_state.dart';

@injectable
class ServiceUpdateDetailCubit extends Cubit<ServiceUpdateDetailState> {
  ServiceUpdateDetailCubit(
    this._serviceDetailUseCase,
    ) : super(const ServiceUpdateDetailState());

  final ServiceDetailUseCase _serviceDetailUseCase;

  Future<void> getDetail(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = ServiceDetailInput(id: id);
    final res = await _serviceDetailUseCase.execute(input);
    emit(
      state.copyWith(
        service: res.response.data,
        variants: res.response.data?.variants ?? [],
        isLoading: false,
      ),
    );
  }

  void infoFormChange({
    String? image,
    String? code,
    String? title,
    String? entity,
    String? frequency,
    String? unit,
    double? price,
    String? description,
    int? company,
  }) {
    final info = state.service?.copyWith(
      image: image ?? state.service?.image,
      code: code ?? state.service?.code,
      title: title ?? state.service?.title,
      entity: entity ?? state.service?.entity,
      frequency: frequency ?? state.service?.frequency,
      unit: unit ?? state.service?.unit,
      price: price ?? state.service?.price,
      description: description ?? state.service?.description,
      company: company ?? state.service?.company,
    );
    emit(state.copyWith(service: info));
  }

  void imageServiceChange(XFile image) {
    final file = File(image.path);
    final fileByte = base64Encode(file.readAsBytesSync());
    final serviceInfo = state.service?.copyWith(image: fileByte);
    emit(
      state.copyWith(
        service: serviceInfo,
        imageService: file,
      ),
    );
  }

  void selectStaff(EmployeeEntity? value) {
    emit(
      state.copyWith(
        staffSelected: value,
        service: state.service?.copyWith(staff: value),
      ),
    );
  }

  void selectVariant(List<VariantEntity> value) {
    emit(state.copyWith(variants: value, variantsSearch: value));
  }

  void searchVariant(String value) {
    final list = state.variants.where((e) {
      final code = e.code?.toLowerCase();
      final name = e.name?.toLowerCase();
      final search = value.toLowerCase();
      return (code?.contains(search) ?? false) ||
          (name?.contains(search) ?? false);
    }).toList();

    emit(state.copyWith(variantsSearch: list));
  }

  // Future<BaseResponseModel?> updateService() async {
  //   final input = ServiceUpdateInput(
  //     id: state.service?.id ?? 0,
  //     service: state.service,
  //   );
  //   final res = await _serviceUpdateUseCase.execute(input);
  //   return res.response;
  // }

  void removeVariant(VariantEntity value) {
    final list = List<VariantEntity>.from(state.variants);
    list.removeWhere((e) => e.id == value.id);
    emit(state.copyWith(variants: list));
  }

  void reminderTimeChange(String? value) {
    if (value == null || value.trim().isEmpty) {
      value = '3';
    }
    final info =
        state.service?.copyWith(reminderTime: int.parse(value) * 24 * 60 * 60);
    emit(state.copyWith(service: info));
  }
}
