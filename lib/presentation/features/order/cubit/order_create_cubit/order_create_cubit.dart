import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_item_payload_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_service_item_payload_entity.dart';
import 'package:pharmago/presentation/features/order/widgets/order_create_payment.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/service_list_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/variant_list_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../../../shared/utils/get.dart';
import '../../../customer/domain/usecase/customer_use_case.dart';
import '../../../product/domain/entities/variant_entity.dart';
import '../../domain/entities/order_payment_item_payload_entity.dart';
import '../../domain/usecase/order_create_use_case.dart';
import 'order_create_state.dart';

@injectable
class OrderCreateCubit extends Cubit<OrderCreateState> {
  OrderCreateCubit(
    this._orderCreateUseCase,
    this._customerUseCase,
    this._variantListUseCase,
    this._serviceListUseCase,
  ) : super(const OrderCreateState());

  final OrderCreateUseCase _orderCreateUseCase;
  final CustomerUseCase _customerUseCase;
  final VariantListUseCase _variantListUseCase;
  final ServiceListUseCase _serviceListUseCase;

  Timer? _checkCustomerTimer;
  Timer? _checkVariantTimer;

  void init(OrderType val, {String? mbUuid}) {
    emit(
      state.copyWith(
        typeCreate: val,
        mbUuid: mbUuid,
      ),
    );
  }

  void updateVariantSelected(List<VariantEntity?>? value) {
    if (value == null) return;
    final list = List<VariantEntity>.from(state.variantSelected);
    for (final item in value) {
      if (item == null) continue;
      if (list.map((e) => e.id).contains(item.id)) continue;
      list.add(item);
    }
    emit(state.copyWith(variantSelected: list));
  }

  void updateServiceSelected(List<ServiceEntity?>? value) {
    if (value == null) return;
    final list = List<ServiceEntity>.from(state.serviceSelected);
    for (final item in value) {
      if (item == null) continue;
      if (list.map((e) => e.id).contains(item.id)) continue;
      list.add(item);
    }
    emit(state.copyWith(serviceSelected: list));
    _totalOrderPrice();
  }

  void removeVariant(int id) {
    final variants = List<VariantEntity>.from(state.variantSelected);
    final index = variants.indexWhere((element) => element.id == id);
    if (index != -1) {
      variants.removeAt(index);
    }
    emit(state.copyWith(variantSelected: variants));
    _totalOrderPrice();
  }

  void addVariant(VariantEntity variant) {
    final variants = List<VariantEntity>.from(state.variantSelected);
    final index = variants.indexWhere((element) => element.id == variant.id);
    if (index != -1) {
      variants[index] = variant;
    } else {
      variants.add(variant);
    }
    emit(state.copyWith(variantSelected: variants));
    print('variantSelected: ${state.variantSelected}');
    _totalOrderPrice();
  }

  void addService(ServiceEntity service) {
    final services = List<ServiceEntity>.from(state.serviceSelected);
    final index = services.indexWhere((element) => element.id == service.id);
    if (index != -1) {
      services[index] = service;
    } else {
      services.add(service);
    }
    emit(state.copyWith(serviceSelected: services));
    _totalOrderPrice();
  }

  void removeService(int id) {
    final services = List<ServiceEntity>.from(state.serviceSelected);
    final index = services.indexWhere((element) => element.id == id);
    if (index != -1) {
      services.removeAt(index);
    }
    emit(state.copyWith(serviceSelected: services));
    _totalOrderPrice();
  }

  void variantChange(
    int index, {
    String? amountUnit,
    String? discount,
    double? priceSell,
    UnitEntity? unitSelected,
  }) {
    final list = List<VariantEntity>.from(state.variantSelected);
    final unitSelectedChange = unitSelected ?? list[index].unitSelected;
    final amountUnitChange = amountUnit != null
        ? int.tryParse(amountUnit) ?? 0
        : list[index].amountUnit;
    final amountChange = (unitSelectedChange?.value ?? 0) * amountUnitChange;
    list[index] = list[index].copyWith(
      amount: amountChange,
      amountUnit: amountUnitChange,
      discount: discount != null
          ? double.tryParse(discount) ?? 0
          : list[index].discount,
      priceSell: priceSell ?? list[index].priceSell,
      unitSelected: unitSelectedChange,
    );
    emit(
      state.copyWith(variantSelected: list),
    );
    _totalOrderPrice();
  }

  void serviceChange(
    int index, {
    double? unitPrice,
  }) {
    final list = List<ServiceEntity>.from(state.serviceSelected);
    list[index] = list[index].copyWith(price: unitPrice);
    emit(
      state.copyWith(serviceSelected: list),
    );
    _totalOrderPrice();
  }

  void selectCustomer(CustomerEntity? value) {
    final orderInfo = state.orderInfo.copyWith(
      customer: value?.id,
      customerName: value?.name,
      customerPhone: value?.phone,
    );
    emit(
      state.copyWith(
        customerSelected: value,
        orderInfo: orderInfo,
      ),
    );
  }

  void orderInfoChange({
    double? vat,
    String? discount,
    double? servicePrice,
    String? phone,
    String? name,
  }) {
    final orderInfo = state.orderInfo.copyWith(
      vat: vat ?? state.orderInfo.vat,
      discount: discount ?? state.orderInfo.discount,
      servicePrice: servicePrice ?? state.orderInfo.servicePrice,
      customerPhone: phone ?? state.orderInfo.customerPhone,
      customerName: name ?? state.orderInfo.customerName,
    );
    emit(state.copyWith(orderInfo: orderInfo));
    _totalOrderPrice();
  }

  double get _totalPriceVariant {
    return state.variantSelected.fold<double>(0, (total, e) {
      total += (e.amount * (e.priceSell ?? 0)) * (100 - e.discount) / 100;
      return total;
    });
  }

  double get getTotalPriceVariant => _totalPriceVariant;

  double get _totalPriceService {
    return state.serviceSelected.fold<double>(0, (total, e) {
      total += ((e.price ?? 0) * e.amount);
      return total;
    });
  }

  double get getTotalPriceService => _totalPriceService;

  /// This func will be call when user textfield anything referent to price
  void _totalOrderPrice() {
    final totalPrice = _totalPriceVariant + _totalPriceService;
    double discount = 0;
    if (state.orderInfo.discount?.contains('%') ?? false) {
      final percent = double.tryParse(
            state.orderInfo.discount?.replaceAll('%', '') ?? '',
          ) ??
          0;
      discount = totalPrice * percent / 100;
    } else {
      discount = double.tryParse(state.orderInfo.discount ?? '') ?? 0;
    }
    final mustPaid = (totalPrice * (100 + (state.orderInfo.vat ?? 0)) / 100) +
        (state.orderInfo.servicePrice ?? 0) -
        discount;
    final orderInfo = state.orderInfo.copyWith(
      totalPrice: totalPrice.roundToDouble(),
      mustPaid: mustPaid.roundToDouble(),
    );
    final orderPayment = state.orderPayment.copyWith(
      mustPaid: mustPaid.roundToDouble(),
      needPay: mustPaid.roundToDouble(),
    );
    emit(
      state.copyWith(
        orderInfo: orderInfo,
        orderPayment: orderPayment,
        total: totalPrice.round(),
      ),
    );
  }

  void selectPaymentType(PaymentType value) {
    final list = List<PaymentType>.from(state.paymentTypeSelected);
    final listItem =
        List<OrderPaymentItemPayloadEntity>.from(state.paymentItems);
    if (state.paymentTypeSelected.contains(value)) {
      list.remove(value);
      listItem.removeWhere((e) => e.type == value.code);
    } else {
      list.add(value);
      listItem.add(
        OrderPaymentItemPayloadEntity(
          type: value.code,
          title: value.title,
        ),
      );
    }
    emit(
      state.copyWith(
        paymentTypeSelected: list,
        paymentItems: listItem,
      ),
    );
  }

  void paymentItemFormChange(
    OrderPaymentItemPayloadEntity item, {
    double? value,
    bool? isPaid,
  }) {
    final listItem =
        List<OrderPaymentItemPayloadEntity>.from(state.paymentItems);
    final index = listItem.indexWhere((e) => e.type == item.type);
    listItem[index] = listItem[index].copyWith(
      value: value ?? listItem[index].value,
      isPaid: isPaid != null ? !listItem[index].isPaid : listItem[index].isPaid,
    );
    emit(
      state.copyWith(paymentItems: listItem),
    );
    _paymentFormChange();
  }

  void _paymentFormChange() {
    final double hadPaid = state.paymentItems.fold(0, (total, e) {
      total += e.isPaid ? e.value : 0;
      return total;
    });

    emit(
      state.copyWith(
        orderPayment: state.orderPayment.copyWith(
          hadPaid: hadPaid,
          needPay: state.orderPayment.mustPaid - hadPaid,
        ),
      ),
    );
  }

  Future<void> checkCustomer(String phone) async {
    final company = getCompany;
    if (company == null) return;
    if (_checkCustomerTimer != null) {
      _checkCustomerTimer?.cancel();
    }
    _checkCustomerTimer = Timer(const Duration(milliseconds: 500), () async {
      final res = await _customerUseCase.getList(company, phone, 0);
      // emit(state.copyWith(suggestCustomer: res.data ?? []));

      final customer = (res.data ?? []).firstWhereOrNull(
        (element) => element.phone == phone,
      );
      print('customer: $customer');
      selectCustomer(customer);
    });
  }

  Future<void> checkVariant(String search) async {
    final company = getCompany;
    if (company == null) return;
    if (_checkVariantTimer != null) {
      _checkVariantTimer?.cancel();
    }
    _checkVariantTimer = Timer(const Duration(milliseconds: 500), () async {
      final input = VariantListInput(
        company: company,
        limit: 1000,
        page: 1,
        search: search,
      );
      final res = await _variantListUseCase.execute(input);
      emit(state.copyWith(suggestVariant: res.response.data ?? []));
    });
  }

  Future<void> checkService(String search) async {
    final company = getCompany;
    if (company == null) return;
    final input = ServiceListInput(
      company: company,
      limit: 1000,
      page: 1,
      search: search,
    );
    final res = await _serviceListUseCase.execute(input);
    emit(state.copyWith(suggestService: res.response.data ?? []));
  }

  Future<BaseResponseModel> createOrder() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final orderItems = <OrderItemPayloadEntity>[];
    for (final item in state.variantSelected) {
      orderItems.add(
        OrderItemPayloadEntity(
          variant: item.id,
          value: item.amount,
          priceSell: item.priceSell,
          discount: item.discount,
          totalPrice:
              item.amount * (item.priceSell ?? 0) * (100 - item.discount) / 100,
        ),
      );
    }
    final serviceItem = state.serviceSelected.map((e) {
      return OrderServiceItemPayloadEntity(
        service: e.id,
        discount: e.directDiscount,
        totalPrice: (e.price ?? 0) * e.amount,
        unitPrice: e.price,
        quantity: e.amount,
      );
    }).toList();
    final input = OrderCreateInput(
      orderInfo: state.orderInfo.copyWith(
        company: company,
        type: state.typeCreate.code,
      ),
      orderItems: state.typeCreate == OrderType.product ? orderItems : [],
      orderServiceItem:
          state.typeCreate == OrderType.service ? serviceItem : [],
      orderPayment: state.orderPayment,
      orderPaymentItem: state.paymentItems,
      warehouse: 1,
      mbUuid: state.mbUuid,
    );
    final res = await _orderCreateUseCase.execute(input);
    return res.response;
  }

  void changePhone(String value) {
    emit(state.copyWith(phoneCustomer: value));
  }

  void changeName(String value) {
    emit(state.copyWith(nameCustomer: value));
  }

  void tabChange(Object? value) {
    emit(
      state.copyWith(
        tabSelected: value != null ? int.parse(value.toString()) : 0,
      ),
    );
  }

  void selectedOrderRedChange() {
    emit(state.copyWith(selectedOrderRed: !state.selectedOrderRed));
  }
}
