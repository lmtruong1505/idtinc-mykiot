import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/import_receipt_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/screens/warehourse_list_page_v2.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../../data/local/get_data.dart';
import '../../../di/di.dart';
import '../../company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../data/models/warehouse_model.dart';
import '../domain/usecase/list_warehouse_use_case.dart';

@injectable
class ManagerImportReceiptCubit extends Cubit<CubitState> {
  ManagerImportReceiptCubit(
    this._useCase,
    this._listWareHouseUseCase,
  ) : super(CubitState());
  final ImportRecieptUseCase _useCase;
  final GetListWareHouseUseCase _listWareHouseUseCase;

  bool isLoading = false;
  List<ReceitExportModel> list = [];
  List<WarehouseModel> listWareHouse = [];
  WarehouseModel? warehouseSelected;

  final delay = DelayCallBack(delay: 500.milliseconds);
  int page = 0;
  int? warehouseId;
  int? orderId;
  String? search;
  final tabs = [
    const FilterButtonModel(
      title: 'Tất cả',
    ),
    const FilterButtonModel(
      title: 'Chờ kiểm tra',
      value: 'CXN',
    ),
    const FilterButtonModel(
      title: 'Hoàn thành',
      value: 'HT',
    ),
    const FilterButtonModel(
      title: 'Đã hủy',
      value: 'ĐTC',
    ),
  ];
  FilterButtonModel? selectTab;

  void changeTab(int index) {
    selectTab = tabs[index];
    onRefresh();
  }

  void changeWarehouse(int index) {
    warehouseSelected = listWareHouse[index];
    onRefresh();
  }

  void getListImportReceipt({bool isMore = false}) async {
    if (isMore) {
      page = page + 1;
    } else {
      page = 0;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final input = ImportReceiptInput(
      search: search,
      page: page,
      status: selectTab?.value,
      id: warehouseSelected?.id,
      typeCode: getIt.get<AuthWsManagerCubit>().state.typeCodeWarehouse,
    );
    final res = await _useCase.getList(input);
    if (res.code == 200) {
      list = res.data ?? [];
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  void onSearch(String p0) {
    delay.debounce(
      () {
        search = p0;
        onRefresh();
      },
    );
  }

  void onRefresh() {
    list.clear();
    page = 0;
    getListImportReceipt();
  }

  void initWarehouse(int id) async {
    warehouseId = id;

    if (id == 0) {
      final input = ListWarehouseInput(
        workspace: getCompanyId,
      );
      final res = await _listWareHouseUseCase.getListV2(input);
      final WarehouseModel? warehouse = res.firstOrNull;
      warehouseId = warehouse?.id;
      warehouseSelected = warehouse;
      listWareHouse = res;
      getListImportReceipt();
    }
  }
}
