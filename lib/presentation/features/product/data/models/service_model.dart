import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel {
  const ServiceModel._();

  const factory ServiceModel({
    int? id,
    String? code,
    String? title,
    @JsonKey(name: 'service_name') String? serviceName,
    String? entity,
    String? frequency,
    String? unit,
    EmployeeModel? staff,
    double? price,
    String? description,
    int? company,
    List<int>? variants,
    @JsonKey(name: 'reminder_time')
    int? reminderTime,
    bool? active,
    String? congTyDk,
    String? soQuyetDinh,
    String? soDangKy,
    String? brand,
    String? type,
    String? actionTime,
    String? chiDinh,
    String? chongChiDinh,
    String? congDung,
    String? tacDungPhu,
    String? luuY,
    String? hinhThuc,
    String? message,
    List<String>? images,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
}

// class ServiceModel{
//     int? id;
//     String? code;
//     String? title;
//     String? entity;
//     String? frequency;
//     String? unit;
//     StaffModel? staff;
//     double? price;
//     String? description;
//     int? company;
//     List<int>? variants;

//     ServiceModel({
//         this.id,
//         this.code,
//         this.title,
//         this.entity,
//         this.frequency,
//         this.unit,
//         this.staff,
//         this.price,
//         this.description,
//         this.company,
//         this.variants,
//     });

//     factory ServiceModel.fromJson(Map<String, dynamic> json) {
//         return ServiceModel(
//             id: json['id'],
//             code: json['code'],
//             title: json['title'],
//             entity: json['entity'],
//             frequency: json['frequency'],
//             unit: json['unit'],
//             staff: json['staff'] != null ? StaffModel.fromJson(json['staff']) : null,
//             price: json['price'] is int ? json['price'].toDouble() : json['price'],
//             description: json['description'],
//             company: json['company'],
//             variants: json['variants'] != null ? List<int>.from(json['variants']) : null,
//         );
//     }
// }
