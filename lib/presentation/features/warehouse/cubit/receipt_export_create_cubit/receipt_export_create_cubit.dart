import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/local/get_data.dart';
import '../../../../features_v2/models/employee/user_data_model.dart';
import '../../../../features_v2/models/product/product_v2_model.dart';
import '../../data/models/warehouse_model.dart';
import '../../domain/entities/payload_create_export_receipt_entity.dart';
import '../../domain/entities/shipment_data_entity.dart';
import '../../domain/usecase/create_export_receipt_use_case.dart';
import '../../domain/usecase/list_user_warehouse_use_case.dart';
import '../../domain/usecase/list_warehouse_use_case.dart';
import 'receipt_export_create_state.dart';

@injectable
class ReceiptExportCreateCubit extends Cubit<ReceiptExportCreateState> {
  ReceiptExportCreateCubit(
    this._listUseWareHouseUseCase,
    this._listWareHouseUseCase,
    this._createExportReceiptUsecase,
  ) : super(const ReceiptExportCreateState()) {
    emit(state.copyWith(dateExport: DateTime.now()));
    _getListWareHouse();
    _getListUserWareHouse();
  }

  final ListUseWareHouseUseCase _listUseWareHouseUseCase;
  final GetListWareHouseUseCase _listWareHouseUseCase;
  final CreateExportReceiptUsecase _createExportReceiptUsecase;

  void initData({
    List<ShipmentItemEntity>? shipments,
  }) async {
    if (shipments != null) {
      for (final shipment in shipments) {
        if (shipment.productData == null) continue;
        final list = List<ProductV2Model>.from(state.products);
        list.add(
          shipment.productData!.copyWith(
            shipment: ShipmentDataEntity(
              selected: [shipment],
              data: [shipment],
            ),
            unit: [shipment.productData!.unitStorage!],
            unitData: shipment.productData!.unitStorage,
            unitSell: shipment.productData!.unitStorage,
          ),
        );
        emit(state.copyWith(products: list));
      }
    }
  }

  void stateHandle({
    int? indexTab,
    WarehouseModel? warehouse,
    UserDataModel? userCheck,
    String? codeReceipt,
    DateTime? dateExport,
    String? reasonExport,
  }) {
    emit(
      state.copyWith(
        indexTab: indexTab ?? state.indexTab,
        warehouse: warehouse ?? state.warehouse,
        userCheck: userCheck ?? state.userCheck,
        codeReceipt: codeReceipt ?? state.codeReceipt,
        dateExport: dateExport ?? state.dateExport,
        reasonExport: reasonExport ?? state.reasonExport,
      ),
    );
  }

  void _getListWareHouse() async {
    final input = ListWarehouseInput(
      workspace: getCompanyId,
    );
    final res = await _listWareHouseUseCase.getListV2(input);
    final warehouse = res.firstOrNull;
    emit(state.copyWith(listWareHouse: res, warehouse: warehouse));
  }

  void _getListUserWareHouse() async {
    final res = await _listUseWareHouseUseCase.getListUserWarehouse(
      getCompanyId ?? 0,
    );
    final userCheck = res.firstWhereOrNull(
      (element) => element.id == getAccountId,
    );
    emit(state.copyWith(listUser: res, userCheck: userCheck));
  }

  void addProductHandle({ProductV2Model? product, int? index}) {
    final list = List<ProductV2Model>.from(state.products);
    if (index != null && product != null) {
      list[index] = product;
    } else {
      list.add(product ?? ProductV2Model());
    }
    emit(state.copyWith(products: list));
  }

  void deleteProductHandle(int index) {
    final list = List<ProductV2Model>.from(state.products);
    list.removeAt(index);
    emit(state.copyWith(products: list));
  }

  Future<int?> createExportReceiptHandle() async {
    final payload = PayloadCreateExportReceiptEntity(
      exportReceipt: ExportReceipt(
        code: state.codeReceipt,
        reason: state.reasonExport,
        totalPrice: state.totalPrice.toInt(),
        userCreated: getAccountId,
        warehouse: state.warehouse?.id,
      ),
      exportInfor: state.products.map((e) {
        final shipment =
            e.shipment?.data?.firstWhereOrNull((e) => e.isSelected);
        if (shipment == null) {
          log('--- err in: ${e.toJson()}');
        }
        return ExportInfor(
          shipment: shipment?.id,
          exportNumber: shipment?.selectedQuantity,
          exportUnit: e.unitSell?.id,
          storageUnit: shipment?.storageUnit,
          exportPrice: e.unitSell?.sellPrice?.toInt(),
          totalExportPrice: (shipment?.selectedQuantity ?? 0) *
              (e.unitSell?.sellPrice?.toInt() ?? 0),
          variant: e.id,
        );
      }).toList(),
    );
    final input = CreateExportReceiptInput(payload: payload);
    final res = await _createExportReceiptUsecase.execute(input);
    emit(
      state.copyWith(
        errMessage: res.response.code == 200 ? null : res.response.message,
      ),
    );
    return res.response.data;
  }
}
