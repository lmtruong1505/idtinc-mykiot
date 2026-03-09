part of 'index.dart';

enum PerProductEnum {
  LIST('Xem danh sách sản phẩm', 'PRODUCT-LIST'),
  CREATE('Tạo mới sản phẩm', 'PRODUCT-CREATE'),
  DETAIL('Xem chi tiết', 'PRODUCT-DETAIL'),
  EDIT('Sửa sản phẩm', 'PRODUCT-EDIT'),
  DELETE('Xóa sản phẩm', 'PRODUCT-DELETE'),
  ACTIVE('Khóa, mở khóa sản phẩm', 'PRODUCT-ACTIVE');

  final String title;
  final String code;
  const PerProductEnum(this.title, this.code);
}
