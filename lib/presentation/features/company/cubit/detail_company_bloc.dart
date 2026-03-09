import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/data/mapper/company_mapper.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/company_repository.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';

import '../../../features_v2/blocs/state/cubit_state.dart';

class DetailCompanyBloc extends Cubit<CubitState<CompanyEntity>> {
  DetailCompanyBloc() : super(CubitState<CompanyEntity>());

  final _repo = getIt<CompanyRepository>();
  final _mapper = getIt<CompanyMapper>();

  getDetail(int id) async {
    emit(
      state.copyWith(
        status: BlocStatus.loading,
      ),
    );

    final res = await _repo.getDetail(id: id);

    final company = _mapper.mapToEntity(res.data);

    if (res.code == 200 && res.data?.id != null) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: company,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          data: null,
        ),
      );
    }
  }
}
