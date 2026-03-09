import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../data/models/base/response.dart';
import '../../models/role/role_model.dart';
import '../../repositories/role_v2/role_v2_repository.dart';
import '../enum/bloc_status.dart';
import '../role/param/create_role_param.dart';

class RoleCreateBloc extends Cubit<CubitState> {
  RoleCreateBloc() : super(CubitState());

  final RoleV2Repository repo = RoleV2Repository();

  String? _title;
  String? get title => _title;

  final param = CreateRoleParam();

  void setTitle(String value) {
    _title = value;
    param.title = value;
  }

  int? _position;
  int? get position => _position;
  void setPosition(int value) {
    _position = value;
    param.position = value;
  }

  Future<BaseResponseModel<int>> createRole(List<RoleListModel> values) async {
    emit(state.copyWith(status: BlocStatus.loading));
    param.items = mapItems(values);
    param.company = getCompany;
    final res = await repo.createRole(param.toJson());
    return res;
  }

  Future<BaseResponseModel> updateRole(List<RoleListModel> values, int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    param.items = mapItems(values);
    param.company = null;
    final res = await repo.updateRole(param.toJson(), id);
    return res;
  }

  List<RoleItems> mapItems(List<RoleListModel> values) {
    final List<RoleItems> items = [];
    for (final element in values) {
      items.add(
        RoleItems(
          appCode: element.code,
          checked: element.value ?? false,
        ),
      );
      for (final e in element.subApp ?? []) {
        items.add(
          RoleItems(
            appCode: e.code,
            checked: e.value ?? false,
          ),
        );
      }
    }
    return items;
  }

}