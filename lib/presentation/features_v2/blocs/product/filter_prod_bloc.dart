import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/product/product_v2_repository.dart';

import '../../../features/product/data/models/basic_model.dart';
import '../enum/bloc_status.dart';

class FilterProdBloc extends Cubit<CubitState> {
  FilterProdBloc() : super(CubitState());

  final repo = ProductV2Repository();

  final List<BasicModel> types = [];
  final List<BasicModel> brands = [];
  final List<BasicModel> categories = [];

  void getFilter() {
    emit(CubitState(status: BlocStatus.loading));
    getTypes();
    getBrands();
    getCategories();
  }

  void getTypes() async {
    try {
      final res = await repo.getBasic(type: ProductBasic.type);
      types.clear();
      types.addAll(res.data ?? []);
      emit(CubitState(status: BlocStatus.success));
    } catch (e) {
      emit(CubitState(status: BlocStatus.failure, msg: e.toString()));
    }
  }

  void getBrands() async {
    try {
      final res = await repo.getBasic(type: ProductBasic.brand);
      brands.clear();
      brands.addAll(res.data ?? []);
      emit(CubitState(status: BlocStatus.success));
    } catch (e) {
      emit(CubitState(status: BlocStatus.failure, msg: e.toString()));
    }
  }

  void getCategories() async {
    try {
      final res = await repo.getBasic(type: ProductBasic.category);
      categories.clear();
      categories.addAll(res.data ?? []);
      emit(CubitState(status: BlocStatus.success));
    } catch (e) {
      emit(CubitState(status: BlocStatus.failure, msg: e.toString()));
    }
  }
}
