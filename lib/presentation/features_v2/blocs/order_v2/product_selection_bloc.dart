import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_shipment_by_product_use_case.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/product/product_v2_repository.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../data/models/base/response.dart';
import '../../../di/di.dart';
import '../../../features/company/data/models/associate_model.dart';
import '../../../features/warehouse/domain/entities/shipment_data_entity.dart';
import '../../../features/warehouse/domain/usecase/scan_shipment_detail.dart';
import '../../models/product/product_v2_model.dart';
import '../enum/bloc_status.dart';

@injectable
class ProductSelectionBloc extends Cubit<CubitState> {
  ProductSelectionBloc() : super(CubitState());

  int _page = 1;

  int get page => _page;
  final _listShipmentByProductUseCase =
      getIt.get<ListShipmentByProductUseCase>();
  final _scanShipmentDetail = getIt.get<ScanShipmentDetailUseCase>();
  final _repo = ProductV2Repository();

  double _price = 0;

  double get price => _price;

  double _chietKhau = 0;

  double get chietKhau => _chietKhau;

  double get total => _price - _chietKhau;

  List<ProductV2Model> _list = [];

  List<ProductV2Model> get list => _list;

  AssociateModel? _wsAssociate;

  set wsAssociate(AssociateModel? value) {
    _wsAssociate = value;
  }

  bool _valid = false;
  bool get valid => _valid;

  set list(List<ProductV2Model> value) {
    _list = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void scanShipmentDetail(String code) async {
    final shipment = await _scanShipmentDetail.getScanShipmentDetail(
      ScanShipmentDetailInput(code: code),
    );
    if (shipment == null) return;
    final index = getIndexOfProduct(shipment.product?.id);
    if (index == -1) {
      final productsRes = await _repo.products(
        company: getCompany ?? -1,
        page: 1,
        search: shipment.product?.productName,
      );
      if (productsRes.data?.isEmpty ?? true) return;
      final product = productsRes.data!.first;
      addProduct(product.copyWith(quantity: 1), shipment: shipment);
    } else {
      var product = _list[index];
      final indexShipment =
          product.shipment!.data!.indexWhere((e) => e.id == shipment.id);
      final listCopy =
          List<ShipmentItemEntity>.from(product.shipment?.data ?? []);
      listCopy[indexShipment] = listCopy[indexShipment].copyWith(
        selectedQuantity: listCopy[indexShipment].selectedQuantity + 1,
      );
      product.shipment = product.shipment?.copyWith(data: listCopy);
      product = product.copyWith(quantity: (product.quantity ?? 0) + 1);
      addProduct(product);
    }
  }

  Future<void> addProduct(
    ProductV2Model product, {
    ShipmentItemEntity? shipment,
  }) async {
    final index = getIndexOfProduct(product.id);
    if (index != -1) {
      _list[index] = product;
    } else {
      var shipmentData =
          await _listShipmentByProductUseCase.getListShipmentByProduct(
        ListShipmentByProductInput(
          productId: product.id!,
          workspace: getCompany as int,
        ),
      );
      if (shipment != null && (shipmentData?.data?.isNotEmpty ?? false)) {
        final index = shipmentData!.data!.indexWhere((e) {
          return e.id == shipment.id;
        });
        final listCopy = List<ShipmentItemEntity>.from(shipmentData.data ?? []);
        listCopy[index] = listCopy[index].copyWith(selectedQuantity: 1);
        shipmentData = shipmentData.copyWith(data: listCopy);
      }
      _list.add(
        product.copyWith(
          shipment: shipmentData,
        ),
      );
    }
    calcPrice();
  }

  void removeProduct(int? index) {
    if (index != -1) {
      _list.removeAt(index!);
    }
    calcPrice();
  }

  void clearList() {
    _list.clear();
    calcPrice();
  }

  void updateList(List<ProductV2Model> list) {
    for (final item in list) {
      final index = getIndexOfProduct(item.id);
      if (index != -1) {
        _list[index].availableStock = item.availableStock;
        _list[index].stockQuantity = item.stockQuantity;
      }
    }
    checkValid();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void checkValid() {
    for (final item in _list) {
      if (item.quantity.validator > item.availableStock.validator ||
          !(item.active ?? false)) {
        _valid = false;
        emit(state.copyWith(status: BlocStatus.success));
        return;
      }
    }
    _valid = true && _list.isNotEmpty;
  }

  void calcPrice() {
    _price = _list.fold(
      0.0,
      (previousValue, element) =>
          previousValue +
          (element.unitSell?.realPrice ?? 0) * (element.quantity ?? 0),
    );

    _chietKhau = _list.fold(
      0.0,
      (previousValue, element) =>
          previousValue + (element.chietKhau ?? 0) * (element.quantity ?? 0),
    );
    checkValid();
    emit(state.copyWith(status: BlocStatus.success));
  }

  int getIndexOfProduct(int? id) {
    return _list.indexWhere((element) => element.id == id);
  }

  Future<List<ProductV2Model>> getList(
    String? search, {
    bool isMore = false,
    bool exchangeable = false,
  }) async {
    emit(CubitState(status: BlocStatus.loading));
    if (!isMore) {
      _page = 1;
    } else {
      _page++;
    }
    final res = await _repo.products(
      company: _wsAssociate?.workspaceAssociate?.id ?? (getCompany ?? -1),
      page: page,
      search: search,
      exchangeable: exchangeable,
    );
    if (res.data != null && res.data!.isEmpty) _page--;

    return res.data ?? [];
  }

  Future<List<ProductV2Model>> getListKafa(
    String? search, {
    bool isMore = false,
  }) async {
    emit(CubitState(status: BlocStatus.loading));
    if (!isMore) {
      _page = 1;
    } else {
      _page++;
    }
    final res = await _repo.productsKafa(
      company: getCompany ?? -1,
      page: page,
      search: search,
    );
    if (res.data != null && res.data!.isEmpty) _page--;

    return res.data ?? [];
  }

  Future<ProductV2Model?> checkProd(String code) async {
    final company = getCompany ?? -1;
    final res = await _repo.products(
      company: company,
      search: code,
      page: 1,
      limit: 1000,
    );
    return res.data?.firstOrNull;
  }

  Future<BaseResponseModel<List<ProductV2Model>>> getDonThuoc(
      String code) async {
    final res = await _repo.getDonThuoc(code);
    return res;
  }
}
