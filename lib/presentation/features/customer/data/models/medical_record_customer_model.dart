// To parse this JSON data, do
//
//     final medicalRecordCustomerModel = medicalRecordCustomerModelFromJson(jsonString);

import 'dart:convert';

import '../../../../features_v2/models/product/product_v2_model.dart';

MedicalRecordCustomerModel medicalRecordCustomerModelFromJson(String str) => MedicalRecordCustomerModel.fromJson(json.decode(str));

String medicalRecordCustomerModelToJson(MedicalRecordCustomerModel data) => json.encode(data.toJson());

class MedicalRecordCustomerModel {
    final int? id;
    final String? code;
    final dynamic name;
    final String? nameVn;
    final List<AppointmentDatum>? appointmentData;
    final int? appointmentCount;
    final DateTime? latestAppointmentDate;

    MedicalRecordCustomerModel({
        this.id,
        this.code,
        this.name,
        this.nameVn,
        this.appointmentData,
        this.appointmentCount,
        this.latestAppointmentDate,
    });

    MedicalRecordCustomerModel copyWith({
        int? id,
        String? code,
        dynamic name,
        String? nameVn,
        List<AppointmentDatum>? appointmentData,
        int? appointmentCount,
        DateTime? latestAppointmentDate,
    }) => 
        MedicalRecordCustomerModel(
            id: id ?? this.id,
            code: code ?? this.code,
            name: name ?? this.name,
            nameVn: nameVn ?? this.nameVn,
            appointmentData: appointmentData ?? this.appointmentData,
            appointmentCount: appointmentCount ?? this.appointmentCount,
            latestAppointmentDate: latestAppointmentDate ?? this.latestAppointmentDate,
        );

    factory MedicalRecordCustomerModel.fromJson(Map<String, dynamic> json) => MedicalRecordCustomerModel(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        nameVn: json['name_vn'],
        appointmentData: json['appointment_data'] == null ? [] : List<AppointmentDatum>.from(json['appointment_data']!.map((x) => AppointmentDatum.fromJson(x))),
        appointmentCount: json['appointment_count'],
        latestAppointmentDate: json['latest_appointment_date'] == null ? null : DateTime.parse(json['latest_appointment_date']),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'name_vn': nameVn,
        'appointment_data': appointmentData == null ? [] : List<dynamic>.from(appointmentData!.map((x) => x.toJson())),
        'appointment_count': appointmentCount,
        'latest_appointment_date': latestAppointmentDate?.toIso8601String(),
    };
}

class AppointmentDatum {
    final int? id;
    final String? code;
    final String? note;
    final String? conclusion;
    final DateTime? createdAt;
    final int? serviceCount;
    final int? imagesCount;
    final int? filesCount;
    final List<ProductV2Model>? productData;

    AppointmentDatum({
        this.id,
        this.code,
        this.note,
        this.conclusion,
        this.createdAt,
        this.serviceCount,
        this.imagesCount,
        this.filesCount,
        this.productData,
    });

    AppointmentDatum copyWith({
        int? id,
        String? code,
        String? note,
        String? conclusion,
        DateTime? createdAt,
        int? serviceCount,
        int? imagesCount,
        int? filesCount,
        List<ProductV2Model>? productData,
    }) => 
        AppointmentDatum(
            id: id ?? this.id,
            code: code ?? this.code,
            note: note ?? this.note,
            conclusion: conclusion ?? this.conclusion,
            createdAt: createdAt ?? this.createdAt,
            serviceCount: serviceCount ?? this.serviceCount,
            imagesCount: imagesCount ?? this.imagesCount,
            filesCount: filesCount ?? this.filesCount,
            productData: productData ?? this.productData,
        );

    factory AppointmentDatum.fromJson(Map<String, dynamic> json) => AppointmentDatum(
        id: json['id'],
        code: json['code'],
        note: json['note'],
        conclusion: json['conclusion'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        serviceCount: json['service_count'],
        imagesCount: json['images_count'],
        filesCount: json['files_count'],
        productData: json['product_data'] == null ? [] : List<ProductV2Model>.from(json['product_data']!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'note': note,
        'conclusion': conclusion,
        'created_at': createdAt?.toIso8601String(),
        'service_count': serviceCount,
        'images_count': imagesCount,
        'files_count': filesCount,
        'product_data': productData == null ? [] : List<dynamic>.from(productData!.map((x) => x)),
    };
}
