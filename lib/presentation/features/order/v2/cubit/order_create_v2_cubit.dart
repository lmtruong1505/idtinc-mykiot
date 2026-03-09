import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/order/domain/entities/item_order_payload_v2_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/order_payload_v2_entity.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../../data/models/base/response.dart';
import '../../../customer/domain/entities/customer_entity.dart';
import '../../../product/domain/entities/service_entity.dart';
import '../../../product/domain/entities/variant_entity.dart';
import '../../cubit/order_create_cubit/order_create_state.dart';
import '../../domain/usecase/order_create_v2_use_case.dart';
import 'order_create_v2_state.dart';

@injectable
class OrderCreateV2Bloc extends Cubit<OrderCreateV2State> {
  OrderCreateV2Bloc(this._orderCreateV2UseCase)
      : super(const OrderCreateV2State());

  final OrderCreateV2UseCase _orderCreateV2UseCase;

  void init(OrderType val, {String? mbUuid, int? idBranch}) {
    emit(state.copyWith(typeCreate: val, mUuid: mbUuid, idBranch: idBranch));
  }

  void selectCustomer(CustomerEntity? value) {
    emit(
      state.copyWith(
        customerSelected: value,
      ),
    );
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
    _totalOrderPrice();
  }

  void updateVariant(VariantEntity variant) {
    final variants = List<VariantEntity>.from(state.variantSelected);
    final index = variants.indexWhere((element) => element.id == variant.id);
    if (index != -1) {
      variants[index] = variant;
    }
    emit(state.copyWith(variantSelected: variants));
    _totalOrderPrice();
  }

  int findIdxVariant(int id) {
    final variants = List<VariantEntity>.from(state.variantSelected);
    final index = variants.indexWhere((element) => element.id == id);
    return index;
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

  void updateService(ServiceEntity service) {
    final services = List<ServiceEntity>.from(state.serviceSelected);
    final index = services.indexWhere((element) => element.id == service.id);
    if (index != -1) {
      services[index] = service;
    }
    emit(state.copyWith(serviceSelected: services));
    _totalOrderPrice();
  }

  void selectedOrderRedChange() {
    emit(state.copyWith(selectedOrderRed: !state.selectedOrderRed));
  }

  void noteChange(String value) {
    emit(state.copyWith(note: value));
  }

  void _totalOrderPrice() {
    var total = 0.0;
    switch (state.typeCreate) {
      case OrderType.product:
        total = state.variantSelected.fold(
          total,
          (previousValue, element) =>
              previousValue + ((element.unit?.sellPrice.validator ?? 0)- element.discount.validator) * element.amount,
        );
      case OrderType.service:
        total = state.serviceSelected.fold(
          total,
          (previousValue, element) =>
              previousValue +
              (element.price.validator - element.directDiscount.validator) *
                  element.amount,
        );
      default:
        0;
    }
    emit(
      state.copyWith(
        total: total,
      ),
    );
  }

  Future<BaseResponseModel> createOrder() async {
    final company = getCompany;
    final items = <ItemOrderPayloadV2Entity>[];
    switch (state.typeCreate) {
      case OrderType.product:
        items.addAll(
          state.variantSelected.map((e) {
            return ItemOrderPayloadV2Entity(
              id: e.id,
              quantity: e.amount,
              unitPrice: e.priceSell,
              discount: e.discount,
              unit: e.unit?.id,
              level: e.unit?.level,
            );
          }),
        );
        break;
      case OrderType.service:
        items.addAll(
          state.serviceSelected.map((e) {
            return ItemOrderPayloadV2Entity(
              id: e.id,
              quantity: e.amount,
              unitPrice: e.price,
              discount: e.directDiscount,
            );
          }),
        );
        break;
      default:
        break;
    }
    final order = OrderPayloadV2Entity(
      customer: state.customerSelected?.id ?? 0,
      company: state.idBranch ?? company,
      description: state.note,
      red: state.selectedOrderRed,
      type: state.typeCreate.code.toLowerCase(),
      vat: 0,
      mbUuid: state.mUuid,
    );
    final input = OrderCreateV2Input(
      order: order,
      items: items,
    );
    final res = await _orderCreateV2UseCase.execute(input);
    return res.response;
  }
}
