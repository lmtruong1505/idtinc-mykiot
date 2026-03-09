import 'package:bloc/bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_chose_extra.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../data/models/base/response.dart';
import '../../../../shared/utils/delay_callback.dart';
import '../../../features/product/data/models/basic_model.dart';
import '../../repositories/product/extra_repo.dart';
import '../enum/bloc_status.dart';

class ExtraCreateBloc extends Cubit<CubitState> {
  ExtraCreateBloc(this.type) : super(CubitState());

  final DelayCallBack delay = DelayCallBack(delay: 500.milliseconds);

  final ExtraType type;
  final repo = ExtraRepo();

  String? _search;
  String? get search => _search;
  set search(String? value) {
    _search = value;
    delay.debounce(() => getList(),);
  }

  final List<BasicModel> _list = [];
  List<BasicModel> get list => _list;

  void getList() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await repo.getList(id: getCompanyId ?? -1, type: type, search: search);
    _list.clear();
    _list.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> create(String name) async {
    if(type == ExtraType.brands) {
      final payload = {
        'workspace': getCompanyId,
        'name': name,

      };
      final res = await repo.create(type: type, payload: payload);
      return res;
    }
    if(type == ExtraType.categories) {
      final payload = {
        'workspace': getCompanyId,
        'type': 'PRODUCT',
        'name': name,

      };
      final res = await repo.create(type: type, payload: payload);
      return res;
    }
    if(type == ExtraType.types) {
      final payload = {
        'workspace': getCompanyId,
        'name': name,

      };
      final res = await repo.create(type: type, payload: payload);
      return res;
    }
    if(type == ExtraType.pharma) {
      final payload = {
        'name': name,

      };
      final res = await repo.create(type: type, payload: payload);
      return res;
    }
    return BaseResponseModel(code: 500, message: 'Không hỗ trợ loại này');
  }

}