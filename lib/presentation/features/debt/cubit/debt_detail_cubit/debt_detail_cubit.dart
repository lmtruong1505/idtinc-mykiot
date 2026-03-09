import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_detail_cubit/debt_detail_state.dart';
import 'package:pharmago/presentation/features/debt/domain/usecase/debt_detail_use_case.dart';

import '../../../../../data/models/base/response.dart';
import '../../domain/usecase/debt_repayment_create_use_case.dart';

@injectable
class DebtDetailCubit extends Cubit<DebtDetailState> {
  DebtDetailCubit(this._debtDetailUseCase, this._debtPaymentCreateUseCase)
      : super(const DebtDetailState());

  final DebtDetailUseCase _debtDetailUseCase;
  final DebtRepaymentCreateUseCase _debtPaymentCreateUseCase;

  Future<void> getDetail({required int debtId}) async {
    final input = DebtDetailInput(
      id: debtId,
    );
    final res = await _debtDetailUseCase.execute(input);
    final data = res.response.data;
    emit(
      state.copyWith(
        debtNoteData: data,
        isLoading: false,
      ),
    );
  }

  Future<BaseResponseModel> createRepaymet(String? value) async {
    final input = DebtRepaymentCreateInput(
      money: (double.tryParse(
            (value ?? '').replaceAll('.', ''),
          ) ??
          0),
      debt: state.debtNoteData?.id,
    );
    final res = await _debtPaymentCreateUseCase.execute(input);
    if (res.response.data == 200) {
      getDetail(debtId: state.debtNoteData!.id!);
    }
    return res.response;
  }
}
