import 'package:injectable/injectable.dart';

import '../../../../../data/models/base/response.dart';
import '../../../../../domain/usecase/base/io/output.dart';
import '../../../../../domain/usecase/base/use_case.dart';
import '../../data/models/order_wm_count_filter_model.dart';
import '../repositories/order_wm_repository.dart';

@injectable
class OrderCountFilterUseCase extends BaseUseCaseNoInput<OrderCountFilterOutput> {
  
  OrderCountFilterUseCase(this._orderRepository);

  final OrderWmRepository _orderRepository;
  @override
  Future<OrderCountFilterOutput> execute() async {
    final res = await _orderRepository.getCountFilter();
    return OrderCountFilterOutput(response: res);
  }

}

class OrderCountFilterOutput extends BaseOutput {
  final BaseResponseModel<List<OrderCountFilterModel>> response;

  OrderCountFilterOutput({required this.response});
}