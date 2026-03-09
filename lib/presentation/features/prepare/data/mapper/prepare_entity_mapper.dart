import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/features/prepare/domain/entities/prepare_entity.dart';

@injectable
class PrepareEntityMapper {
  PrepareEntity mapToPEntity(dynamic data) {
    return PrepareEntity(
        id: data["id"],
        code: data["code"] ?? "",
        name: data["name"] ?? "",
        valueExtra: data["value_extra"] ?? 0,
        description: data["description"] ?? "",
        userCreatedName: data["user_created_name"] ?? "",
        createdAt: Date.formatDateTime(Date.parseDate(data["created_at"])));
  }

  Map<String, Object> entityToMap(PrepareEntity data) => {
        "company": data.company,
        "code": data.code,
        "name": data.name,
        "description": data.description,
      };
}
