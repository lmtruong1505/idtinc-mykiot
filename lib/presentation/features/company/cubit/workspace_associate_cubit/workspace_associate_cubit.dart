import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';

import '../../data/models/associate_model.dart';
import '../../data/repositories/ws_associate_repository_impl.dart';
import 'workspace_associate_state.dart';

@injectable
class WorkspaceAssociateCubit extends Cubit<WorkspaceAssociateState> {
  WorkspaceAssociateCubit(
    this._wsAssociateRepositoryImpl,
  ) : super(const WorkspaceAssociateState());

  final WsAssociateRepositoryImpl _wsAssociateRepositoryImpl;

  Future<AssociateModel?> connectWsAssociate({
    required int workspace,
    required int workspaceAssociate,
    bool? isConnect,
  }) async {
    final res = await _wsAssociateRepositoryImpl.connectWsAssociate(
      workspace: workspace,
      workspaceAssociate: workspaceAssociate,
      isConnect: isConnect ?? true,
    );
    if (res.data != null) {
      final listCopy = List<AssociateModel>.from(state.wsAssociates);
      final index = listCopy
          .indexWhere((e) => e.associateCode == res.data?.associateCode);
      if (index == -1) {
        listCopy.insert(0, res.data!);
      } else {
        listCopy[index] = res.data!;
      }
      emit(state.copyWith(wsAssociates: listCopy));
    }
    return res.data;
  }

  Future<CompanyModel?> findWsByAssociateCode(String code) async {
    final res = await _wsAssociateRepositoryImpl.findWsByAssociateCode(code);
    return res.data;
  }

  Future<void> getListAssociate(
    int workspace, {
    int? page,
    int? limit,
    String? search,
  }) async {
    emit(state.copyWith(isLoading: true));
    final res = await _wsAssociateRepositoryImpl.getListAssociate(
      workspace,
      page: page,
      limit: limit,
      search: search,
    );
    emit(state.copyWith(wsAssociates: res.data ?? [], isLoading: false));
  }
}
