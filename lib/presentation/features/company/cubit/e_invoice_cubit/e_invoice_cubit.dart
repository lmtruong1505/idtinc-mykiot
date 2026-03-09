import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecase/create_viettel_account_use_case.dart';
import '../../domain/usecase/get_viettel_account_use_case.dart';
import '../../domain/usecase/list_invoice_attributes_use_case.dart';
import '../../domain/usecase/setup_invoice_attributes_use_case.dart';
import 'e_invoice_state.dart';

@injectable
class EInvoiceCubit extends Cubit<EInvoiceState> {
  EInvoiceCubit(
    this._createViettelAccountUseCase,
    this._getViettelAccountUseCase,
    this._setupInvoiceAttributesUseCase,
    this._listInvoiceAttributesUseCase,
  ) : super(const EInvoiceState());

  final CreateViettelAccountUseCase _createViettelAccountUseCase;
  final GetViettelAccountUseCase _getViettelAccountUseCase;
  final SetupInvoiceAttributesUseCase _setupInvoiceAttributesUseCase;
  final ListInvoiceAttributesUseCase _listInvoiceAttributesUseCase;

  void getViettelAccountHandle({required int workspaceId}) async {
    final input = GetViettelAccountInput(workspaceId: workspaceId);
    final res = await _getViettelAccountUseCase.execute(input);
    emit(
      state.copyWith(
        username: res.username,
        password: res.password,
      ),
    );
  }

  Future<void> createViettelAccountHandle({
    required String username,
    required String password,
    required int workspaceId,
  }) async {
    final input = CreateViettelAccountInput(
      password: password,
      username: username,
      workspaceId: workspaceId,
    );
    final res = await _createViettelAccountUseCase.execute(input);
    emit(
      state.copyWith(
        errMsg: res.response.message,
        status: res.response.code,
      ),
    );
  }

  Future<void> setupInvoiceAttributesHandle({
    required String name,
    required String pattern,
    required String serial,
    required int workspace,
    required bool defaultFlag,
  }) async {
    final input = SetupInvoiceAttributesUseCaseInput(
      name: name,
      pattern: pattern,
      serial: serial,
      workspace: workspace,
      defaultFlag: defaultFlag,
    );
    final res = await _setupInvoiceAttributesUseCase.execute(input);
    if (res.response.code == 200) {
      emit(
        state.copyWith(
          invoiceAttributes: [
            ...state.invoiceAttributes,
            res.response.data!,
          ],
        ),
      );
    }
  }

  Future<void> listInvoiceAttributesHandle({
    required int workspace,
  }) async {
    final input = ListInvoiceAttributesUseCaseInput(
      workspace: workspace,
    );
    final res = await _listInvoiceAttributesUseCase.execute(input);
    if (res.response.code == 200) {
      emit(
        state.copyWith(
          invoiceAttributes: res.response.data ?? [],
        ),
      );
    }
  }
}
