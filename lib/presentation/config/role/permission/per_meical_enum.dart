part of 'index.dart';

enum PerMedicalEnum {
  REPORT_LIST('Xem danh sách phiếu khám', 'MEDICAL-REPORT-LIST'),
  REPORT_CREATE('Tạo mới phiếu khám', 'MEDICAL-REPORT-CREATE'),
  REPORT_DETAIL('Xem chi tiết phiếu khám', 'MEDICAL-REPORT-DETAIL'),
  REPORT_EDIT('Sửa thông tin phiếu khám', 'MEDICAL-REPORT-EDIT'),
  REPORT_DELETE('Xoá phiếu khám', 'MEDICAL-REPORT-DELETE'),
  REPORT_ADD_RESULT('Thêm kết luận phiếu khám', 'MEDICAL-REPORT-ADD-RESULT'),
  REPORT_ORDER_CREATE(
    'Tạo đơn thuốc (đơn hàng sản phẩm)',
    'MEDICAL-REPORT-ORDER-CREATE',
  ),
  REPORT_ORDER_DETAIL('Xem chi tiết đơn thuốc', 'MEDICAL-REPORT-ORDER-DETAIL'),
  REPORT_ORDER_EDIT('Sửa đơn thuốc', 'MEDICAL-REPORT-ORDER-EDIT'),
  REPORT_ORDER_DELETE('Xoá đơn thuốc', 'MEDICAL-REPORT-ORDER-DELETE'),
  REPORT_ORDER_SERVICE_CREATE(
    'Tạo đơn dịch vụ (dịch vụ bổ sung)',
    'MEDICAL-REPORT-ORDER-SERVICE-CREATE',
  );

  final String title;
  final String code;
  const PerMedicalEnum(this.title, this.code);
}
