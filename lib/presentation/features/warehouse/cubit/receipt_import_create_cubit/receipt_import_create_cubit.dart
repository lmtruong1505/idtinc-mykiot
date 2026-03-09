import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/local/get_data.dart';
import '../../../../features_v2/models/employee/user_data_model.dart';
import '../../../image_picker/domain/entities/image_receipt_entity.dart';
import '../../data/models/receipt_import_model.dart';
import '../../data/models/warehouse_model.dart';
import '../../domain/entities/payload_create_import_receipt_entity.dart';
import '../../domain/entities/shipment_data_entity.dart';
import '../../domain/usecase/create_import_receipt_use_case.dart';
import '../../domain/usecase/list_user_warehouse_use_case.dart';
import '../../domain/usecase/list_warehouse_use_case.dart';
import '../../domain/usecase/update_import_receipt_use_case.dart';
import 'receipt_import_create_state.dart';

@injectable
class ReceiptImportCreateCubit extends Cubit<ReceiptImportCreateState> {
  ReceiptImportCreateCubit(
    this._listUseWareHouseUseCase,
    this._listWareHouseUseCase,
    this._createImportReceiptUsecase,
    this._updateImportReceiptUsecase,
  ) : super(const ReceiptImportCreateState()) {
    emit(state.copyWith(dateImport: DateTime.now()));
    _getListWareHouse();
    _getListUserWareHouse();
  }

  final ListUseWareHouseUseCase _listUseWareHouseUseCase;
  final GetListWareHouseUseCase _listWareHouseUseCase;
  final CreateImportReceiptUsecase _createImportReceiptUsecase;
  final UpdateImportReceiptUsecase _updateImportReceiptUsecase;

  void _getListWareHouse() async {
    final input = ListWarehouseInput(
      workspace: getCompanyId,
    );
    final res = await _listWareHouseUseCase.getListV2(input);
    WarehouseModel? warehouse = res.firstOrNull;
    if (state.receiptDetail?.warehouseData['id'] != null) {
      warehouse = res.firstWhereOrNull(
        (e) => e.id == state.receiptDetail?.warehouseData['id'],
      );
    }
    emit(state.copyWith(listWareHouse: res, warehouse: warehouse));
  }

  void _getListUserWareHouse() async {
    final res = await _listUseWareHouseUseCase.getListUserWarehouse(
      getCompanyId ?? 0,
    );
    UserDataModel? userCheck = res.firstWhereOrNull(
      (element) => element.id == getAccountId,
    );
    if (state.receiptDetail?.checkerData?.id != null) {
      userCheck = res.firstWhereOrNull(
        (e) => e.id == state.receiptDetail?.checkerData?.id,
      );
    }
    emit(state.copyWith(listUser: res, userCheck: userCheck));
  }

  void initShipments(List<ShipmentItemEntity> shipments) {
    emit(state.copyWith(shipments: shipments));
  }

  void initReceipt(ReceitExportModel receiptDetail) {
    emit(
      state.copyWith(
        receiptDetail: receiptDetail,
        reason: receiptDetail.reason ?? '',
        provider: receiptDetail.provider,
      ),
    );
  }

  void stateHandle({
    int? indexTab,
    WarehouseModel? warehouse,
    UserDataModel? userCheck,
    DateTime? dateImport,
    String? provider,
    String? reason,
  }) {
    emit(
      state.copyWith(
        indexTab: indexTab ?? state.indexTab,
        warehouse: warehouse ?? state.warehouse,
        userCheck: userCheck ?? state.userCheck,
        dateImport: dateImport ?? state.dateImport,
        provider: provider ?? state.provider,
        reason: reason ?? state.reason,
      ),
    );
  }

  void addShipmentHandle() {
    emit(
      state.copyWith(
        shipments: [
          ...state.shipments,
          ShipmentItemEntity(),
        ],
      ),
    );
  }

  void addListShipmentHandle(List<ShipmentItemEntity> shipments) {
    emit(
      state.copyWith(
        shipments: [
          ...state.shipments,
          ...shipments,
        ],
      ),
    );
  }

  void deleteShipmentHandle(int index) {
    final listCopy = List<ShipmentItemEntity>.from(state.shipments);
    if (listCopy[index].id != null) {
      final shipmentDelete = List<int>.from(state.shipmentDelete);
      shipmentDelete.add(listCopy[index].id!);
      emit(state.copyWith(shipmentDelete: shipmentDelete));
    }
    listCopy.removeAt(index);
    emit(state.copyWith(shipments: listCopy));
  }

  void shipmentItemChangeInfoHandle(
    int index,
    ShipmentItemEntity item,
  ) {
    final listCopy = List<ShipmentItemEntity>.from(state.shipments);
    listCopy[index] = item;
    emit(state.copyWith(shipments: listCopy));
  }

  Future<int?> createReceiptHandle({List<ImageReceiptEntity>? file}) async {
    final payload = PayloadCreateImportReceiptEntity(
      data: PayloadCreateImportReceiptDataEntity(
        importReceipt: ImportReceipt(
          checker: state.userCheck?.id,
          provider: state.provider,
          reason: state.reason,
          totalPrice: state.totalPrice.toInt(),
          warehouse: state.warehouse?.id,
        ),
        shipment: state.shipments
            .map(
              (e) => e.copyWith(
                warehouseImportId: state.warehouse?.id,
              ),
            )
            .toList(),
      ),
      file: file,
    );
    final input = CreateImportReceiptInput(payload: payload);
    final res = await _createImportReceiptUsecase.execute(input);
    return res.response.data;
  }

  Future<int?> updateReceiptHandle({List<ImageReceiptEntity>? file}) async {
    if (state.receiptDetail?.id == null) return null;
    final payload = PayloadUpdateImportReceiptEntity(
      data: PayloadUpdateImportReceiptDataEntity(
        importReceipt: ImportReceipt(
          checker: state.userCheck?.id,
          provider: state.provider,
          reason: state.reason,
          totalPrice: state.totalPrice.toInt(),
          warehouse: state.warehouse?.id,
        ),
        shipment: state.shipments
            .map(
              (e) => e.copyWith(warehouseImportId: state.warehouse?.id),
            )
            .toList(),
        shipmentDelete: state.shipmentDelete,
      ),
      id: state.receiptDetail!.id!,
      file: file,
    );
    final input = UpdateImportReceiptInput(payload: payload);
    final res = await _updateImportReceiptUsecase.execute(input);
    return res.response.data;
  }
}
