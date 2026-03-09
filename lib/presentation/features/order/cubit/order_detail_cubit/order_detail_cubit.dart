import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/order/domain/usecase/order_paid_use_case.dart';
import 'package:pharmago/presentation/features/order/domain/usecase/order_update_status_use_case.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../domain/entities/payment_v2_entity.dart';
import '../../domain/usecase/order_detail_use_case.dart';
import '../../domain/usecase/send_zalo_use_case.dart';
import 'order_detail_state.dart';

@injectable
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(
    this._orderDetailUseCase,
    this._orderUpdateStatusUseCase,
    this._orderPaidUseCase,
    this._sendZaloUseCase,
  ) : super(const OrderDetailState());

  final OrderDetailUseCase _orderDetailUseCase;
  final OrderUpdateStatusUseCase _orderUpdateStatusUseCase;
  final OrderPaidUseCase _orderPaidUseCase;
  final SendZaloUseCase _sendZaloUseCase;

  Future<void> getDetail(int? id) async {
    if (id == null) return;
    emit(state.copyWith(isLoading: true));
    final input = OrderDetailInput(id: id);
    final res = await _orderDetailUseCase.execute(input);
    emit(state.copyWith(isLoading: false, order: res.response.data));
  }

  Future<BaseResponseModel> updateStatus(String code) async {
    final input = OrderUpdateStatusInput(
      id: state.order?.id ?? 0,
      code: code,
    );
    final res = await _orderUpdateStatusUseCase.execute(input);
    if (res.response.code == 200) {
      getDetail(state.order?.id);
    }
    return res.response;
  }

  Future<BaseResponseModel> payOrder(
      double amount, PaymentMethod method) async {
    final input = OrderPaidInput(
      id: state.order?.id ?? 0,
      payment: PaymentV2Entity(
        amount: amount,
        method: method,
      ),
    );
    final res = await _orderPaidUseCase.execute(input);
    return res.response;
  }

  Future<BaseResponseModel> sendZalo() async {
    final res = await _sendZaloUseCase(state.order?.id ?? 0);
    if(res.code == 200 && res.data == true){
      emit(state.copyWith(hadSendZalo: true));
    }
    return _sendZaloUseCase(state.order?.id ?? 0);
  }

  double get havePaid {
    final hadPay = (state.order?.payments ?? []).fold(0.0,
        (previousValue, element) => previousValue + element.amount.validator);
    return (state.order?.totalPrice.validator ?? 0) - hadPay;
  }
}

enum OrderStatus {
  draft(title: 'Đơn nháp', code: 'DRAFT'),
  inProcess(title: 'Đang tiến hành', code: 'IN_PROCESS'),
  complete(title: 'Hoàn thành', code: 'COMPLETE'),
  cancel(title: 'Đã huỷ', code: 'CANCEL');

  final String title;
  final String code;

  const OrderStatus({
    required this.title,
    required this.code,
  });
}
