import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/branch/domain/use_case/detail_branch_use_case.dart';

import 'branch_detail_state.dart';

@injectable
class BranchDetailBloc extends Cubit<BranchDetailState> {
  BranchDetailBloc(this._detailBranchUseCase)
      : super(const BranchDetailState());

  final DetailBranchUseCase _detailBranchUseCase;

  Future<void> init(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = DetailBranchInput(id: id);
    final res = await _detailBranchUseCase.execute(input);
    emit(
      state.copyWith(
        isLoading: false,
        company: res.response.data,
        message: res.response.message ??
            'Lỗi. Không tìm thấy thông tin cơ sở phù hợp',
      ),
    );
  }

  updateCountStaff(int count) {
    emit(
      state.copyWith(
        company: state.company?.copyWith(
          totalEmployeesAll: () => count,
        ),
      ),
    );
  }
}
