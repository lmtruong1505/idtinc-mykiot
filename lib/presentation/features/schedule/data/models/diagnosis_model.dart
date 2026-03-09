import 'package:pharmago/presentation/features/product/data/models/service_model.dart';

import '../../../../features_v2/models/product/image_model.dart';
import 'appointment_payload_data.dart';
import 'pathology_model.dart';

class DiagnosisModel {
  final String? symptoms;
  final VitalSigns? vitalSigns;
  final List<AppointmentService>? appointmentService;
  final String? conclusion;
  final String? note;
  final List<PathologyModel>? diagnosis;

  DiagnosisModel({
    this.symptoms,
    this.vitalSigns,
    this.appointmentService,
    this.conclusion,
    this.note,
    this.diagnosis,
  });

  DiagnosisModel copyWith({
    String? symptoms,
    VitalSigns? vitalSigns,
    List<AppointmentService>? appointmentService,
    String? conclusion,
    String? note,
    List<PathologyModel>? diagnosis,
  }) =>
      DiagnosisModel(
        symptoms: symptoms ?? this.symptoms,
        vitalSigns: vitalSigns ?? this.vitalSigns,
        appointmentService: appointmentService ?? this.appointmentService,
        conclusion: conclusion ?? this.conclusion,
        note: note ?? this.note,
        diagnosis: diagnosis ?? this.diagnosis,
      );

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) => DiagnosisModel(
        symptoms: json['symptoms'],
        vitalSigns: json['vital_signs'] == null
            ? null
            : VitalSigns.fromJson(json['vital_signs']),
        appointmentService: json['appointment_service'] == null
            ? []
            : List<AppointmentService>.from(json['appointment_service']!
                .map((x) => AppointmentService.fromJson(x))),
        conclusion: json['conclusion'],
        note: json['loi_dan'],
        diagnosis: json['diagnosis'] == null
            ? []
            : (json['diagnosis'] as List)
                .map((x) => PathologyModel.fromJson(x))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        'symptoms': symptoms,
        'vital_signs': vitalSigns?.toJson(),
        'appointment_service': appointmentService == null
            ? []
            : List<dynamic>.from(appointmentService!.map((x) => x.toJson())),
        'conclusion': conclusion,
        'note': note,
        'diagnosis': diagnosis == null
            ? []
            : List<dynamic>.from(diagnosis!.map((x) => x)),
      };
}

class AppointmentService {
  final int? id;
  final ServiceModel? serviceData;
  final dynamic employeeName;
  final List<MedicalBillData>? medicalBillData;

  AppointmentService({
    this.id,
    this.serviceData,
    this.employeeName,
    this.medicalBillData,
  });

  AppointmentService copyWith({
    int? id,
    ServiceModel? serviceData,
    dynamic employeeName,
    List<MedicalBillData>? medicalBillData,
  }) =>
      AppointmentService(
        id: id ?? this.id,
        serviceData: serviceData ?? this.serviceData,
        employeeName: employeeName ?? this.employeeName,
        medicalBillData: medicalBillData ?? this.medicalBillData,
      );

  factory AppointmentService.fromJson(Map<String, dynamic> json) =>
      AppointmentService(
        id: json['id'],
        serviceData: json['service_data'] == null
            ? null
            : ServiceModel.fromJson(json['service_data']),
        employeeName: json['employee_name'],
        medicalBillData: json['medical_bill_data'] == null
            ? []
            : List<MedicalBillData>.from(json['medical_bill_data']!
                .map((x) => MedicalBillData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'service_data': serviceData?.toJson(),
        'employee_name': employeeName,
        'medical_bill_data': medicalBillData == null
            ? []
            : List<dynamic>.from(medicalBillData!.map((x) => x)),
      };
}

class MedicalBillData {
  final int? id;
  final String? conclusion;
  final List<ImageModel>? files;

  MedicalBillData({
    this.id,
    this.conclusion,
    this.files,
  });

  MedicalBillData copyWith({
    int? id,
    String? conclusion,
    List<ImageModel>? files,
  }) =>
      MedicalBillData(
        id: id ?? this.id,
        conclusion: conclusion ?? this.conclusion,
        files: files ?? this.files,
      );

  factory MedicalBillData.fromJson(Map<String, dynamic> json) =>
      MedicalBillData(
        id: json['id'],
        conclusion: json['conclusion'],
        files: json['files'] == null
            ? []
            : List<ImageModel>.from(
                json['files']!.map((x) => ImageModel.fromJson(x)),
              ),
      );
}
