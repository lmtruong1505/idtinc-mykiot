import 'package:pharmago/shared/ext/init_ext.dart';

import '../../blocs/date_time/param_date.dart';
import '../../blocs/enum/enum_calendar_time.dart';
import '../employee/pre_emp_model.dart';

class FilterEventModel {
  int limit;
  int page;
  int? companyId;
  String? search;
  int? customerId;

  ParamDate? dateRang;
  EnumCalendarTime? status;
  PreEmpModel? doctor;

  FilterEventModel({
    this.limit = 20,
    this.page = 1,
    this.companyId,
    this.search,
    this.customerId,
    this.doctor,
    this.status,
    this.dateRang,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['limit'] = limit;
    map['page'] = page;
    if (companyId != null) map['company'] = companyId;
    if (search != null) map['search'] = search;
    if (customerId != null) map['customer'] = customerId;
    if (doctor != null) map['employee_id'] = doctor?.id;
    if (status != null) map['status'] = status?.code;
    if (dateRang != null) {
      map['time_start'] = dateRang!.startDate
          .fomatCustom(fomat: 'yyyy-MM-dd HH:mm:ss');
      map['time_end'] =
          dateRang!.endDate?.fomatCustom(fomat: 'yyyy-MM-dd HH:mm:ss');
    } else {
      map['time_start'] = DateTime.now().copyWith(hour: 0, minute: 0, second: 0).fomatCustom(fomat: 'yyyy-MM-dd HH:mm:ss');
    }
    return map;
  }
}
