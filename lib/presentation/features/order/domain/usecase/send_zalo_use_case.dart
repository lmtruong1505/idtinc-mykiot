import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/order/domain/repositories/order_repository.dart';

@injectable
class SendZaloUseCase {
  final OrderRepository _repo;

  SendZaloUseCase(this._repo);

  Future<BaseResponseModel> call(int id) async {
    return _repo.sendZalo(id: id);
  }
}