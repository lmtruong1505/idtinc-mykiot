import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/register_company/data/mapper/register_company_entity_mapper.dart';
import 'package:pharmago/presentation/features/register_company/domain/entities/register_company_entity.dart';
import 'package:pharmago/presentation/features/register_company/domain/repositories/register_company_repository.dart';

@injectable
class RegisterCompanyUseCase {
  final RegisterCompanyRepository _repository;
  final RegisterCompanyEntityMapper _mapper;
  RegisterCompanyUseCase(this._repository, this._mapper);

  Future<List<RegisterCompanyEntity>> getList(
      int company, String search, int page) async {
    final data = await _repository.getList(company, search, page);
    return (data as List).map((e) => _mapper.mapToPEntity(e)).toList();
  }

  Future<RegisterCompanyEntity> getDetail(int id) async {
    final data = await _repository.getDetail(id);
    return _mapper.mapToPEntity(data);
  }

  Future<BaseResponseModel> create(RegisterCompanyEntity item) async {
    return await _repository.create(_mapper.entityToMap(item));
  }

  Future<BaseResponseModel> update(RegisterCompanyEntity item) async {
    return await _repository.update(item.id!, _mapper.entityToMap(item));
  }

  Future<BaseResponseModel> delete(int id) async {
    return await _repository.delete(id);
  }
}
