import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/product_ai_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/fetch_prds_from_ai_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/import_receipt_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_product_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_user_warehouse_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_warehouse_use_case.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../data/models/receipt_import_model.dart';

@injectable
class CreateWarehouseReceiptCubit extends Cubit<CubitState> {
  CreateWarehouseReceiptCubit(
    this._listWareHouseUseCase,
    this._productsWarehouseUseCase,
    this._importRecieptUseCase,
    this._listUseWareHouseUseCase,
    this._fetchPrdsFromAIUseCase,
  ) : super(CubitState());
  final GetListWareHouseUseCase _listWareHouseUseCase;
  final ProductsWarehouseUseCase _productsWarehouseUseCase;
  final ImportRecieptUseCase _importRecieptUseCase;
  final ListUseWareHouseUseCase _listUseWareHouseUseCase;
  final FetchPrdsFromAIUseCase _fetchPrdsFromAIUseCase;
  // final mapper = ProductAiMapper();

  List<ImageAIStatusModel> listImageAI = [];
  List<WarehouseModel> listWareHouse = [];
  List<ReceiptImportDetailModel> listShipment = [];
  List<ReceiptImportDetailModel> listShipmentDelete = [];
  List<UserDataModel> listUser = [];
  bool? hasUpdate;

  final DelayCallBack delay = DelayCallBack(delay: 500.milliseconds);
  int _page = 1;
  List<ProductV3Model> listPrdsAI = [];
  List<XFile> images = [];
  String? code;
  String? reason;
  String? provider;
  WarehouseModel? warehouse;
  UserDataModel? userCheck;
  UnitV3Model? unitSelected;
  num totalPrice = 0;
  String? startDate;
  ReceitExportModel? receiptDetail;

  void init({
    ReceitExportModel? receiptDetail,
    List<ReceiptImportDetailModel>? listReceiptItem,
  }) async {
    if (receiptDetail == null || listReceiptItem == null) return;
    listShipment = [];
    for (final e in listReceiptItem) {
      final products = await _productsWarehouseUseCase.getProductsWarehouse(
        ProductsWarehouseInput(
          company: getCompany,
          page: 1,
          search: e.productData?.productName,
        ),
      );
      var product = products.first;
      // Dùng để đưa unit đã chọn trong shipment lên đầu danh sách units -> phù hợp với UI dùng units.first
      final indexUnitSelected = product.units?.indexWhere((u) => u.id == e.inputUnit) ?? -1;
      final unitsCopy = List<UnitV3Model>.from(product.units ?? []);
      if (indexUnitSelected > 0) {
        final unitMove = unitsCopy.removeAt(indexUnitSelected);
        unitsCopy.insert(0, unitMove);
      }
      totalPrice += (e.totalImportPrice ?? 0);
      product = product.copyWith(
        inputQuantity: e.inputQuantity,
        units: unitsCopy,
        inputPrice: e.importPrice,
        shipmentPrice: e.totalImportPrice,
      );
      listShipment.add(e.copyWith(productData: product));
    }
    receiptDetail = receiptDetail;
    code = receiptDetail.code;
    reason = receiptDetail.reason;
  }

  void getListWareHouse() async {
    final input = ListWarehouseInput(
      workspace: getCompanyId,
    );
    final res = await _listWareHouseUseCase.getListV2(input);
    listWareHouse = res;
    if (receiptDetail?.warehouseId != null) {
      warehouse = listWareHouse.firstWhere(
        (e) => e.id == receiptDetail?.warehouseId,
      );
    } else {
      warehouse = listWareHouse.firstOrNull;
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  void getListUserWareHouse() async {
    final res =
        await _listUseWareHouseUseCase.getListUserWarehouse(getCompanyId ?? 0);
    listUser = res;
    if (receiptDetail?.userCheck != null) {
      // model nó thế  :)))
      userCheck = listUser.firstWhere(
        (e) => e.id == receiptDetail?.userCheck,
      );
    } else {
      userCheck = listUser.firstWhereOrNull(
        (element) => element.id == getAccountId,
      );
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<List<ProductV3Model>> getListWarehouseProduct(
    String search, {
    bool isMore = false,
  }) async {
    emit(CubitState(status: BlocStatus.loading));

    isMore ? _page++ : _page = 1;
    final input = ProductsWarehouseInput(
      page: _page,
      company: getCompany ?? -1,
      search: search,
    );

    final res = await _productsWarehouseUseCase.getProductsWarehouse(input);

    return res;
  }

  void addLot({ProductV3Model? productData, bool isReload = true}) {
    listShipment.add(ReceiptImportDetailModel(productData: productData));
    if (isReload) {
      emit(state.copyWith(status: BlocStatus.reload));
    }
  }

  void addProd(int index, ProductV3Model? prod, {bool isReload = true}) {
    listShipment = listShipment.asMap().entries.map(
      (entry) {
        final i = entry.key;
        var shipment = entry.value;
        if (index == i) {
          shipment = shipment.copyWith(productData: prod);
        }
        return shipment;
      },
    ).toList();
    if (isReload) {
      emit(state.copyWith(status: BlocStatus.reload));
    }
  }

  void updateShipment(
    int index, {
    bool? isShow,
    int? inputQuantity,
    int? inputPrice,
    int? shipmentPrice,
    String? shipmentCode,
    DateTime? startDate,
    DateTime? endDate,
    bool? isDelete,
    UnitV3Model? unit,
    bool isReload = true,
  }) {
    delay.debounce(
      () {
        print(
            '====shipmentPrice==$shipmentPrice====inputPrice==$inputPrice===inputQuantity==$inputQuantity');
        listShipment = listShipment.map(
          (shipment) {
            final indexShipment = listShipment.indexOf(shipment);

            if (index == indexShipment) {
              final data = shipment.productData;
              shipment = shipment.copyWith(
                code: shipmentCode ?? shipment.code,
                startDate: startDate ?? shipment.startDate,
                endDate: endDate ?? shipment.endDate,
                productData: isDelete == true
                    ? null
                    : shipment.productData?.copyWith(
                          inputQuantity: inputQuantity ?? data?.inputQuantity,
                          inputPrice: inputPrice ?? data?.inputPrice,
                          shipmentPrice: shipmentPrice ??
                              ((inputPrice ?? data?.inputPrice ?? 0) *
                                  (inputQuantity ?? data?.inputQuantity ?? 0)),
                          unitSell: unit ?? data?.unitSell,
                        ) ??
                        data,
                isExpand: isShow ?? true,
              );
            }
            return shipment;
          },
        ).toList();
        if (isReload) {
          emit(state.copyWith(status: BlocStatus.reload));
        }
      },
    );
  }

  void updateShipmentV2(
    int index, {
    num? inputQuantity,
    num? inputPrice,
    num? shipmentPrice,
    UnitV3Model? unit,
  }) {
    listShipment = listShipment.map(
      (shipment) {
        final indexShipment = listShipment.indexOf(shipment);
        if (index == indexShipment) {
          final data = shipment.productData;
          shipment = shipment.copyWith(
            productData: shipment.productData?.copyWith(
                  inputQuantity: inputQuantity ?? data?.inputQuantity,
                  inputPrice: inputPrice ?? data?.inputPrice,
                  shipmentPrice: shipmentPrice ??
                      ((inputPrice ?? data?.inputPrice ?? 0) *
                          (inputQuantity ?? data?.inputQuantity ?? 0)),
                  unitSell: unit ?? data?.unitSell,
                ) ??
                data,
          );
        }
        return shipment;
      },
    ).toList();
  }

  void deleteShipment(int index) {
    if (listShipment[index].id != null) {
      listShipmentDelete.add(listShipment[index]);
    }
    listShipment.removeAt(index);
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void createReceipt(BuildContext context) async {
    try {
      hasUpdate = false;
      DialogUtils.showLoadingDialog(context, 'Đang tạo phiếu nhập kho');
      final input = CreateReceiptInput(
        importReceipt: ImportReceiptModel(
          code: code,
          reason: reason,
          warehouse: warehouse?.id,
          totalPrice: totalPrice,
          provider: provider,
          checker: userCheck?.id,
        ),
        shipment: listShipment
            .map(
              (e) => Shipment(
                slot: null,
                code: e.code,
                startDate: e.startDate?.fomatCustom(fomat: 'yyyy-MM-dd'),
                endDate: e.endDate.fomatCustom(fomat: 'yyyy-MM-dd'),
                variant: e.productData?.id,
                storageUnit: e.productData?.unitSell?.id,
                inputUnit: e.productData?.unitSell?.id,
                importPrice: e.productData?.inputPrice,
                totalImportPrice: e.productData?.shipmentPrice,
                inputQuantity: e.productData?.inputQuantity,
                warehouseImport: warehouse?.id,
              ),
            )
            .toList(),
        images: images,
      );

      final res = await _importRecieptUseCase.createReceipt(input);
      context.pop();
      if (res.code == 200) {
        hasUpdate = true;
        listShipment.clear();
        images.clear();
        emit(state.copyWith(status: BlocStatus.submitSuccess));
      } else {
        emit(
          state.copyWith(status: BlocStatus.submitFailure, msg: res.message),
        );
      }
    } catch (e) {
      print(e);
      context.pop();
      emit(state.copyWith(status: BlocStatus.submitFailure, msg: e.toString()));
    }
  }

  void updateReceipt() async {
    
  }

  void addFiles(XFile element) {
    images.add(element);
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void removeFile(int index) {
    images.removeAt(index);
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void getPrdsFromAI(BuildContext context) async {
    try {
      DialogUtils.showLoadingDialog(
        context,
        'Đang xử lý ảnh - vui lòng chờ trong giây lát....? Tốc độ xử lý phụ thuộc vào số lượng ảnh và lưu lượng truy cập hệ thống.',
        title: 'Nhận diện sản phẩm ',
      );
      final input =
          FetchPrdsFromAIInput(workspaceId: getCompanyId ?? 0, imgs: images);
      final output = await _fetchPrdsFromAIUseCase.execute(input);
      if (output.response.code == 200) {
        context.pop();
        if (output.response.data?.isNotEmpty == true) {
          listPrdsAI =
              output.response.data!.map((e) => e.mapperToPrd()).toList();
          if (output.response.extra is List<ImageAIStatusModel>) {
            listImageAI = output.response.extra;
          }
          if (listShipment.length < listPrdsAI.length) {
            for (var i = 0;
                i < (listPrdsAI.length - listShipment.length);
                i++) {
              addLot(isReload: false);
            }
          }
          for (var i = 0; i < listPrdsAI.length; i++) {
            final prd = listPrdsAI[i];
            addProd(i, prd, isReload: false);

            updateShipmentV2(
              i,
              inputQuantity: prd.quantityExtract,
              inputPrice: prd.unitPriceExtract,
              shipmentPrice: prd.totalAmountExtract,
              unit: prd.unitSell,
            );
            print('======updateShipmentV2$i');
          }
        }

        emit(state.copyWith(status: BlocStatus.loadList));
      } else {
        context.pop();
        DialogUtils.showErrorDialog(context, content: 'Đã có lỗi xảy ra');
        emit(state.copyWith(status: BlocStatus.error));
      }
    } catch (e) {
      print('======$e');
      context.pop();
      DialogUtils.showErrorDialog(context, content: e.toString());
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}
