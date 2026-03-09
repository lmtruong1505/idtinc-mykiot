import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../../data/models/base/response.dart';
import '../../domain/usecase/order_hub_action_use_case.dart';
import 'order_hub_state.dart';

@injectable
class OrderHubCubit extends Cubit<OrderHubState> {
  OrderHubCubit(
    this._orderHubActionUseCase,
  ) : super(const OrderHubState());

  final OrderHubActionUseCase _orderHubActionUseCase;

  void stateChange({
    bool? isCommit,
    int? notiId,
    String? messageErr,
    bool? isLoadingAction,
    bool? isReceive,
  }) {
    emit(
      state.copyWith(
        isCommit: isCommit ?? state.isCommit,
        notiId: notiId ?? state.notiId,
        messageErr: messageErr ?? state.messageErr,
        isLoadingAction: isLoadingAction ?? state.isLoadingAction,
        isReceive: isReceive ?? state.isReceive,
      ),
    );
  }

  Future<BaseResponseModel?> acceptHandle() async {
    if (state.notiId == null) {
      stateChange(messageErr: 'Không lấy được thông tin');
      return null;
    }
    stateChange(isLoadingAction: true);
    final input = OrderHubActionInput(
      accept: true,
      workspace: getCompany!,
      notiId: state.notiId!,
    );
    final res = await _orderHubActionUseCase.execute(input);
    stateChange(isLoadingAction: false, isReceive: true);
    return res.response;
  }
}
