
import 'package:flutter_bloc/flutter_bloc.dart';

import '../enum/nav_status.dart';

class NavBloc extends Cubit<NavStatus> {
  NavBloc() : super(NavStatus.home);

  change(NavStatus val) {
    print(val.name);
    emit(val);
  }
}
