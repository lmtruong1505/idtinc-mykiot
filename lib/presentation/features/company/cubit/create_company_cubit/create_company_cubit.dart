import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/company/domain/usecase/create_company_use_case.dart';
import 'package:pharmago/presentation/features/company/domain/usecase/get_acc_name_bank_use_case.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../../shared/utils/delay_callback.dart';
import '../../../address/domain/entities/address_item_entity.dart';
import '../../../employee/employee/domain/entities/employee_entity.dart';
import '../../../product/domain/entities/basic_entity.dart';
import '../../domain/entities/bank_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/company_payload_entity.dart';
import '../../domain/usecase/list_bank_use_case.dart';
import '../../domain/usecase/list_type_company_use_case.dart';
import 'create_company_state.dart';

@injectable
class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  CreateCompanyCubit(
    this._createCompanyUseCase,
    this._listBankUseCase,
    this._getAccNameBankUseCase,
    this._listTypeCompanyUseCase,
  ) : super(const CreateCompanyState());

  final CreateCompanyUseCase _createCompanyUseCase;
  final ListBankUseCase _listBankUseCase;
  final GetAccNameBankUseCase _getAccNameBankUseCase;
  final ListTypeCompanyUseCase _listTypeCompanyUseCase;

  final DelayCallBack delayCallBack = DelayCallBack(delay: 500.milliseconds);
  bool _isBranch = false;

  void init({CompanyEntity? company, bool isBranch = false}) {
    final timeOpen = (company?.timeStart ?? '').split(':');
    final timeClose = (company?.timeEnd ?? '').split(':');
    _isBranch = isBranch;
    emit(
      state.copyWith(
        phone: company?.phone ?? getPhone ?? '',
        accountNumber: company?.accountNumber,
        nameAccount: company?.accountName,
        description: company?.description ?? '',
        kafa: company?.kafaCode,
        name: company?.name ?? '',
        taxCode: company?.taxCode ?? '',
        timeOpen: timeOpen.length > 1
            ? TimeOfDay(
                hour: int.tryParse(timeOpen.first) ?? 0,
                minute: int.tryParse(timeOpen[1]) ?? 0,
              )
            : null,
        timeClose: timeClose.length > 1
            ? TimeOfDay(
                hour: int.tryParse(timeClose.first) ?? 0,
                minute: int.tryParse(timeClose[1]) ?? 0,
              )
            : null,
        addressEntity: company?.address,
        status: company?.statusCode ?? 'ACTIVE',
        manager: company?.manager,
      ),
    );
    getBanks(id: company?.bankId);
    getType(type: company?.typeCode);
  }

  void updateAddress({
    String? detail,
    AddressItemEntity? district,
    AddressItemEntity? province,
    AddressItemEntity? ward,
  }) {
    final address = AddressEntity(
      province: province,
      district: district,
      ward: ward,
      title: detail,
    );
    emit(state.copyWith(addressEntity: address));
  }

  void changeTime({
    TimeOfDay? open,
    TimeOfDay? close,
  }) {
    emit(
      state.copyWith(
        timeOpen: open,
        timeClose: close,
      ),
    );
  }

  void formChange({
    String? name,
    BasicEntity? type,
    String? taxCode,
    String? phone,
    String? description,
    String? registerNumber,
    String? praticeCetificateNumber,
    String? kafa,
    EmployeeEntity? manager,
  }) {
    emit(
      state.copyWith(
        name: name ?? state.name,
        type: type ?? state.type,
        taxCode: taxCode ?? state.taxCode,
        phone: phone ?? state.phone,
        description: description ?? state.description,
        kafa: kafa ?? state.kafa,
        manager: manager ?? state.manager,
        registerNumber: registerNumber ?? state.registerNumber,
        praticeCetificateNumber:
            praticeCetificateNumber ?? state.praticeCetificateNumber,
      ),
    );
  }

  void changeBank(BankEntity? bank) {
    emit(state.copyWith(bank: bank));
  }

  void changeAccNumber(String? value) {
    emit(
      state.copyWith(
        accountNumber: value ?? state.accountNumber,
        // nameAccount: null,
      ),
    );
    getNameAcc();
  }

  Future<BaseResponseModel<CompanyEntity>> createCompany({int? id}) async {
    final payload = CompanyPayloadEntity(
      cName: state.name,
      cTaxCode: state.taxCode,
      cPhone: state.phone,
      type: _isBranch && !isCAD ? companyType : state.type?.code,
      cDescription: state.description,
      timeOpen: getTimeStr(state.timeOpen),
      timeClose: getTimeStr(state.timeClose),
      aLat: state.addressEntity?.lat,
      aLng: state.addressEntity?.lng,
      aProvince: state.addressEntity?.province?.code,
      aDistrict: state.addressEntity?.district?.code,
      aWard: state.addressEntity?.ward?.code,
      aTitle: state.addressEntity?.title,
      kafa: state.kafa,
      bank: state.nameAccount == null ? null : state.bank?.id,
      accountNumber: state.nameAccount == null ? null : state.accountNumber,
      nameAccount: state.nameAccount,
      companyParent: _isBranch ? getCompanyId : null,
      status: state.status,
      manager: _isBranch ? state.manager?.id : null,
    );
    final input = CreateCompanyInput(
      companyPayloadEntity: payload,
      id: id,
    );
    final res = await _createCompanyUseCase.execute(input);

    return res.response;
  }

  Future<void> getBanks({
    int? id,
  }) async {
    final res = await _listBankUseCase.execute(ListBankInput());
    final banks = res.response.data ?? [];
    final bank = banks
            .where(
              (element) => element.id == id,
            )
            .isEmpty
        ? null
        : banks
            .where(
              (element) => element.id == id,
            )
            .first;

    emit(
      state.copyWith(
        banks: banks,
        bank: bank,
      ),
    );
    if (bank != null) {
      // getNameAcc();
    }
  }

//bỏ lấy tên chủ tài khoản khi nhập STK
  void getNameAcc() {
    if (state.accountNumber != null && state.bank != null) {
      final input = GetAccNameBankInput(
        accountNumber: state.accountNumber!,
        bank: state.bank?.id ?? 0,
      );
      delayCallBack.debounce(() {
        _getAccNameBankUseCase.execute(input).then((value) {
          if (value.response.data != null) {
            emit(state.copyWith(nameAccount: value.response.data));
            return;
          } else {
            emit(state.copyWith(nameAccount: ''));
            return;
          }
        });
      });
    }
  }

  String getTimeStr(TimeOfDay? time) {
    if (time == null) {
      return '';
    }
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> getType({String? type}) async {
    List<BasicEntity> companyTypes = [];
    if (_isBranch) {
      companyTypes = [
        const BasicEntity(code: 'CLINIC', name: 'Phòng khám', id: 1),
        const BasicEntity(code: 'DRUGSTORE', name: 'Nhà thuốc', id: 1),
      ];
    } else {
      final res = await _listTypeCompanyUseCase.execute(ListTypeCompanyInput());
      companyTypes = res.response.data ?? [];
    }
    final companyType = companyTypes
            .where(
              (element) => element.code == type,
            )
            .isEmpty
        ? null
        : companyTypes
            .where(
              (element) => element.code == type,
            )
            .first;
    emit(
      state.copyWith(
        companyTypes: companyTypes,
        type: companyType,
      ),
    );
  }
}
