class PrescriptionPayloadModel {
  final int? appointment;
  final String? note;
  final List<PrescriptionPayload>? items;

  PrescriptionPayloadModel({
    this.appointment,
    this.note,
    this.items,
  });

  PrescriptionPayloadModel copyWith({
    int? appointment,
    String? note,
    List<PrescriptionPayload>? items,
  }) =>
      PrescriptionPayloadModel(
        appointment: appointment ?? this.appointment,
        note: note ?? this.note,
        items: items ?? this.items,
      );

  factory PrescriptionPayloadModel.fromJson(Map<String, dynamic> json) =>
      PrescriptionPayloadModel(
        appointment: json['appointment'],
        note: json['note'],
        items: json['items'] == null
            ? []
            : List<PrescriptionPayload>.from(
                json['items']!.map((x) => PrescriptionPayload.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'appointment': appointment,
        'note': note,
        'items': items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class PrescriptionPayload {
  final int? product;
  final int? unit;
  final int? quantity;
  final String? lieuDung;

  PrescriptionPayload({
    this.product,
    this.unit,
    this.quantity,
    this.lieuDung,
  });

  PrescriptionPayload copyWith({
    int? product,
    int? unit,
    int? quantity,
    String? lieuDung,
  }) =>
      PrescriptionPayload(
        product: product ?? this.product,
        unit: unit ?? this.unit,
        quantity: quantity ?? this.quantity,
        lieuDung: lieuDung ?? this.lieuDung,
      );

  factory PrescriptionPayload.fromJson(Map<String, dynamic> json) =>
      PrescriptionPayload(
        product: json['product'],
        unit: json['unit'],
        quantity: json['quantity'],
        lieuDung: json['lieu_dung'],
      );

  Map<String, dynamic> toJson() => {
        'product': product,
        'unit': unit,
        'quantity': quantity,
        'lieu_dung': lieuDung,
      };
}
