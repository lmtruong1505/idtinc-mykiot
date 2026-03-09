import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/product_ai_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/ticket_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/variant_warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model_v2.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/receipt_export_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/fetch_prds_from_ai_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/import_receipt_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_product_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/list_warehouse_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/receipt_import_detail_use_case.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';
import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';

import '../../../product/data/models/product_model.dart';
import '../../data/models/warehouse_model.dart';
import '../entities/payload_create_export_receipt_entity.dart';
import '../entities/payload_create_import_receipt_entity.dart';
import '../entities/shipment_data_entity.dart';

abstract class WarehouseRepository {
  Future<BaseResponseModel<int>> create(Map<String, dynamic> payload);

  Future<BaseResponseModel<WarehouseModel>> detail({required int id});

  Future<BaseResponseModel<int>> update({
    required int id,
    required Map<String, dynamic> payload,
  });

  Future<BaseResponseModel<List<VariantWarehouseModel>>> getVariantList(
    VariantListInput input,
  );

  Future<BaseResponseModel<List<ProductModel>>> getProductWarehouse(
    int idWarehouse,
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
  Future<BaseResponseModel<List<WarehouseModel>>> getListWareHouse(
    ListWarehouseInput input,
  );
  Future<BaseResponseModel<List<InventoryModelV2>>> getListInventory(
    InventoryInputV2 input,
  );

  Future<BaseResponseModel<List<ReceitExportModel>>> getListImportReceipt(
    ImportReceiptInput input,
  );

  Future<BaseResponseModel<List<ReceiptImportDetailModel>>> getListLot(
    ReceiptDetailInput input,
  );

  Future<BaseResponseModel<ReceitExportModel>> getReceiptInfor(
    ReceiptDetailInput input,
  );

  Future<BaseResponseModel<List<ProductV3Model>>> getProductsWarehouse(
    ProductsWarehouseInput input,
  );

  Future<BaseResponseModel> createReceipt(CreateReceiptInput input);

  Future<BaseResponseModel<List<UserDataModel>>> getListUserWarehouse(
    int workspace,
  );
  Future<BaseResponseModel<List<ProductAIModel>>> getProductsFromAI(
    FetchPrdsFromAIInput input,
  );

  Future<BaseResponseModel<ShipmentDataEntity>> getListShipmentByProduct({
    required int workspace,
    required int productId,
  });

  Future<BaseResponseModel<List<ShipmentItemEntity>>> getListShipment({
    required int workspace,
    required int offset,
    required int limit,
    String? search,
  });

  Future<BaseResponseModel<ShipmentItemEntity>> scanShipmentDetail({
    required String code,
  });

  Future<BaseResponseModel<int>> createExportReceipt(
    PayloadCreateExportReceiptEntity payload,
  );

  Future<BaseResponseModel<int>> createImportReceipt(
    PayloadCreateImportReceiptEntity payload,
  );

  Future<BaseResponseModel<int>> updateImportReceipt(
    PayloadUpdateImportReceiptEntity payload,
  );

  Future<BaseResponseModel<List<ReceiptExportEntity>>> listExportReceipt({
    required int warehouse,
    required int page,
    required int limit,
    int? accountPeriod,
    String? statusCode,
    String? search,
    String? typeCode,
  });

  Future<BaseResponseModel<ReceiptExportEntity>> detailExportReceipt({
    required int id,
  });

  Future<BaseResponseModel<List<ReceiptItemEntity>>> listShipmentExportReceipt({
    required int id,
  });
}
