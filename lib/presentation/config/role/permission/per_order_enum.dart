part of 'index.dart';

enum PerOrderEnum {
  LIST('Xem danh sách đơn hàng', 'ORDER-LIST'),
  CREATE('Thêm mới đơn hàng', 'ORDER-CREATE'),
  DETAIL('Xem chi tiết', 'ORDER-DETAIL'),
  DELETE('Xóa đơn hàng', 'ORDER-DELETE'),
  CONFIRM_TRANSPORT('Xác nhận giao hàng', 'ORDER-CONFIRM-TRANSPORT'),
  CONFIRM_CHECKOUT('Xác nhận thanh toán', 'ORDER-CONFIRM-CHECKOUT');

  final String title;
  final String code;
  const PerOrderEnum(this.title, this.code);
}
