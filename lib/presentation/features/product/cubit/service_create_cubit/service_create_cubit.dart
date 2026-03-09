import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/service_create_use_case.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/company_pharma_entity.dart';
import '../../domain/usecase/service_update_use_case.dart';
import 'service_create_state.dart';

@injectable
class ServiceCreateCubit extends Cubit<ServiceCreateState> {
  ServiceCreateCubit(
    this._serviceCreateUseCase,
    this._serviceUpdateUseCase,
  ) : super(const ServiceCreateState());

  final ServiceCreateUseCase _serviceCreateUseCase;
  final ServiceUpdateUseCase _serviceUpdateUseCase;

  Future<BaseResponseModel?> createService() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = ServiceCreateInput(
      payload: state.servicePayload.copyWith(
        company: company,
        reminderTime:
            state.servicePayload.reminderTime,
        staff: state.staffSelected?.id,
        brand: state.brandSelected?.id,
        congTyDk: state.congTyDk?.id,
      ),
    );
    final res = await _serviceCreateUseCase.execute(input);
    return res.response;
  }

  void init(ServiceEntity? service) {
    if(service == null){
      return;
    }
    emit(
      state.copyWith(
        servicePayload: state.servicePayload.copyWith(
          code: service.code,
          title: service.title,
          entity: service.entity,
          frequency: service.frequency,
          unit: service.unit,
          price: service.price,
          description: service.description,
          reminderTime: service.reminderTime,
          company: service.company,
          active: service.active,
          message: service.message,
          soDangKy: service.soDangKy,
          soQuyetDinh: service.soQuyetDinh,
          actionTime: service.actionTime,
          chiDinh: service.chiDinh,
          chongChiDinh: service.chongChiDinh,
          congDung: service.congDung,
          tacDungPhu: service.tacDungPhu,
          luuY: service.luuY,
          hinhThuc: service.hinhThuc,
        ),
        staffSelected: service.staff,
        id: service.id,
        isUpdate: true,
      ),
    );
  }

  void infoFormChange({
    String? code,
    String? title,
    String? entity,
    String? frequency,
    String? unit,
    double? price,
    String? description,
    int? company,
    String? soQuyetDinh,
    String? soDangKy,
    int? brand,
    int? type,
    String? actionTime,
    String? chiDinh,
    String? chongChiDinh,
    String? congDung,
    String? tacDungPhu,
    String? luuY,
    String? hinhThuc,
    String? message,
  }) {
    final info = state.servicePayload.copyWith(
      code: code ?? state.servicePayload.code,
      title: title ?? state.servicePayload.title,
      entity: entity ?? state.servicePayload.entity,
      frequency: frequency ?? state.servicePayload.frequency,
      unit: unit ?? state.servicePayload.unit,
      price: price ?? state.servicePayload.price,
      description: description ?? state.servicePayload.description,
      company: company ?? state.servicePayload.company,
      soQuyetDinh: soQuyetDinh ?? state.servicePayload.soQuyetDinh,
      soDangKy: soDangKy ?? state.servicePayload.soDangKy,
      brand: brand ?? state.servicePayload.brand,
      type: type ?? state.servicePayload.type,
      actionTime: actionTime ?? state.servicePayload.actionTime,
      chiDinh: chiDinh ?? state.servicePayload.chiDinh,
      chongChiDinh: chongChiDinh ?? state.servicePayload.chongChiDinh,
      congDung: congDung ?? state.servicePayload.congDung,
      tacDungPhu: tacDungPhu ?? state.servicePayload.tacDungPhu,
      luuY: luuY ?? state.servicePayload.luuY,
      hinhThuc: hinhThuc ?? state.servicePayload.hinhThuc,
      message: message ?? state.servicePayload.message,
    );
    emit(state.copyWith(servicePayload: info));
  }

  void selectBrand(BrandEntity? value) {
    emit(state.copyWith(brandSelected: value));
  }

  void imageServiceChange(List<XFile> images) {
    final files = images.map((e) => File(e.path)).toList();
    final filesByte = images
        .map((e) => base64Encode(File(e.path).readAsBytesSync()))
        .toList();
    final serviceInfo = state.servicePayload.copyWith(image: filesByte);
    emit(
      state.copyWith(
        servicePayload: serviceInfo,
        imageService: files,
      ),
    );
  }

  void removeImageProduct(int index) {
    final list = List<File>.from(state.imageService);
    list.removeAt(index);
    emit(state.copyWith(imageService: list));
  }

  void reminderTimeChange(String? value) {
    final info = state.servicePayload
        .copyWith(reminderTime: value != null ? int.parse(value) : null);
    emit(state.copyWith(servicePayload: info));
  }

  void selectStaff(EmployeeEntity? value) {
    emit(state.copyWith(staffSelected: value));
  }

  void selectMasterData({
    CompanyPharmaEntity? congTyDk,
    CompanyPharmaEntity? congTySx,
  }) {
    emit(
      state.copyWith(
        congTyDk: congTyDk ?? state.congTyDk,
        congTySx: congTySx ?? state.congTySx,
      ),
    );
  }


  Future<BaseResponseModel> updateService() async {
    final input = ServiceUpdateInput(
      id: state.id ?? -1,
      service: state.servicePayload,
    );
    final res = await _serviceUpdateUseCase.execute(input);
    return res.response;
  }

  void changeIsActive(bool value) {
    emit(state.copyWith(servicePayload: state.servicePayload.copyWith(active: value)));
  }
}
