import 'package:flutter/material.dart';

import '../../../../shared/style_app/init_style.dart';

enum TypeCustomer {
  customer('Khách hàng'),
  group('Nhóm khách hàng');

  final String name;
  const TypeCustomer(this.name);
}

enum StatusCustomer {
  all(
    'Tất cả',
  ),
  active(
    'Đang hoạt động',
  ),
  inactive(
    'Vô hiệu hóa',
  );

  final String name;
  const StatusCustomer(this.name);
}

enum DetailTabEnum {
  info(
    'Thông tin cơ bản',
  ),
  patient(
    'Bệnh án',
  ),
  test(
    'Kết quả xét nghiệm',
  ),
  calendar(
    'Lịch hẹn',
  ),
  order(
    'Đơn hàng',
  ),
  service(
    'Dịch vụ đã dùng',
  ),
  product(
    'Sản phẩm đã mua',
  ),
  infor_sub(
    'Thông tin bổ sung',
  );

  final String name;
  const DetailTabEnum(this.name);
}

enum TypeFileCustomer {
  //"test: Kết quả xét nghiệm, patient: bệnh án, diagnostic: chuẩn đoán."
  test('Kết quả xét nghiệm', 'test'),
  patient('Bệnh án', 'patient'),
  diagnostic('Chuẩn đoán', 'diagnostic');

  final String name;
  final String code;
  const TypeFileCustomer(
    this.name,
    this.code,
  );
}

enum GenderEnum {
  male('Nam', 1),
  female('Nữ', 2),
  other('Khác', 3);

  final String name;
  final int code;
  const GenderEnum(
    this.name,
    this.code,
  );
}

extension extGender on int? {
  GenderEnum get toGender {
    switch (this) {
      case 1:
        return GenderEnum.female;
      case 2:
        return GenderEnum.male;
      default:
        return GenderEnum.other;
    }
  }
}

enum TypeOrderEnum {
  sell(
    'Đơn hàng sản phẩm',
    'product',
    ColorApp.blue20,
    'Tạo đơn sản phẩm',
  ),
  prescription(
    'Đơn thuốc',
    'PRESCRIPTION',
    ColorApp.blue20,
    'Tạo đơn thuốc',
  ),
  import(
    'Đơn nhập',
    'IMPORT',
    ColorApp.yellowDC,
    'Tạo đơn nhập',
  ),
  service(
    'Đơn hàng dịch vụ',
    'service',
    ColorApp.yellowDC,
    'Tạo đơn dịch vụ',
  );

  final String name;
  final String code;
  final Color color;
  final String title;

  const TypeOrderEnum(
    this.name,
    this.code,
    this.color,
    this.title,
  );
}

extension extTypeOrder on String? {
  TypeOrderEnum get toTypeOrder {
    switch (this) {
      case 'SELL':
        return TypeOrderEnum.sell;
      case 'PRESCRIPTION':
        return TypeOrderEnum.prescription;
      case 'IMPORT':
        return TypeOrderEnum.import;
      case 'SERVICE':
        return TypeOrderEnum.service;
      default:
        return TypeOrderEnum.sell;
    }
  }
}

enum AccountStatusEnum {
  all('Tất cả', null),
  active('Đang hoạt động', true),
  unActive('Vô hiệu hoá', false);

  final String name;
  final bool? value;

  const AccountStatusEnum(
    this.name,
    this.value,
  );
}

enum SortCustomerDashboard {
  total_order('Theo số lượng đơn', 'total_order'),
  total_price('Theo doanh số', 'total_price');

  final String name;
  final String code;
  const SortCustomerDashboard(this.name, this.code);
}

enum SortEmployeeDashboard {
  totalOrder('Theo số lượng đơn', '-total_order'),
  totalSales('Theo doanh số', '-total_sales'),
  totalSalesByProduct('Sản phẩm', '-total_sales');

  final String name;
  final String code;
  const SortEmployeeDashboard(this.name, this.code);
}

enum SortPrdDashboard {
  revenue('Doanh số', 'revenue'),
  sold('Số lượng bán', 'sold'),
  expired('Cận date', 'expired');

  final String name;
  final String code;
  const SortPrdDashboard(this.name, this.code);
}

enum StatusOrderKafa {
  all(
    'All',
    'Tất cả',
    'ALL',
    Icons.add,
    ColorApp.green,
  ),
  pending(
    '1',
    'Chờ xác nhận',
    'CXN',
    Icons.access_time,
    ColorApp.yellowD2,
  ),
  accept(
    '2',
    'Đã xác nhận',
    'DXN',
    Icons.check_circle_outline_sharp,
    ColorApp.blue20,
  ),
  deny(
    '3',
    'Từ chối',
    'TC',
    Icons.cancel_outlined,
    ColorApp.red,
  ),
  complete(
    '4',
    'Đã hoàn thành',
    'HT',
    Icons.check_circle_outline_sharp,
    ColorApp.green,
  ),
  cancel(
    '5',
    'Đã huỷ',
    'DH',
    Icons.cancel_outlined,
    ColorApp.red,
  );

  static StatusOrderKafa fromCode(String code) {
    return StatusOrderKafa.values.firstWhere(
      (value) => value.code == code,
      orElse: () => all,
    );
  }

  const StatusOrderKafa(
    this.id,
    this.title,
    this.code,
    this.icon,
    this.color,
  );

  final String id;
  final String title;
  final String code;
  final IconData icon;
  final Color color;
}

enum RangePriceV2Enum {
  all(max: null, min: null, title: 'Tất cả'),
  max50(max: 50000, min: null, title: 'Dưới 50.000'),
  range50_100K(min: 50000, max: 100000, title: '50.000 - 100.000'),
  range100_200K(min: 100000, max: 200000, title: '100.000 - 200.000'),
  range200_500K(min: 200000, max: 500000, title: '200.000 - 500.000'),
  range500_1M(min: 500000, max: 1000000, title: '500.000 - 1.000.000'),
  range1M_2M(min: 1000000, max: 2000000, title: '1.000.000 - 2.000.000'),
  range2M_5M(min: 2000000, max: 5000000, title: '2.000.000 - 5.000.000'),
  min5M(max: null, min: 5000000, title: 'Trên 5.000.000');

  final int? max;
  final int? min;
  final String title;

  const RangePriceV2Enum({
    required this.min,
    required this.max,
    required this.title,
  });
}

enum ZaloOaEnum {
  all('Tất cả', null),
  isActive('Đã quan tâm', true),
  unActive('Chưa quan tâm', false);

  final String title;
  final bool? data;
  const ZaloOaEnum(this.title, this.data);
}

enum IsDebtEnum {
  all('Tất cả', null),
  isDebt('Còn công nợ', true),
  unDebt('Đã tất toán', false);

  final String title;
  final bool? data;
  const IsDebtEnum(this.title, this.data);
}
