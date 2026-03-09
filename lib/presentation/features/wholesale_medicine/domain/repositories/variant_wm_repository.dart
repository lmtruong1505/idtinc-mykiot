import '../../../../../data/models/base/response.dart';
import '../../data/models/variant_wm_model.dart';
import '../entities/variant_wm_entity.dart';


abstract class VariantWmRepository {
  Future<BaseResponseModel<List<VariantWmModel>>> getList(
    int? page,
    int? limit,
    String? searchKey,
    String? tag,
    bool? status,
    int? customer,
    int? account,
  );

  Future<BaseResponseModel<VariantWmEntity>> getVariantDetail(int id);

  Future<BaseResponseModel<List<VariantWmModel>>> getListPromotion({
    required int page,
    required int limit,
    required String searchKey,
  });
}
