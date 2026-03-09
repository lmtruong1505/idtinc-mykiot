// To parse this JSON data, do
//
//     final appointmentPayloadData = appointmentPayloadDataFromJson(jsonString);

import 'dart:convert';

import '../../../../features_v2/models/customer/v2/customer_model.dart';

AppointmentPayloadData appointmentPayloadDataFromJson(String str) =>
    AppointmentPayloadData.fromJson(json.decode(str));

String appointmentPayloadDataToJson(AppointmentPayloadData data) =>
    json.encode(data.toJson());

class AppointmentPayloadData {
  final bool? sendZns;
  final String? symptoms;
  final List<int>? pathology;
  final String? conclusion;
  final int? customerId;
  final String? note;
  final String? customerPhone;
  final String? customerName;
  final CustomerV2Model? customer;
  final CustomerV2Model? relatives;
  final bool? isRelatives;
  final RelativesData? relativesData;
  final VitalSigns? vitalSigns;
  final int? company;
  final String? meetingAt;
  final List<Service>? services;
  final List<Reminder>? reminders;

  AppointmentPayloadData({
    this.sendZns,
    this.symptoms,
    this.pathology,
    this.conclusion,
    this.customerId,
    this.note,
    this.customerPhone,
    this.customerName,
    this.customer,
    this.relatives,
    this.isRelatives,
    this.relativesData,
    this.vitalSigns,
    this.company,
    this.meetingAt,
    this.services,
    this.reminders,
  });

  AppointmentPayloadData copyWith({
    bool? sendZns,
    String? symptoms,
    List<int>? pathology,
    String? conclusion,
    int? customerId,
    String? note,
    String? customerPhone,
    String? customerName,
    CustomerV2Model? customer,
    CustomerV2Model? relatives,
    bool? isRelatives,
    RelativesData? relativesData,
    VitalSigns? vitalSigns,
    int? company,
    String? meetingAt,
    List<Service>? services,
    List<Reminder>? reminders,
  }) =>
      AppointmentPayloadData(
        sendZns: sendZns ?? this.sendZns,
        symptoms: symptoms ?? this.symptoms,
        pathology: pathology ?? this.pathology,
        conclusion: conclusion ?? this.conclusion,
        customerId: customerId ?? this.customerId,
        note: note ?? this.note,
        customerPhone: customerPhone ?? this.customerPhone,
        customerName: customerName ?? this.customerName,
        customer: customer ?? this.customer,
        isRelatives: isRelatives ?? this.isRelatives,
        relativesData: relativesData ?? this.relativesData,
        vitalSigns: vitalSigns ?? this.vitalSigns,
        company: company ?? this.company,
        meetingAt: meetingAt ?? this.meetingAt,
        services: services ?? this.services,
        reminders: reminders ?? this.reminders,
        relatives: relatives ?? this.relatives,
      );

  factory AppointmentPayloadData.fromJson(Map<String, dynamic> json) =>
      AppointmentPayloadData(
        sendZns: json['send_zns'],
        symptoms: json['symptoms'],
        pathology: json['pathology'],
        conclusion: json['conclusion'],
        customerId: json['customerId'],
        note: json['note'],
        customerPhone: json['customer_phone'],
        customerName: json['customer_name'],
        isRelatives: json['is_relatives'],
        relativesData: json['relatives_data'] == null
            ? null
            : RelativesData.fromJson(json['relatives_data']),
        vitalSigns: json['vital_signs'] == null
            ? null
            : VitalSigns.fromJson(json['vital_signs']),
        company: json['company'],
        meetingAt: json['meetingAt'],
        services: json['services'] == null
            ? []
            : List<Service>.from(
                json['services']!.map((x) => Service.fromJson(x))),
        reminders: json['reminders'] == null
            ? []
            : List<Reminder>.from(
                json['reminders']!.map((x) => Reminder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'send_zns': sendZns,
        'conclusion': conclusion,
        'symptoms': symptoms,
        'pathology': pathology,
        'note': note,
        'customerId': customerId,
        'customer_phone': customerPhone,
        'customer_name': customerName,
        'is_relatives': isRelatives,
        'relatives_data': relativesData?.toJson(),
        'vital_signs': vitalSigns?.toJson(),
        'company': company,
        'meetingAt': meetingAt,
        'services': services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        'reminders': reminders == null
            ? []
            : List<dynamic>.from(reminders!.map((x) => x.toJson())),
        'customer': customer?.toJson(),
        'relatives': relatives?.toJson(),
      };
}

class RelativesData {
  final String? relativesPhone;
  final String? relativesName;

  RelativesData({
    this.relativesPhone,
    this.relativesName,
  });

  RelativesData copyWith({
    String? relativesPhone,
    String? relativesName,
  }) =>
      RelativesData(
        relativesPhone: relativesPhone ?? this.relativesPhone,
        relativesName: relativesName ?? this.relativesName,
      );

  factory RelativesData.fromJson(Map<String, dynamic> json) => RelativesData(
        relativesPhone: json['relatives_phone'],
        relativesName: json['relatives_name'],
      );

  Map<String, dynamic> toJson() => {
        'relatives_phone': relativesPhone,
        'relatives_name': relativesName,
      };
}

class Reminder {
  final int? id;
  final String? message;
  final int? quantity;
  final String? unit;

  Reminder({
    this.id,
    this.message,
    this.quantity,
    this.unit,
  });

  Reminder copyWith({
    int? id,
    String? message,
    int? quantity,
    String? unit,
  }) =>
      Reminder(
        id: id ?? this.id,
        message: message ?? this.message,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
      );

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        message: json['message'],
        quantity: json['quantity'],
        unit: json['unit'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'quantity': quantity,
        'unit': unit,
      };
}

class Service {
  final int? id;
  final int? serviceId;
  final int? priceId;
  final int? employeeId;

  Service({
    this.id,
    this.serviceId,
    this.priceId,
    this.employeeId,
  });

  Service copyWith({
    int? id,
    int? serviceId,
    int? priceId,
    int? employeeId,
  }) =>
      Service(
        id: id ?? this.id,
        serviceId: serviceId ?? this.serviceId,
        priceId: priceId ?? this.priceId,
        employeeId: employeeId ?? this.employeeId,
      );

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'],
        serviceId: json['serviceId'],
        priceId: json['priceId'],
        employeeId: json['employeeId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceId': serviceId,
        'priceId': priceId,
        'employeeId': employeeId,
      };
}

class VitalSigns {
  final String? mch;
  final String? nhit;
  final String? huytP;
  final String? nhipTh;
  final String? cnNng;
  final String? chiuCao;

  VitalSigns({
    this.mch,
    this.nhit,
    this.huytP,
    this.nhipTh,
    this.cnNng,
    this.chiuCao,
  });

  VitalSigns copyWith({
    String? mch,
    String? nhit,
    String? huytP,
    String? nhipTh,
    String? cnNng,
    String? chiuCao,
  }) =>
      VitalSigns(
        mch: mch ?? this.mch,
        nhit: nhit ?? this.nhit,
        huytP: huytP ?? this.huytP,
        nhipTh: nhipTh ?? this.nhipTh,
        cnNng: cnNng ?? this.cnNng,
        chiuCao: chiuCao ?? this.chiuCao,
      );

  factory VitalSigns.fromJson(Map<String, dynamic> json) => VitalSigns(
        mch: '${json['Mạch'] ?? '-'}',
        nhit: '${json['Nhiệt độ'] ?? '-'}',
        huytP: '${json['Huyết áp'] ?? '-'}',
        nhipTh: '${json['Nhiệp thở'] ?? '-'}',
        cnNng: '${json['Cân nặng'] ?? '-'}',
        chiuCao: '${json['Chiều cao'] ?? '-'}',
      );

  Map<String, dynamic> toJson() => {
        'Mạch': mch,
        'Nhiệt độ': nhit,
        'Huyết áp': huytP,
        'Nhiệp thở': nhipTh,
        'Cân nặng': cnNng,
        'Chiều cao': chiuCao,
      };
}
