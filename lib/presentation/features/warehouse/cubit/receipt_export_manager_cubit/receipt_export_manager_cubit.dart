import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';

import '../../../../../data/local/get_data.dart';
import '../../../../di/di.dart';
import '../../../company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../../domain/usecase/list_export_receipt_use_case.dart';
import '../../domain/usecase/list_warehouse_use_case.dart';
import '../../domain/usecase/receipt_export_detail_use_case.dart';
import 'receipt_export_manager_state.dart';

@injectable
class ReceiptExportManagerCubit extends Cubit<ReceiptExportManagerState> {
  ReceiptExportManagerCubit(
    this._listWareHouseUseCase,
    this._listExportReceiptUseCase,
    this._receiptExportDetailUseCase,
  ) : super(const ReceiptExportManagerState()) {
    _getListWareHouse();
  }

  final GetListWareHouseUseCase _listWareHouseUseCase;
  final ListExportReceiptUseCase _listExportReceiptUseCase;
  final ReceiptExportDetailUseCase _receiptExportDetailUseCase;

  void _getListWareHouse() async {
    final input = ListWarehouseInput(
      workspace: getCompanyId,
    );
    final res = await _listWareHouseUseCase.getListV2(input);
    final warehouse = res.firstOrNull;
    emit(
      state.copyWith(
        listWareHouse: res,
        warehouse: warehouse,
        isLoadingListWareHouse: false,
      ),
    );
    _getListReceiptExport();
  }

  void warehouseSelectHandle(int index) {
    emit(state.copyWith(warehouse: state.listWareHouse[index]));
    refreshList();
  }

  void _getListReceiptExport() async {
    if (state.warehouse?.id == null) return;
    final res = await _listExportReceiptUseCase.getListExportReceiptUseCase(
      ListExportReceiptUseCaseInput(
        warehouse: state.warehouse!.id!,
        search: state.search,
        page: state.page,
        limit: state.limit,
        typeCode: getIt.get<AuthWsManagerCubit>().state.typeCodeWarehouse,
      ),
    );
    emit(
      state.copyWith(
        receipts: state.receipts + (res ?? []),
        page: state.page + 1,
        canLoadMore: (res ?? []).length < state.limit,
        isLoadMore: false,
      ),
    );
  }

  void refreshList() {
    emit(
      state.copyWith(
        receipts: [],
        page: 0,
        canLoadMore: true,
        isLoadMore: true,
      ),
    );
    _getListReceiptExport();
  }

  void getDetailReceipt(int id) async {
    final res = await _receiptExportDetailUseCase.getReceiptInfor(
      ReceiptExportDetailInput(
        id: id,
      ),
    );
    emit(state.copyWith(receipt: res.data));
    getReceiptItems(id);
  }

  void getReceiptItems(int id) async {
    final res = await _receiptExportDetailUseCase.getListLot(
      ReceiptExportDetailInput(
        id: id,
      ),
    );
    emit(state.copyWith(receiptItems: res.data ?? []));
  }
}
