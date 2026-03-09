part of 'index.dart';

enum PerCustomerEnum {
  LIST('Xem danh sách khách hàng', 'CUSTOMER-LIST'),
  CREATE('Thêm mới khách hàng', 'CUSTOMER-CREATE'),
  DETAIL('Xem chi tiết', 'CUSTOMER-DETAIL'),
  EDIT('Sửa thông tin khách hàng', 'CUSTOMER-EDIT'),
  DELETE('Xóa khách hàng', 'CUSTOMER-DELETE');

  final String title;
  final String code;
  const PerCustomerEnum(this.title, this.code);
}
