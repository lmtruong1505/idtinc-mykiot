import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product_standard/data/mapper/product_standard_entity_mapper.dart';
import 'package:pharmago/presentation/features/product_standard/domain/entities/product_standard_entity.dart';
import 'package:pharmago/presentation/features/product_standard/domain/repositories/product_standard_repository.dart';

@injectable
class ProductStandardUseCase {
  final ProductStandardRepository _repository;
  final ProductStandardEntityMapper _mapper;
  ProductStandardUseCase(this._repository, this._mapper);

  Future<List<ProductStandardEntity>> getList(
      int company, String search, int page) async {
    final data = await _repository.getList(company, search, page);
    return (data as List).map((e) => _mapper.mapToPEntity(e)).toList();
  }

  Future<ProductStandardEntity> getDetail(int id) async {
    final data = await _repository.getDetail(id);
    return _mapper.mapToPEntity(data);
  }

  Future<BaseResponseModel> create(ProductStandardEntity item) async {
    return await _repository.create(_mapper.entityToMap(item));
  }

  Future<BaseResponseModel> update(ProductStandardEntity item) async {
    return await _repository.update(item.id!, _mapper.entityToMap(item));
  }

  Future<BaseResponseModel> delete(int id) async {
    return await _repository.delete(id);
  }
}
