part of 'index.dart';


enum PerBranchEnum {
  LIST('Xem danh sách cơ sở', 'BRANCH-LIST'),
  CREATE('Tạo mới cơ sở', 'BRANCH-CREATE'),
  DETAIL('Xem chi tiết', 'BRANCH-DETAIL'),
  EDIT('Sửa cơ sở', 'BRANCH-EDIT'),
  DELETE('Xóa cơ sở', 'BRANCH-DELETE'),
  ACTIVE('Khóa/mở khóa cơ sở', 'BRANCH-ACTIVE'),
  LIST_ORDER('Xem danh sách đơn hàng', 'BRANCH-LIST-ORDER'),
  LIST_APPOINTMENT('Xem danh sách lịch hẹn', 'BRANCH-LIST-APPOINTMENT'),
  LIST_EMPLOYEE('Xem danh sách nhân viên', 'BRANCH-LIST-EMPLOYEE'),
  ADD_EMPLOYEE('Thêm nhân viên vào cơ sở', 'BRANCH-ADD-EMPLOYEE');

  final String title;
  final String code;
  const PerBranchEnum(this.title, this.code);
}
