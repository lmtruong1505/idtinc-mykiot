import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/utils/delay_callback.dart';
import '../../../../features_v2/blocs/state/init_state.dart';
import '../../../../shared/utils/get.dart';
import '../../../company/cubit/create_company_cubit/create_company_state.dart';
import '../../../company/domain/enum/enum_data.dart';
import '../../../company/domain/usecase/list_company_use_case.dart';

@Singleton()
class BranchManagementBloc extends Cubit<CubitState> {
  BranchManagementBloc(
    this._listCompanyUseCase,
  ) : super(CubitState());

  final ListCompanyUseCase _listCompanyUseCase;
  final List<CompanyEntity> list = [];
  final delay = DelayCallBack(delay: 500.milliseconds);
  final searchController = TextEditingController();
  int _countDrugstore = 0;
  int get countDrugstore => _countDrugstore;
  int _countClinic = 0;
  int get countClinic => _countClinic;

  init() {
    emit(CubitState());
    _page = 1;
    searchController.clear();
    _status = null;
    _countDrugstore = 0;
    _countClinic = 0;
    if (isCAD) {
      _branchType = TypeCompany.drugstore;
    } else {
      _branchType = null;
    }
    statusCount.extend(listStatus.length, 0);

    getList();
  }

  int _page = 1;

  final List<TypeCompany> branchTypes = [
    TypeCompany.drugstore,
    TypeCompany.clinic,
  ];
  TypeCompany? _branchType;
  TypeCompany? get branchType => _branchType;

  void changeBranchType(TypeCompany value) {
    _branchType = value;
    searchController.clear();
    getList();
  }

  searchList() async {
    getList();
  }

  StatusWorkSpace? _status;
  StatusWorkSpace? get status => _status;

  set status(StatusWorkSpace? value) {
    _status = value == _status ? null : value;
    getList();
  }

  final List<StatusWorkSpace> listStatus = [
    StatusWorkSpace.active,
    StatusWorkSpace.inActive,
  ];
  final List<int> statusCount = [];

  Future<void> getList({
    bool isMore = false,
    bool isAll = false,
    String? search,
  }) async {
    final company = getCompany;
    if (company == null) return;
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));

    final input = ListCompanyInput(
      page: _page,
      limit: 20,
      search: search ?? searchController.text,
      parent: company,
      type: isAll ? null : (_branchType?.code ?? companyType),
      isOwner: null,
      isWorkingPlace: null,
      status: _status,
    );

    final res = await _listCompanyUseCase.execute(input);

    try {
      if (res.response.extra != null) {
        final countType = res.response.extra['count_type'] ?? {};
        final countStatus = res.response.extra['count_status'] ?? {};
        _countDrugstore = countType[branchTypes[0].code].toString().toInt ?? 0;
        _countClinic = countType[branchTypes[1].code].toString().toInt ?? 0;
        for (int i = 0; i < listStatus.length; i++) {
          statusCount[i] =
              countStatus[listStatus[i].code].toString().toInt ?? 0;
        }
      }
    } catch (e) {
      print(e);
    }

    list.addAll(res.response.data ?? []);
    if (list.isEmpty && isMore) {
      _page--;
    }
    final isFirst =
        list.isEmpty && _status?.code == null && searchController.text.isEmpty;

    emit(state.copyWith(status: BlocStatus.success, isFirst: isFirst));
  }
}

enum BranchType {
  clinic('clinic'),
  pharmacy('pharmacy');

  const BranchType(this.code);

  final String code;
}

extension BranchTypeExt on BranchType {
  String get toName {
    switch (this) {
      case BranchType.clinic:
        return 'Phòng khám';
      case BranchType.pharmacy:
        return 'Nhà thuốc';
    }
  }
}
