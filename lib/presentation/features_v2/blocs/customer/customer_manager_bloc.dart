import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/customer_repository.dart';
import 'package:pharmago/presentation/features_v2/models/customer/socket_oa_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../../data/local/get_data.dart';
import '../date_time/param_date.dart';
import '../state/init_state.dart';

class CustomerManagerCubit extends Cubit<CubitState> {
  CustomerManagerCubit() : super(CubitState());

  final _repo = getIt<CustomerRepository>();
  final _delay = DelayCallBack(delay: 500.milliseconds);

  String? _search;
  String get search => _search ?? '';

  set search(String? value) {
    _search = value ?? '';
    _delay.debounce(
      () => getList(),
    );
  }

  bool _isFilter = false;
  bool get isFilter => _isFilter;

  set isFilter(bool value) {
    _isFilter = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  ParamDate _date = ParamDate(dateRange: DateRangeEnum.all);
  ParamDate get date => _date;

  String get titleDate {
    switch (_date.dateRange) {
      case DateRangeEnum.all:
        return 'Tất cả thời gian';
      case DateRangeEnum.option:
        return '${_date.startDate?.fomatCustom()} - ${_date.endDate?.fomatCustom()}';
      default:
        return _date.dateRange.toName;
    }
  }

  set date(ParamDate? value) {
    _date = value ?? ParamDate(dateRange: DateRangeEnum.all);
    emit(state.copyWith(status: BlocStatus.success));
  }

  int _page = 0;
  final List<CustomerModel> list = [];

  getList({bool isMore = false}) async {
    if (isMore) {
      _page++;
    } else {
      _page = 0;
      list.clear();
    }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getList(getCompanyId ?? 0, search, _page);
    list.addAll(res.data ?? []);

    emit(state.copyWith(status: BlocStatus.success));
  }

  updateZaloCustomer(SocketOAModel model) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].zalo?.userId == model.userId) {
        list[i].zalo?.lastMessage?.sendBy = model.sendBy == 'OA' ? 1 : 2;
        list[i].zalo?.lastMessage?.message = model.message;
        list[i].zalo?.lastMessage?.timestamp = model.timestamp;
        list[i].zalo?.lastMessage?.read = model.sendBy == 'OA' ? true : false;
        if (model.attachments.validator.isNotEmpty) {
          list[i].zalo?.lastAttachment = model.attachments?.first.url;
        }
      }
    }
    emit(state.copyWith(status: BlocStatus.success));
  }
}
