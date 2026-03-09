
class ParamListPhieuKhaman {
  int? company;
  String? search;
  int? customer;
  int? doctor;
  int page;
  int limit;
  ParamListPhieuKhaman({
    this.company,
    this.search,
    this.customer,
    this.doctor,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'search': search,
      'customer': customer,
      'doctor': doctor,
      'page': page,
      'limit': limit,
    };
  }
}
