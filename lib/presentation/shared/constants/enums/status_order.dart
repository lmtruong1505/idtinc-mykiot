enum StatusOrder {
  all('All', 'Tất cả', 'ALL'),
  pending('1', 'Chờ xác nhận', 'CXN'),
  accept('2', 'Đã xác nhận', 'DXN'),
  deny('3', 'Từ chối', 'TC'),
  complete('4', 'Hoàn thành', 'HT'),
  cancel('5', 'Đã huỷ', 'DH');

  const StatusOrder(this.id, this.title, this.code);

  final String id;
  final String title;
  final String code;
}

enum TypeOrderV2Enum {
  all(title: 'Tất cả', code: ''),
  product(title: 'Sản phẩm', code: 'product'),
  service(title: 'Dịch vụ', code: 'service');

  final String title;
  final String code;
  const TypeOrderV2Enum({required this.title, required this.code});
}

enum StatusOrderV2Enum {
  all(title: 'Tất cả', code: ''),
  pending(title: 'Chờ thanh toán', code: 'pending'),
  notPaidFull(title: 'Chưa thanh toán đủ', code: 'not_paid_full'),
  complete(title: 'Đã thanh toán', code: 'complete'),
  cancel(title: 'Đã hủy', code: 'cancel');

  final String title;
  final String code;
  const StatusOrderV2Enum({required this.title, required this.code});
}
