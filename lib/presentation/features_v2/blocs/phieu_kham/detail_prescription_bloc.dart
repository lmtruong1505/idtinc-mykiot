import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/prescription/prescription_model.dart';

import '../../repositories/phieu_kham/phieu_kham_repository.dart';
import '../state/init_state.dart';

class DetailPrescriptionBloc extends Cubit<CubitState> {
  DetailPrescriptionBloc() : super(CubitState());

  final _repo = PhieuKhamRepository();

  PrescriptionModel? model;

  getDetail(String uuid) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.detailPrescription(uuid: uuid);
    model = res.data;
    emit(state.copyWith(status: BlocStatus.success));
  }
}
