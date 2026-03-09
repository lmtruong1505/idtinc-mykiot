import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/item_entity.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/role_entity.dart';

@injectable
class RoleEntityMapper {
  RoleEntity mapToRoleEntity(dynamic data) => RoleEntity(
        id: data['id'],
        code: data['code'] ?? '',
        title: data['title'] ?? '',
        note: data['note'] ?? '',
        userCreatedName: data['user_created_name'] ?? '',
        userUpdatedName: data['user_updated_name'] ?? '',
        createdAt: Date.formatDateTime(Date.parseDate(data['created_at'])),
        updatedAt: Date.formatDateTime(Date.parseDate(data['updated_at'])),
      );

  List<ItemEntity> mapToItemEntity(dynamic data) {
    final List<ItemEntity> items = [];
    for (final it in data) {
      items.add(
        ItemEntity(
          title: it['title'] ?? '',
          code: it['code'] ?? '',
          checked: it['value'] ?? false,
          items: mapToItemEntity(it['sub_app'] ?? []),
        ),
      );
    }
    return items;
  }

  RoleEntity mapToRoleEntityDetail(dynamic data) {
    final role = data['role'];
    return RoleEntity(
      id: role['id'],
      code: role['code'] ?? '',
      title: role['title'] ?? '',
      note: role['note'] ?? '',
      userCreatedName: role['user_created_name'] ?? '',
      userUpdatedName: role['user_updated_name'] ?? '',
      createdAt: Date.formatDateTime(Date.parseDate(role['created_at'])),
      updatedAt: Date.formatDateTime(Date.parseDate(role['updated_at'])),
      items: mapToItemEntity(data['items'] ?? []),
    );
  }

  Map<String, Object> roleEntityToMap(
    RoleEntity role,
    List<String> optionSelected,
  ) {
    final items = [];
    for (final oop in role.items) {
      //items.add({'appCode': oop.code, 'checked': oop.checked});
      for (final sub in oop.items) {
        items.add({'appCode': sub.code, 'checked': sub.checked});
      }
    }
    final param = {
      'code': role.code,
      'title': role.title,
      'note': role.note,
      'company': role.company,
      'items': items,
    };

    return param;
  }

  Map<String, Object> rolesEntityToMap(
    RoleEntity role,
    List<Map<String, bool>> itemChange,
  ) {
    return {
      'code': role.code,
      'title': role.title,
      'note': role.note,
      'company': role.company,
      'items': itemChange
          .map(
            (e) => {
              'appCode': e.keys.first,
              'checked': e.values.first,
            },
          )
          .toList(),
    };
  }
}
