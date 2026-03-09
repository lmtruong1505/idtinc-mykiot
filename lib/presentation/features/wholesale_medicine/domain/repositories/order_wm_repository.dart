import '../../../../../data/models/base/response.dart';
import '../../data/models/order_wm_count_filter_model.dart';
import '../../data/models/order_wm_model.dart';
import '../../data/models/order_wm_payload_model.dart';

abstract class OrderWmRepository {
  Future<BaseResponseModel<int>> createOrder(
    OrderWmPayloadModel payload,
  );

  Future<BaseResponseModel<List<OrderWmDetailModel>>> list({
    int? page,
    int? limit,
    String? search,
    int? status,
  });

  Future<BaseResponseModel<OrderWmDetailModel>> detail({
    required int id,
  });

  Future<BaseResponseModel<List<OrderCountFilterModel>>> getCountFilter();
}
