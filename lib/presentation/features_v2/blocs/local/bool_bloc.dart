import 'package:flutter_bloc/flutter_bloc.dart';

class BoolBloc extends Cubit<bool> {
  BoolBloc() : super(true);

  change(bool val) {
    emit(val);
  }
}
