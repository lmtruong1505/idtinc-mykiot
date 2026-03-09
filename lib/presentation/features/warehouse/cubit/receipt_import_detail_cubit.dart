import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/receipt_import_detail_use_case.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

@injectable
class ReceiptImportDetailCubit extends Cubit<CubitState> {
  ReceiptImportDetailCubit(this._useCase) : super(CubitState());
  final ReceiptImportDetailUseCase _useCase;

  List<ReceiptImportDetailModel> list = [];
  ReceitExportModel? detail;
  final delay = DelayCallBack(delay: 500.milliseconds);
  int page = 0;
  int? warehouseId;
  int? orderId;
  String? search;

  void getListLot() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final input = ReceiptDetailInput(
      warehouseId: warehouseId,
      id: orderId,
    );
    final res = await _useCase.getListLot(input);
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
    getReceiptInfor();
  }

  void initReceipt(int warehouse, int id) {
    warehouseId = warehouse;
    orderId = id;
  }

  void getReceiptInfor() async {
    final input = ReceiptDetailInput(
      warehouseId: warehouseId,
      id: orderId,
    );
    final res = await _useCase.getReceiptInfor(input);
    if (res.code == 200) {
      detail = res.data;
    }
    emit(state.copyWith(status: BlocStatus.success));
  }
}
