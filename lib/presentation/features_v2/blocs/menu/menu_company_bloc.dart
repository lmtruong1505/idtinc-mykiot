import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';
import '../../../features/company/data/models/company_menu.dart';
import '../state/init_state.dart';

class MenuCompanyBloc extends Cubit<CubitState> {
  MenuCompanyBloc() : super(CubitState());
  final _repo = getIt<CompanyRepository>();
  List<CompanyMenu> list = [];
  getCompanyMenu() async {
    emit(state.copyWith(status: BlocStatus.loading));

    print('getCompanyId: $getCompanyId');
    print('parentId: $parentId');

    final res = await _repo.companyMenu(parentId ?? getCompanyId);

    list = res.data ?? [];
    emit(state.copyWith(status: BlocStatus.success));
  }

  setCompany(CompanyMenu value) async {
    final parent = list.firstWhere(
      (element) => element.id == value.parentId,
      orElse: () => CompanyMenu(),
    );

    await setCompanyData(
      CompanyEntity(
        id: value.id,
        name: value.workspaceName,
        code: value.workspaceCode,
        phone: value.phoneNumber,
        parentId: value.parentId,
        typeCode: value.typeCode,
      ),
      parent: parent.id != null
          ? CompanyEntity(
              id: parent.id,
              name: parent.workspaceName,
              code: parent.workspaceCode,
              phone: parent.phoneNumber,
              parentId: parent.parentId,
              typeCode: parent.typeCode,
            )
          : null,
    );
    emit(state.copyWith(status: BlocStatus.success));
  }
}
