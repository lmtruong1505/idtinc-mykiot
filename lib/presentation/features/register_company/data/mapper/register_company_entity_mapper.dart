import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/register_company/domain/entities/register_company_entity.dart';

@injectable
class RegisterCompanyEntityMapper {
  RegisterCompanyEntity mapToPEntity(dynamic data) => RegisterCompanyEntity(
        id: data["id"],
        code: data["code"] ?? "",
        name: data["name"] ?? "",
        country: data["country"] ?? "",
        address: data["address"] ?? "",
        description: data["description"] ?? "",
        number: data["number"] ?? 0,
        userCreatedName: data["user_created_name"] ?? "",
        createdAt: data["created_at"] ?? "",
        userUpdatedName: data["user_updated_name"] ?? "",
        updatedAt: data["updated_at"] ?? "",
      );

  Map<String, Object> entityToMap(RegisterCompanyEntity data) => {
        "company": data.company,
        "code": data.code,
        "name": data.name,
        "country": data.country,
        "address": data.address,
        "description": data.description,
        "type": "REGISTERED"
      };
}
