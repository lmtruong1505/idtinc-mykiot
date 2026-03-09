import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/utils/delay_callback.dart';
import '../../../../data/local/get_data.dart';
import '../../../features/company/domain/usecase/list_company_use_case.dart';
import '../enum/bloc_status.dart';
import '../state/cubit_state.dart';

@Singleton()
class SelectBranchBloc extends Cubit<CubitState> {
  SelectBranchBloc(
    this._listCompanyUseCase,
  ) : super(CubitState());

  final ListCompanyUseCase _listCompanyUseCase;
  final List<CompanyEntity> list = [];
  final delay = DelayCallBack(delay: 500.milliseconds);
  final searchController = TextEditingController();
  bool isFirst = true;

  int _page = 1;

  searchList() async {
    delay.debounce(() {
      getList();
    });
  }

  Future<void> getList({
    bool isMore = false,
    bool isAll = false,
    String? search,
  }) async {
    final company = getCompanyId;
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
      type: null,
      isOwner: null,
      isWorkingPlace: null,
      status: null,
      includeCurrentWorkspace: true,
    );

    final res = await _listCompanyUseCase.execute(input);
    list.addAll(res.response.data ?? []);
    if (list.isNotEmpty) {
      isFirst = false;
    }

    emit(state.copyWith(status: BlocStatus.success, isFirst: false));
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
