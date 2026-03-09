import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/order/data/models/order_detail_model.dart';
import 'package:pharmago/presentation/features/order/data/models/order_model.dart';

import '../../data/models/order_preview_model.dart';

abstract class OrderRepository {
  Future<BaseResponseModel<int>> createOrder({
    required Map<String, dynamic> order,
    required List<Map<String, dynamic>> orderItem,
    required Map<String, dynamic> orderPayment,
    required List<Map<String, dynamic>> orderPaymentItem,
    required List<Map<String, dynamic>> orderServiceItem,
    required int warehouse,
    String? mbUuid,
  });

  Future<BaseResponseModel<int>> createOrderV2({
    required Map<String, dynamic> order,
    required List<Map<String, dynamic>> items,
  });

  Future<BaseResponseModel<List<OrderPreviewModel>>> getList({
    required int company,
    int? warehouse,
    String? search,
    String? medicalBill,
    String? type,
    int? page,
    int? limit,
    int? customerId,
    String? orderBy,
    DateTime? createdFrom,
    DateTime? createdTo,
    DateTime? updatedFrom,
    DateTime? updatedTo,
  });

  Future<BaseResponseModel<OrderDetailModel>> getDetail({
    required int id,
  });

  Future<BaseResponseModel> updateStatus({
    required int id,
    required String code,
  });

  Future<BaseResponseModel<OrderModel>> scan({required String code});

  Future<BaseResponseModel> paidOrder({
    required int id,
    required Map<String, dynamic> payload,
  });

  Future<BaseResponseModel> sendZalo({required int id});

  Future<BaseResponseModel<int>> orderHubAction({
    required bool accept,
    required int workspace,
    required int notiId,
  });
}
