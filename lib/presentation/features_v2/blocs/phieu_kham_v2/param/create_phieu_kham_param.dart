class CreatePhieuKhamParam {
  int? appointmentService;
  String? conclusion;
  String? note;
  List<int> pathologies = [];
  List<CreateDonThuocParam> prescriptions = [];

  CreatePhieuKhamParam({
    this.appointmentService,
    this.conclusion,
    this.note,
    this.pathologies = const [],
    this.prescriptions = const [],
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointment_service'] = appointmentService;
    data['conclusion'] = conclusion;
    data['pathologies'] = pathologies;
    data['note'] = note;
    data['prescriptions'] = prescriptions.map((e) => e.toJson()).toList();
    data.removeWhere((key, value) => value == null);
    return data;
  }

  CreatePhieuKhamParam.fromJson(Map<String, dynamic> json) {
    appointmentService = json['appointmentService'];
    conclusion = json['conclusion'];
    note = json['note'];
    pathologies = json['pathologies'].cast<int>();
    prescriptions = json['prescriptions'] != null
        ? List<CreateDonThuocParam>.from(json['prescriptions']
            .map((e) => CreateDonThuocParam.fromJson(e)))
        : [];
  }

}

class CreateDonThuocParam {
  int? product;
  int? unit;
  int? quantity;
  String? lieuDung;

  CreateDonThuocParam({
    this.product,
    this.unit,
    this.quantity,
    this.lieuDung,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['unit'] = unit;
    data['quantity'] = quantity;
    data['lieu_dung'] = lieuDung;
    data.removeWhere((key, value) => value == null);
    return data;
  }

  CreateDonThuocParam.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    unit = json['unit'];
    quantity = json['quantity'];
    lieuDung = json['lieuDung'];
  }
}