enum EnumCalendarTime {
  all('Tất cả', ''),
  booked('Đã đặt', 'APPOINTMENT_BOOKED'),
  comfirmed('Đã xác nhận', 'APPOINTMENT_CONFIRMED'),
  arrived('Đã đến', 'APPOINTMENT_ARRIVED'),
  consulting('Đang khám', 'APPOINTMENT_CONSULTING'),
  completed('Đã hoàn thành', 'APPOINTMENT_COMPLETED'),
  canceled('Đã huỷ', 'APPOINTMENT_CANCELED');

  final String title;
  final String code;
  const EnumCalendarTime(this.title, this.code);
}

//     (APPOINTMENT_BOOKED, 'Đã đặt'),
//     (APPOINTMENT_CONFIRMED, 'Đã xác nhận'),
//     (APPOINTMENT_ARRIVED, 'Đã đến'),
//     (APPOINTMENT_CONSULTING, 'Đang khám'),
//     (APPOINTMENT_COMPLETED, 'Đã hoàn thành'),
//     (APPOINTMENT_CANCELED, 'Đã hủy'),