part of 'index.dart';

enum PerServiceEnum {
  LIST('Xem danh sách dịch vụ', 'SERVICE-LIST'),
  CREATE('Tạo mới dịch vụ', 'SERVICE-CREATE'),
  DETAIL('Xem chi tiết dịch vụ', 'SERVICE-DETAIL'),
  EDIT('Sửa thông tin dịch vụ', 'SERVICE-EDIT'),
  DELETE('Xóa dịch vụ', 'SERVICE-DELETE'),
  ACTIVE('Khóa, mở khóa dịch vụ', 'SERVICE-ACTIVE');

  final String title;
  final String code;
  const PerServiceEnum(this.title, this.code);
}
