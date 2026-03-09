import '../enum/address_status.dart';
import '../enum/bloc_status.dart';


class CubitState<T> {
  BlocStatus status;
  AddressStatus addressStatus;
  bool isFirst;
  T? data;
  String msg;
  int total;

  CubitState({
    this.status = BlocStatus.initial,
    this.addressStatus = AddressStatus.initial,
    this.total = 0,
    this.data,
    this.isFirst = true,
    this.msg = 'Lỗi. Kết nối tới máy chủ thất bại',
  });

  CubitState<T> copyWith({
    BlocStatus? status,
    T? data,
    String? msg,
    int? total,
    bool? isFirst,
    AddressStatus? addressStatus,
  }) {
    return CubitState(
      status: status ?? this.status,
      data: data ,
      msg: msg ?? this.msg,
      total: total ?? this.total,
      isFirst: isFirst ?? this.isFirst,
      addressStatus: addressStatus ?? this.addressStatus,
    );
  }
}
