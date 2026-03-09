import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/params/prod_create_param.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../../data/models/base/response.dart';
import '../../repositories/product/product_v2_repository.dart';
import '../state/init_state.dart';

class ProdCreateBloc extends Cubit<CubitState> {
  ProdCreateBloc() : super(CubitState());

  final repo = ProductV2Repository();

  List<MapEntry<int, XFile>> _images = [];
  List<MapEntry<int, XFile>> get images => _images;
  List<int> indexRemove = [];
  bool isCloneSuccess = false;
  set images(List<MapEntry<int, XFile>> value) {
    _images = value;
    for (int i = 0; i < value.length; i++) {
      print('images: ${value[i].value.path}');
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel<int>> create(ProdCreateParam param) async {
    param.images = images;
    param.product?.company = getCompany;
    final payload = await param.toJson();
    final res = await repo.create(payload: payload);
    return res;
  }

  Future<BaseResponseModel> update(ProdCreateParam param, int id) async {
    param.images = images;
    param.product?.company = getCompany;
    final payload = await param.toJson();
    param.updateTonKho();
    final res = await repo.update(id: id, payload: payload);
    return res;
  }
}
