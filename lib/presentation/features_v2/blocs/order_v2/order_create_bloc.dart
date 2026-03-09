import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/order_v2/params/order_create_param.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/presentation/features_v2/repositories/order/order_v2_repo.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../data/models/base/response.dart';
import '../../../features/company/data/models/point_exchange_package_model.dart';
import '../../models/customer/v2/customer_model.dart';
import '../../models/customer/v2/customer_point_item_model.dart';
import '../../models/product/product_v2_model.dart';
import '../enum/bloc_status.dart';

class OrderCreateBloc extends Cubit<CubitState> {
  OrderCreateBloc() : super(CubitState());

  final repo = OrderV2Repo();

  CustomerV2Model? _customer;

  CustomerV2Model? get customer => _customer;

  set customer(CustomerV2Model? value) {
    _customer = value;
  }

  List<ProductV2Model>? _productsPointExchange;
  List<ProductV2Model>? get productsPointExchange => _productsPointExchange;
  set productsPointExchange(List<ProductV2Model>? value) {
    _productsPointExchange = value;
  }

  List<PointExchangePackageModel>? _productsFromPackage;
  List<PointExchangePackageModel>? get productsFromPackage =>
      _productsFromPackage;
  set productsFromPackage(List<PointExchangePackageModel>? value) {
    _productsFromPackage = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  CustomerPointItemModel? _moneyExchange;
  CustomerPointItemModel? get moneyExchange => _moneyExchange;
  set moneyExchange(CustomerPointItemModel? value) {
    _moneyExchange = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<ProductV2Model> _products = [];

  List<ProductV2Model> get products => _products;

  set products(List<ProductV2Model> value) {
    _products = value;
  }

  List<File> _prescriptionImages = [];

  List<File> get prescriptionImages => _prescriptionImages;

  set prescriptionImages(List<File> value) {
    _prescriptionImages = value;
  }

  String _prescriptionCode = '';

  String get prescriptionCode => _prescriptionCode;

  set prescriptionCode(String value) {
    _prescriptionCode = value;
  }

  List<ServiceV2Model> _services = [];

  List<ServiceV2Model> get services => _services;

  set services(List<ServiceV2Model> value) {
    _services = value;
  }

  double _price = 0;

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  double _chietKhau = 0;

  double get chietKhau => _chietKhau;

  set chietKhau(double value) {
    _chietKhau = value;
  }

  double get total =>
      _price -
      _chietKhau +
      (red ? totalVat : 0) -
      (moneyExchange?.moneyExchange ?? 0);

  double get totalVat {
    return _totalVatProds + _totalVatServices;
  }

  double get _totalVatProds {
    return products.fold(0, (total, e) {
      total +=
          (e.quantity ?? 0) * (e.vat ?? 0) * (e.unitSell?.realPrice ?? 0) / 100;
      return total;
    });
  }

  double get _totalVatServices {
    return services.fold(0, (total, e) {
      total += e.vatPrice;
      return total;
    });
  }

  bool _red = false;
  bool _zns = false;

  bool get red => _red;

  set red(bool value) {
    _red = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  set zns(bool value) {
    _zns = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  String _note = '';

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  int? _appointment;

  set appointment(int? value) {
    _appointment = value;
  }

  String _type = 'product';

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  Future<BaseResponseModel<int>> create() async {
    final pEPByProduct = productsPointExchange
            ?.map(
              (e) => ProductExchangePointParam(
                product: e.id,
                quantity: e.quantity,
              ),
            )
            .toList() ??
        [];
    final pEPByPackage =
        productsFromPackage?.fold<List<ProductExchangePointParam>>(
              <ProductExchangePointParam>[],
              (list, e) {
                final listSelected =
                    e.items?.where((e) => e.product?.isSelected == true) ?? [];
                if (listSelected.isNotEmpty) {
                  list.addAll(
                    listSelected.map((i) {
                      return ProductExchangePointParam(
                        product: i.product?.id,
                        quantity: i.quantity,
                        package: e,
                      );
                    }),
                  );
                }
                return list;
              },
            ) ??
            [];

    final param = OrderCreateParam(
      order: OrderParam(
        type: type,
        redInvoice: _red,
        totalAmount: total,
        description: _note,
        customer: _customer?.phone,
        customerName: _customer?.fullName ?? 'Khách lẻ',
        customerBirthday: _customer?.birthday ?? 'Khách lẻ',
        customerGender: _customer?.gender ?? 'Khách lẻ',
        company: getCompany ?? -1,
        mbUuid: '',
        moneyExchange: moneyExchange?.moneyExchange?.toDouble() ?? 0,
        pointExchange: moneyExchange?.point?.toInt() ?? 0,
        prescriptionCode: prescriptionCode,
      ),
      appointmentId: _appointment,
      sendZNS: _zns,
      productExchangePoint: pEPByProduct + pEPByPackage,
      items: products
          .map(
            (e) => ItemParam(
              product: e.id,
              quantity: e.quantity,
              price: e.unitSell?.realPrice ?? 0,
              discountPrice: e.chietKhau ?? 0,
              no: 0,
              unit: e.unitSell?.id,
              shipments: e.listShipmentItemByQuantity,
              valueUnitChange: e.valueUnitChange,
            ),
          )
          .toList(),
      services: services
          .map(
            (e) => ServiceItemParam(
              price: (e.priceCustom?.price ?? e.price?.price ?? 0).toDouble(),
              service: e.id,
              discountPrice: e.discount.toDouble(),
              employee: e.employee?.id,
              priceName: e.price?.id,
              quantity: e.quantity,
            ),
          )
          .toList(),
    );
    final res = repo.createProdOrder(
      payload: param.toJson(),
      prescriptionImagePaths: prescriptionImages,
    );
    return res;
    // return BaseResponseModel<int>(
    //   code: 400,
    //   data: 1
    // );
  }

  Future<BaseResponseModel<List<ProductV2Model>>> checkTonKho() async {
    final company = getCompanyId ?? -1;
    final res = await repo.checkTonkho(
      company: company,
      productIds: products.map((e) => e.id ?? -1).toList(),
    );
    final data = (List<ProductV2Model>.from(res.data ?? []));
    bool canOrder = true;
    for (final item in data) {
      final product =
          products.firstWhereOrNull((element) => element.id == item.id);
      if ((product?.quantity.validator ?? 0) > item.availableStock.validator) {
        canOrder = false;
      }
    }
    if (!canOrder) {
      return BaseResponseModel(
        code: 400,
        message: 'Số lượng sản phẩm không đủ',
        data: data,
      );
    }
    return BaseResponseModel(data: []);
  }
}
