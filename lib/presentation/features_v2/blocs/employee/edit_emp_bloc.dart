import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/employee/emp_repository.dart';

import '../../../../data/models/base/response.dart';
import '../../models/employee/emp_model.dart';

class EditEmpBloc extends Cubit<CubitState> {
  EditEmpBloc() : super(CubitState());

  final repo = EmpRepository();

  Future<BaseResponseModel> update(EmpModel model, List<int> ids) async {
    final payload = {
      'working': model.workingData
          ?.map(
            (e) => {
              'workspace': e.company?.id ?? -1,
              'roles': e.roleData.map((e) => e.id).toList(),
              'id': e.id,
              'user_id': e.userId,
            },
          )
          .toList(),
      'ids': ids,
    };
    // print('payload: $payload');
    // return BaseResponseModel();
    final res = await repo.updateWorkingData(
      idUser: model.userData?.id ?? -1,
      payload: payload,
    );
    return res;
  }
}
