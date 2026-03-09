import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/branch/domain/use_case/update_branch_use_case.dart';
import 'package:pharmago/presentation/features/company/cubit/create_company_cubit/create_company_state.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../address/domain/entities/address_entity.dart';
import '../../../address/domain/entities/address_item_entity.dart';
import '../../../company/domain/entities/company_payload_entity.dart';
import '../../../company/domain/usecase/create_company_use_case.dart';
import '../../../employee/employee/domain/entities/employee_entity.dart';
import 'branch_create_state.dart';

@injectable
class BranchCreateBloc extends Cubit<BranchCreateState> {
  BranchCreateBloc(
    this._createCompanyUseCase, this._updateBranchUseCase,
  ) : super(const BranchCreateState());

  final CreateCompanyUseCase _createCompanyUseCase;
  final UpdateBranchUseCase _updateBranchUseCase;

  void formChange({
    TypeCompany? type,
    String? name,
  }) {
    emit(
      state.copyWith(
        type: type ?? state.type,
        name: name ?? state.name,
      ),
    );
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
      detail: detail,
    );
    emit(state.copyWith(address: address));
  }

  void selectStaff(EmployeeEntity? value) {
    emit(state.copyWith(staffSelected: value));
  }

  Future<BaseResponseModel<CompanyEntity>> createCompany() async {
    final companyParent = getCompany;
    final payload = CompanyPayloadEntity(
      cName: state.name,
      type: state.type?.code ,
      aLat: state.address?.lat,
      aLng: state.address?.lng,
      aProvince: state.address?.province?.code,
      aDistrict: state.address?.district?.code,
      aWard: state.address?.ward?.code,
      aTitle: state.address?.title,
      companyParent: companyParent,
      manager: state.staffSelected?.id,
    );
    final input = CreateCompanyInput(
      companyPayloadEntity: payload,
    );
    final res = await _createCompanyUseCase.execute(input);
    return res.response;
  }

  Future<BaseResponseModel> updateCompany(int id) async {
    final payload = CompanyPayloadEntity(
      cName: state.name,
      type: state.type?.code,
      aLat: state.address?.lat,
      aLng: state.address?.lng,
      aProvince: state.address?.province?.code,
      aDistrict: state.address?.district?.code,
      aWard: state.address?.ward?.code,
      aTitle: state.address?.title,
      manager: state.staffSelected?.id,
    );
    final input = UpdateCompanyInput(
      id: id,
      companyPayloadEntity: payload,
    );
    final res = await _updateBranchUseCase.execute(input);
    return res.response;
  }

  init(CompanyEntity? company) {
    emit(
      state.copyWith(
        address: company?.address,
        staffSelected: company?.manager,
        name: company?.name,
        type: company?.type,
      ),
    );
  }
}
