part of 'index.dart';

enum PerOrderInputEnum {
  LIST('Xem danh sách đơn nhập hàng', 'ORDER-IN-LIST'),
  CREATE('Tạo mới đơn nhập hàng', 'ORDER-IN-CREATE'),
  EDIT('Sửa đơn nhập hàng', 'ORDER-IN-EDIT'),
  DELETE('Xóa đơn nhập hàng', 'ORDER-IN-DELETE'),
  DETAIL('Xem chi tiết đơn nhập hàng', 'ORDER-IN-DETAIL'),
  DONE('Hoàn thành đơn nhập hàng', 'ORDER-IN-DONE');

  final String title;
  final String code;
  const PerOrderInputEnum(this.title, this.code);
}
