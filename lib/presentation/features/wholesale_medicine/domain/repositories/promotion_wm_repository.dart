import '../../../../../data/models/base/response.dart';
import '../../data/models/promotion_model.dart';

abstract class PromotionRepository {
  // Future<BaseResponseModel<List<TypeDiscountModel>>> typeDiscount();

  Future<BaseResponseModel<List<PromotionDetailModel>>> getListPromotion({
    required int company,
    int? variantId,
    int? orderValue,
    int? customer,
  });

  Future<BaseResponseModel<PromotionDetailModel>> getDetailPromotion(int id);

  Future<BaseResponseModel<List<PromotionDetailModel>>> getListDetailPromotion({
    int? idVariant,
    String? tag,
    int? orderValue,
  });
}
