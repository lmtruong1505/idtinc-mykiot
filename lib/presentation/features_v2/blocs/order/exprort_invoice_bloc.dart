import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/electric_invoice_repository.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';

@injectable
class ExprortInvoiceBloc extends Cubit<CubitState> {
  ExprortInvoiceBloc(this._electricInvoiceRepo) : super(CubitState());
  final ElectricInvoiceRepository _electricInvoiceRepo;
  List<UserSerialModel>? userSerials;
  UserSerialModel? serialSelected;
  void getListSerial() async {
    final id = getCompanyId ?? 0;
    final res = await _electricInvoiceRepo.getListSerial(id);
    if (res.code == 200) {
      if (res.data?.isNotEmpty == true) {
        userSerials = res.data!
          ..sort((a, b) {
            if (b.defaultFlag == true) {
              return 1;
            }
            return -1;
          });
        serialSelected = userSerials?.firstOrNull;
      }

      emit(state.copyWith(status: BlocStatus.success, msg: null));
    } else {
      emit(
        state.copyWith(status: BlocStatus.failure, msg: res.message),
      );
    }
  }

  void selectInvoice(UserSerialModel? value) {
    serialSelected = value;
  }
}
