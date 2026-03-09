import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/ticket_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/variant_warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';

import '../../data/models/warehouse_model.dart';

abstract class TicketRepository {
  Future<BaseResponseModel<BasicModel>> create(WarehouseCreateInput input);

  Future<BaseResponseModel<List<VariantWarehouseModel>>> getVariantList(
    VariantListInput input,
  );

  Future<BaseResponseModel<List<WarehouseModel>>> getList(WarehouseInput input);

  Future<BaseResponseModel<List<TicketModel>>> getListTicket({
    required int company,
    int? page,
    int? limit,
    String? search,
  });

  Future<BaseResponseModel> updateTicketStatus(int id, String status);

  Future<dynamic> getTicket(int id);

  Future<BaseResponseModel<List<WarehouseModel>>> getWareHouseDetail(
      InventoryInputV2 input);
}
