import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/company/data/mapper/company_mapper.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

@injectable
class ListCompanyUseCase
    extends BaseFutureUseCase<ListCompanyInput, ListCompanyOutput> {
  ListCompanyUseCase(
    this._companyRepository,
    this._companyMapper,
  );
  final CompanyRepository _companyRepository;
  final CompanyMapper _companyMapper;

  @override
  Future<ListCompanyOutput> buildUseCase(ListCompanyInput input) async {
    final res = await _companyRepository.getCompanies(
      page: input.page,
      limit: input.limit,
      search: input.search,
      parent: input.parent,
      type: input.type,
      revenue: input.revenue?.code,
      status: input.status?.code,
      time: input.time?.code,
      isOwner: input.isOwner,
      isWorkingPlace: input.isWorkingPlace,
      includeCurrentWorkspace: input.includeCurrentWorkspace,
    );
    final dataEntity = _companyMapper.mapToListEntity(res.data);
    final output = ListCompanyOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: res.extra,
      ),
      count: res.extra['total_company'].toString().toInt ?? 0,
      countWorking: res.extra['total_company_working'].toString().toInt ?? 0,
      revenue: res.extra['total'].toString().toDouble ?? 0,
      revenueBefore: res.extra['total_before'].toString().toDouble ?? 0,
    );
    return output;
  }
}

class ListCompanyInput extends BaseInput {
  final int? page;
  final int? limit;
  final String? search;
  final int? parent;
  final String? type;
  final TimeWorkSpace? time;
  final StatusWorkSpace? status;
  final RevenueWorkSpace? revenue;
  //lấy công ty đang sở hữu
  final bool? isOwner;
  //lấy công ty đang làm việc
  final bool? isWorkingPlace;
  final bool? includeCurrentWorkspace;
  ListCompanyInput({
    this.limit,
    this.page,
    this.search,
    this.parent,
    this.type,
    this.revenue,
    this.status,
    this.time,
    this.isOwner = true,
    this.isWorkingPlace = false,
    this.includeCurrentWorkspace,
  });
}

class ListCompanyOutput extends BaseOutput {
  final BaseResponseModel<List<CompanyEntity>> response;
  final int count;
  final int countWorking;
  final double revenue;
  final double revenueBefore;
  ListCompanyOutput({
    required this.response,
    required this.count,
    required this.countWorking,
    required this.revenue,
    required this.revenueBefore,
  });
}
