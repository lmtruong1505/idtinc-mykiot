import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/price_model.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/price_update_use_case.dart';

abstract class PriceRepository {
  Future<BaseResponseModel<List<PriceModel>>> getPriceList({
    required String search,
    required int limit,
    required int page,
    required int? company,
  });

  Future<BaseResponseModel<PriceModel>> updatePrice(PriceUpdateInput input);
}
