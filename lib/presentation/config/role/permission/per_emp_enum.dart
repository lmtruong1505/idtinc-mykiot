part of 'index.dart';

enum PerEmployeeEnum {
  LIST('Xem danh sách nhân viên', 'EMPLOYEE-LIST'),
  ADD('Thêm nhân viên', 'EMPLOYEE-ADD'),
  EDIT('Sửa nhân viên', 'EMPLOYEE-EDIT'),
  TERMINATE('Xóa nhân viên - cho nghỉ việc', 'EMPLOYEE-TERMINATE'),
  DETAIL('Xem chi tiết', 'EMPLOYEE-DETAIL');

  final String title;
  final String code;
  const PerEmployeeEnum(this.title, this.code);
}
