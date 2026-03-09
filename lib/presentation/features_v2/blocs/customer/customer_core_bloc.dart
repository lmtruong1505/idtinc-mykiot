import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/init_state.dart';

class CustomerCoreBloc extends Cubit<CubitState> {
  CustomerCoreBloc() : super(CubitState());

  reload() {
    emit(state.copyWith(status: BlocStatus.reload));
  }
}
