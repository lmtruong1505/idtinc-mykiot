import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/supplier/data/mapper/supplier_entity_mapper.dart';
import 'package:pharmago/presentation/features/supplier/domain/entities/supplier_entity.dart';
import 'package:pharmago/presentation/features/supplier/domain/repositories/supplier_repository.dart';

@injectable
class SupplierUseCase {
  final SupplierRepository _repository;
  final SupplierEntityMapper _mapper;
  SupplierUseCase(this._repository, this._mapper);

  Future<List<SupplierEntity>> getList(
      int company, String search, int page) async {
    final data = await _repository.getList(company, search, page);
    return (data as List).map((e) => _mapper.mapToSupplierEntity(e)).toList();
  }

  Future<SupplierEntity> getDetail(int id) async {
    final data = await _repository.getDetail(id);
    return _mapper.mapToSupplierEntity(data);
  }

  Future<BaseResponseModel> create(SupplierEntity supplier) async {
    return await _repository.create(_mapper.supplierEntityToMap(supplier));
  }

  Future<BaseResponseModel> update(SupplierEntity supplier) async {
    return await _repository.update(
        supplier.id!, _mapper.supplierEntityToMap(supplier));
  }

  Future<BaseResponseModel> delete(int id) async {
    return await _repository.delete(id);
  }
}
