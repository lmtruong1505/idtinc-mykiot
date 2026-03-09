import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';

import '../entities/receipt_export_entity.dart';
import '../repositories/warehouse_repository.dart';

@injectable
class ListExportReceiptUseCase {
  final WarehouseRepository _repository;
  ListExportReceiptUseCase(
    this._repository,
  );

  Future<List<ReceiptExportEntity>?> getListExportReceiptUseCase(
    ListExportReceiptUseCaseInput input,
  ) async {
    final res = await _repository.listExportReceipt(
      warehouse: input.warehouse,
      page: input.page,
      limit: input.limit,
      accountPeriod: input.accountPeriod,
      statusCode: input.statusCode,
      search: input.search,
      typeCode: input.typeCode,
    );
    return res.data;
  }
}

class ListExportReceiptUseCaseInput extends BaseInput {
  final int warehouse;
  final int page;
  final int limit;
  final int? accountPeriod;
  final String? statusCode;
  final String? search;
  final String? typeCode;

  ListExportReceiptUseCaseInput({
    required this.warehouse,
    this.page = 0,
    this.limit = 15,
    this.accountPeriod,
    this.statusCode,
    this.search,
    this.typeCode,
  });
}
