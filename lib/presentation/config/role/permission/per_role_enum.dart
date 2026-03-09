part of 'index.dart';

enum PerRoleEnum {
  LIST('Xem danh sách vai trò', 'ROLE-LIST'),
  CREATE('Tạo mới vai trò', 'ROLE-CREATE'),
  DETAIL('Xem chi tiết', 'ROLE-DETAIL'),
  ASSIGN_EMPLOYEE('Gán vai trò cho nhân viên', 'ROLE-ASSIGN-EMPLOYEE'),
  EDIT('Sửa vai trò', 'ROLE-EDIT'),
  ACTIVE('Khóa/mở khóa vai trò', 'ROLE-ACTIVE'),
  DELETE('Xóa vai trò', 'ROLE-DELETE');

  final String title;
  final String code;
  const PerRoleEnum(this.title, this.code);
}
