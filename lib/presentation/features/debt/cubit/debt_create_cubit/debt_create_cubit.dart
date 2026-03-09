import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_create_cubit/debt_create_state.dart';
import 'package:pharmago/presentation/features/debt/data/models/payload/dept_note_payload.dart';
import 'package:pharmago/presentation/features/debt/domain/usecase/debt_create_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';
import 'package:pharmago/presentation/features/supplier/cubit/supplier_cubit.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_cubit.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

enum DebtNoteType {
  EXPENSE('EXPENSE', 'Khoản chi'),
  REVENUE('REVENUE', 'Khoản thu');

  final String code;
  final String title;

  const DebtNoteType(this.code, this.title);
}

@injectable
class DebtCreateCubit extends Cubit<DebtCreateState> {
  DebtCreateCubit(
    this._customerCubit,
    this._supplierCubit,
    this._debtCreateUseCase,
  ) : super(const DebtCreateState());

  final CustomerCubit _customerCubit;
  final SupplierCubit _supplierCubit;
  final DebtCreateUseCase _debtCreateUseCase;

  Future<void> initial({required DebtNoteType debtType}) async {
    emit(
      state.copyWith(
        debtType: debtType,
      ),
    );
    await checkEntity('');
  }

  void setValueInput({
    String? title,
    String? code,
    String? totalMoney,
    String? paymented,
    String? note,
  }) {
    emit(
      state.copyWith(
        title: title ?? state.title,
        code: code ?? state.code,
        totalMoney: totalMoney ?? state.totalMoney,
        paymented: paymented ?? state.paymented,
        note: note ?? state.note,
      ),
    );
  }

  void setDateInput({
    DateTime? debitDate,
    DateTime? expriseDate,
  }) {
    emit(
      state.copyWith(
        debitDate: debitDate ?? state.debitDate,
        expriseDate: expriseDate ?? state.expriseDate,
      ),
    );
  }

  Future<void> checkEntity(String value) async {
    _customerCubit.changeSearch(value);
    final customer = await _customerCubit.getList(0);
    final customerBasicModel = customer
        .map(
          (e) => BasicEntity(
            code: e.code,
            name: e.name,
          ),
        )
        .toList();

    _supplierCubit.changeSearch(value);
    final supplier = await _supplierCubit.getList(0);
    final supplierBasicModel = supplier
        .map(
          (e) => BasicEntity(
            code: e.code,
            name: e.name,
          ),
        )
        .toList();
    emit(
        state.copyWith(suggestEntity: customerBasicModel + supplierBasicModel));
  }

  Future<void> selectEntity(BasicEntity? value) async {
    emit(state.copyWith(entitySelected: value));
  }

  Future<BaseResponseModel<int>> createDebtNoteReceipt() async {
    try {
      final DebtNotePayload payload = DebtNotePayload(
        company: AppSharedPreference.instance.getValue(PrefKeys.company) as int,
        code: state.code,
        entity: state.entitySelected!.code,
        title: state.title,
        money: state.totalMoney.toString(),
        paymented: state.paymented.toString(),
        note: state.note,
        type: state.debtType!.code,
        exprise: '${state.expriseDate!.toIso8601String()}Z',
        createdAt: '${(state.debitDate ?? DateTime.now()).toIso8601String()}Z',
      );
      final DebtCreateInput input = DebtCreateInput(data: payload);
      final DebtCreateOutput res = await _debtCreateUseCase.execute(input);
      return res.response; 
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }
}
