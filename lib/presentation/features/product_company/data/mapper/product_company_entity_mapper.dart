import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product_company/domain/entities/product_company_entity.dart';

@injectable
class ProductCompanyEntityMapper {
  ProductCompanyEntity mapToPEntity(dynamic data) => ProductCompanyEntity(
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

  Map<String, Object> entityToMap(ProductCompanyEntity data) => {
        "company": data.company,
        "code": data.code,
        "name": data.name,
        "country": data.country,
        "address": data.address,
        "description": data.description,
        "type": "PRODUCTION"
      };
}
