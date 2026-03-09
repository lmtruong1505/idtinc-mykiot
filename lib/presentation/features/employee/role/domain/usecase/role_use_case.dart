import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/employee/role/data/mapper/role_entity_mapper.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/role_entity.dart';
import 'package:pharmago/presentation/features/employee/role/domain/repositories/role_repository.dart';

@injectable
class RoleUseCase {
  final RoleRepository _repository;
  final RoleEntityMapper _mapper;

  RoleUseCase(this._repository, this._mapper);

  Future<List<RoleEntity>> getList(int company, String search, int page) async {
    final data = await _repository.getList(company, search, page);
    return (data as List).map((e) => _mapper.mapToRoleEntity(e)).toList();
  }

  Future<RoleEntity> getDetail(int? id) async {
    if (id != null) {
      final data = await _repository.getDetail(id);
      return _mapper.mapToRoleEntityDetail(data);
    }
    final data = await _repository.getMasterList();
    return RoleEntity(items: _mapper.mapToItemEntity(data));
  }

  Future<BaseResponseModel> create(
    RoleEntity role,
    List<String> optionSelected,
  ) async {
    return _repository.create(_mapper.roleEntityToMap(role, optionSelected));
  }

  Future<BaseResponseModel> update(
    RoleEntity role,
    List<String> optionSelected,
  ) async {
    return _repository.update(
      role.id!,
      _mapper.roleEntityToMap(role, optionSelected),
    );
  }

  Future<BaseResponseModel> delete(int id) async {
    return _repository.delete(id);
  }

  Future<BaseResponseModel> updateCheckBox(
    RoleEntity role,
    List<Map<String, bool>> itemChange,
  ) async {
    return _repository.update(
      role.id!,
      _mapper.rolesEntityToMap(role, itemChange),
    );
  }
}
