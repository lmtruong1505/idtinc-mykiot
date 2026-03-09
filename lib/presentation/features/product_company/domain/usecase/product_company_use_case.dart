import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product_company/data/mapper/product_company_entity_mapper.dart';
import 'package:pharmago/presentation/features/product_company/domain/entities/product_company_entity.dart';
import 'package:pharmago/presentation/features/product_company/domain/repositories/product_company_repository.dart';

@injectable
class ProductCompanyUseCase {
  final ProductCompanyRepository _repository;
  final ProductCompanyEntityMapper _mapper;
  ProductCompanyUseCase(this._repository, this._mapper);

  Future<List<ProductCompanyEntity>> getList(
      int company, String search, int page) async {
    final data = await _repository.getList(company, search, page);
    return (data as List).map((e) => _mapper.mapToPEntity(e)).toList();
  }

  Future<ProductCompanyEntity> getDetail(int id) async {
    final data = await _repository.getDetail(id);
    return _mapper.mapToPEntity(data);
  }

  Future<BaseResponseModel> create(ProductCompanyEntity item) async {
    return await _repository.create(_mapper.entityToMap(item));
  }

  Future<BaseResponseModel> update(ProductCompanyEntity item) async {
    return await _repository.update(item.id!, _mapper.entityToMap(item));
  }

  Future<BaseResponseModel> delete(int id) async {
    return await _repository.delete(id);
  }
}
