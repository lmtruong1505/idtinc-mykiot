import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/pb/service.pb.dart';
import 'package:pharmago/presentation/features/order/domain/usecase/order_scan_use_case.dart';

import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/typography.dart';
import '../../../../services/variant_scan_service.dart';
import '../../../product/data/mapper/variant_pb_mapper.dart';
import '../../../product/domain/entities/variant_entity.dart';
import '../../widgets/scan_view.dart';
import 'order_scan_state.dart';

@injectable
class OrderScanCubit extends Cubit<OrderScanState> {
  OrderScanCubit(
    this._variantScanService,
    this._variantPbMapper,
    this._orderScanUseCase,
  ) : super(const OrderScanState());

  final VariantScanService _variantScanService;
  final VariantPbMapper _variantPbMapper;
  final OrderScanUseCase _orderScanUseCase;

  final StreamController<VariantScanRequest> _streamController =
      StreamController<VariantScanRequest>();

  void init(List<VariantEntity> value) {
    emit(state.copyWith(variants: value));
  }

  void viewChange(TypeScanView? value) {
    emit(state.copyWith(view: value ?? TypeScanView.qr));
  }

  void startListeningCodeRequset(BuildContext context) {
    final token = AppSharedPreference.instance.getValue(PrefKeys.token);
    final stream = _variantScanService.client.scanVariant(
      _streamController.stream,
      options: CallOptions(
        metadata: {'authorization': 'bearer $token'},
      ),
    );
    stream.listen((value) {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (value.code == 200) {
        final list = List<VariantEntity>.from(state.variants);
        final dataEntity = _variantPbMapper.mapToEntity(value.details);
        if (list.map((e) => e.id).toList().contains(dataEntity.id)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: mainColor,
              content: Text(
                'Sản phẩm ${value.details.name} thêm số lượng +1',
                style: p5.copyWith(color: whiteColor),
              ),
            ),
          );
          final index = list.indexWhere((e) => e.id == dataEntity.id);
          list[index] = list[index].copyWith(amount: list[index].amount + 1);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: mainColor,
              content: Text(
                'Thêm sản phẩm ${value.details.name} vào danh sách',
                style: p5.copyWith(color: whiteColor),
              ),
            ),
          );
          list.add(dataEntity);
        }
        emit(state.copyWith(variants: list));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: yellow_1,
            content: Text(
              'Mã sản phẩm không tồn tại',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );
      }
    });
  }

  void addBarcode(String code) {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return;
    final request = VariantScanRequest()
      ..company = company
      ..code = code;
    _streamController.sink.add(request);
  }

  void dispose() {
    _streamController.close();
  }

  Future<void> scanOrder(String code) async {
    final input = OrderScanInput(code: code);
    final res = await _orderScanUseCase.execute(input);
    final list = res.response.data?.items
        ?.map(
          (e) => VariantEntity(
            id: e.variant?.id,
            code: e.variant?.code,
            name: e.variant?.name,
            barcode: e.variant?.barcode,
            media: e.variant?.media,
            amountUnit: e.value,
            priceSell: e.variant?.priceSell,
            quantityInStock: e.variant?.quantityInStock ?? 0,
            units: e.variant?.units,
            unitSelected: e.variant?.units?[0],
          ),
        )
        .toList();
    final variants = state.variants + (list ?? []); 
    emit(state.copyWith(variants: variants));
  }
}
