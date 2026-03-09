import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';

import '../../../../data/models/base/response.dart';
import '../../../features/product/data/models/basic_model.dart';
import '../../repositories/phieu_kham_v2/phieu_kham_v2_repo.dart';
import '../enum/bloc_status.dart';
import 'param/create_phieu_kham_param.dart';

class CreatePhieuKhamBloc extends Cubit<CubitState> {
  CreatePhieuKhamBloc() : super(CubitState());

  List<BasicModel> _benhs = [];
  List<BasicModel> get benhs => _benhs;

  final repo = PhieuKhamV2Repo();

  set benhs(List<BasicModel> value) {
    _benhs = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void addBenh(BasicModel benh) {
    _benhs.add(benh);
    emit(state.copyWith(status: BlocStatus.success));
  }

  void remove(int index) {
    _benhs.removeAt(index);
    emit(state.copyWith(status: BlocStatus.success));
  }
  void removeById(int id) {
    _benhs.removeWhere((element) => element.id == id);
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel<int>> createPhieu(CreatePhieuKhamParam param) async {
    param.pathologies = _benhs.map((e) => e.id ?? -1).toList();
    final payload = param.toJson();
    print('payload: $payload');
    final res = repo.createPhieuKham(payload: payload);
    return res;
  }


}