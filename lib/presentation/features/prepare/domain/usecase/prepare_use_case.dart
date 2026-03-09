import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/prepare/data/mapper/prepare_entity_mapper.dart';
import 'package:pharmago/presentation/features/prepare/domain/entities/prepare_entity.dart';
import 'package:pharmago/presentation/features/prepare/domain/repositories/prepare_repository.dart';

@injectable
class PrepareUseCase {
  final PrepareRepository _repository;
  final PrepareEntityMapper _mapper;
  PrepareUseCase(this._repository, this._mapper);

  Future<List<PrepareEntity>> getList(
      int company, String search, int page) async {
    final data = await _repository.getList(company, search, page);
    return (data as List).map((e) => _mapper.mapToPEntity(e)).toList();
  }

  Future<PrepareEntity> getDetail(int id) async {
    final data = await _repository.getDetail(id);
    return _mapper.mapToPEntity(data);
  }

  Future<BaseResponseModel> create(PrepareEntity item) async {
    return await _repository.create(_mapper.entityToMap(item));
  }

  Future<BaseResponseModel> update(PrepareEntity item) async {
    return await _repository.update(item.id!, _mapper.entityToMap(item));
  }

  Future<BaseResponseModel> delete(int id) async {
    return await _repository.delete(id);
  }
}
