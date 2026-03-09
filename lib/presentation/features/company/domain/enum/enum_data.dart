enum TimeWorkSpace {
  up('Từ mới đến cũ', '-id'),
  down('Từ cũ đến mới', 'id');

  final String title;
  final String code;
  const TimeWorkSpace(this.title, this.code);
}

enum RevenueWorkSpace {
  up('Từ cao đến thấp', '-total_sales'),
  down('Từ thấp đến cao', 'total_sales');

  final String title;
  final String code;
  const RevenueWorkSpace(this.title, this.code);
}

enum StatusWorkSpace {
  all('ACTIVE,INACTIVE', 'Tất cả'),
  review('REVIEW', 'Chờ phê duyệt'),
  active('ACTIVE', 'Đang Hoạt động'),
  inActive('INACTIVE', 'Dừng hoạt động'),
  suspenged('SUSPENGED', 'Khoá tạm thời'),
  closed('CLOSED', 'Đóng vĩnh viễn');

  final String title;
  final String code;
  const StatusWorkSpace(
    this.code,
    this.title,
  );
}

enum TypeCreateCompany {
  company('Tạo mới Workspace', 'Workspace'),
  branch('Tạo mới cơ sở', 'cơ sở');

  final String title;
  final String value;
  const TypeCreateCompany(
    this.title,
    this.value,
  );
}

// =================== Employee ===========================

enum EmployeeStatus {
  all('ALL', 'Tất cả'),
  pending('PENDING', 'Chờ xác nhận'),
  refuse('REFUSE', 'Đã từ chối'),
  active('ACTIVE', 'Đang hoạt động'),
  suspended('SUSPENDED', 'Tạm nghỉ'),
  terminate('TERMINATE', 'Nghỉ việc'),
  declined('DECLINED', 'Đã từ chối');

  final String code;
  final String title;

  const EmployeeStatus(
    this.code,
    this.title,
  );
  static EmployeeStatus fromCode(String? code) {
    return EmployeeStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => terminate,
    );
  }
}

enum RedInvoicePublisher {
  viettel('VIETTEL'),
  vnpt('VNPT');

  final String code;

  const RedInvoicePublisher(
    this.code,
  );
}
