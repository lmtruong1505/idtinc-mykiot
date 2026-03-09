import 'package:pharmago/presentation/features/product/data/models/service_model.dart';

import '../../../../../data/models/base/response.dart';

abstract class ServiceRepository {
  Future<BaseResponseModel<List<ServiceModel>>> getServices({
    required String search,
    required int limit,
    required int page,
    required int? company,
    bool? active,
  });

  Future<BaseResponseModel<int>> createService({
    required Map<String, dynamic> service,
  });

  Future<BaseResponseModel<ServiceModel>> getDetail({
    required int id,
  });

  Future<BaseResponseModel<int>> updateService({
    required int id,
    required Map<String, dynamic> service,
  });

  Future<BaseResponseModel<int>> deleteService({
    required int id,
  });
}
