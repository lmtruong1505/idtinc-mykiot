import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

class IndexBloc extends Cubit<int> {
  IndexBloc() : super(0);
  DelayCallBack delay = DelayCallBack(delay: 150.milliseconds);
  void change(int val) {
    delay.debounce(() => emit(val));
  }
}
