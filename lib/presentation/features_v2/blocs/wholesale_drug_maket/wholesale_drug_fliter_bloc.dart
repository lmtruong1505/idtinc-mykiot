import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';

import '../../../di/di.dart';
import '../../repositories/wholesale_drug/wholesale_drug_repo.dart';
import '../enum/bloc_status.dart';
import '../state/cubit_state.dart';

@injectable
class WholesaleDrugFilterBloc extends Cubit<CubitState> {
  WholesaleDrugFilterBloc(this.repo) : super(CubitState());

  final WholesaleDrugRepo repo;

  final List<BasicModel> groups = [];
  final List<BasicModel> brands = [];
  final List<BasicModel> categories = [];

  void getDrugFilter() async {
    final res = await repo.getDrugFilter();
    if (res.code == 200) {
      groups.addAll(res.data?.group ?? []);
      brands.addAll(res.data?.brand ?? []);
      categories.addAll(res.data?.category ?? []);
    }

    emit(state.copyWith(status: BlocStatus.success));
  }
}
