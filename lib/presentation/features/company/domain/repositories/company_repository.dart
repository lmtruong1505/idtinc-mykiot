import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';

import '../../data/models/company_menu.dart';
import '../../data/models/point_exchange_package_model.dart';
import '../../data/models/point_exchange_package_payload_model.dart';
import '../entities/setting_point_entity.dart';

abstract class CompanyRepository {
  Future<BaseResponseModel<CompanyModel>> createCompany(
    Map<String, dynamic> payload,
    int? id,
  );

  Future<BaseResponseModel<List<CompanyMenu>>> companyMenu(
    int? id,
  );

  Future<BaseResponseModel<List<CompanyModel>>> getCompanies({
    int? page,
    int? limit,
    String? search,
    int? parent,
    String? type,
    String? time,
    String? revenue,
    String? status,
    bool? isOwner = true,
    bool? isWorkingPlace = false,
    bool? includeCurrentWorkspace,
  });

  Future<BaseResponseModel<CompanyModel>> getDetail({required int id});

  Future<BaseResponseModel> assignStaff({
    required int company,
    required List<int> assign,
    required List<int> remove,
  });

  Future<BaseResponseModel> updateCompany({
    required int id,
    required Map<String, dynamic> payload,
  });

  Future<BaseResponseModel<List<BasicModel>>> getCompanyType();

  Future<BaseResponseModel<bool>> remove(int id);
  Future<BaseResponseModel<bool>> setActive(int id, bool value);
  Future<BaseResponseModel<bool>> setInWork(int id, bool value);

  Future<BaseResponseModel<SettingPointEntity>> settingPoint({
    required int idCompany,
    required Map<String, dynamic> payload,
  });

  Future<BaseResponseModel<PointExchangePackageModel>> createPointExchangePackage(
    PointExchangePackagePayload payload,
  );

  Future<BaseResponseModel<List<PointExchangePackageModel>>> listPointExchangePackage({
    required int ws,
    bool? status,
    String? search,
    int? page,
    int? pageSize,
  });
}
