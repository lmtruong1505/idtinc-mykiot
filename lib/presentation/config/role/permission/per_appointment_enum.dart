part of 'index.dart';

enum PerAppointmentEnum {
  LIST('Xem danh sách lịch hẹn', 'APPOINTMENT-LIST'),
  DELETE('Xóa lịch hẹn', 'APPOINTMENT-DELETE'),
  CREATE('Thêm mới lịch hẹn', 'APPOINTMENT-CREATE'),
  DETAIL('Xem chi tiết lịch hẹn', 'APPOINTMENT-DETAIL'),
  EDIT('Sửa thông tin lịch hẹn', 'APPOINTMENT-EDIT'),
  CANCEL('Hủy lịch hẹn', 'APPOINTMENT-CANCEL');

  final String title;
  final String code;
  const PerAppointmentEnum(this.title, this.code);
}


