import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/company/data/models/company_model.dart';
import 'package:pharmago/presentation/features_v2/models/customer/v2/user_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/image_model.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../config/app_style/init_app_style.dart';
import '../../../../features_v2/blocs/enum/enum_calendar_time.dart';
import '../../../../features_v2/models/customer/v2/customer_model.dart';
import '../../../../features_v2/models/service/service.dart';

class AppointmentScheduleModel {
  final int? id;
  final String? code;
  final CompanyModel? workspace;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? meetingAt;
  final String? uuid;
  final String? note;
  final List<ImageModel>? images;
  final List<ImageModel>? filesConclusion;
  final bool? isRelatives;
  final int? orderInDay;
  final int? userCreatedId;
  final int? userUpdatedId;
  final UserV2Model? userCreated;
  final UserV2Model? userUpdated;
  final CustomerV2Model? customer;
  final List<AppointmentScheduleService>? services;
  final CustomerV2Model? patient;

  AppointmentScheduleModel({
    this.id,
    this.code,
    this.workspace,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.meetingAt,
    this.uuid,
    this.note,
    this.images,
    this.filesConclusion,
    this.isRelatives,
    this.orderInDay,
    this.userCreatedId,
    this.userUpdatedId,
    this.userCreated,
    this.userUpdated,
    this.customer,
    this.services,
    this.patient,
  });

  AppointmentScheduleModel copyWith({
    int? id,
    String? code,
    CompanyModel? workspace,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? meetingAt,
    String? uuid,
    String? note,
    List<ImageModel>? images,
    List<ImageModel>? filesConclusion,
    bool? isRelatives,
    int? orderInDay,
    int? userCreatedId,
    int? userUpdatedId,
    UserV2Model? userCreated,
    UserV2Model? userUpdated,
    CustomerV2Model? customer,
    List<AppointmentScheduleService>? services,
    CustomerV2Model? patient,
  }) =>
      AppointmentScheduleModel(
        id: id ?? this.id,
        code: code ?? this.code,
        workspace: workspace ?? this.workspace,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        meetingAt: meetingAt ?? this.meetingAt,
        uuid: uuid ?? this.uuid,
        note: note ?? this.note,
        images: images ?? this.images,
        filesConclusion: filesConclusion ?? this.filesConclusion,
        isRelatives: isRelatives ?? this.isRelatives,
        orderInDay: orderInDay ?? this.orderInDay,
        userCreatedId: userCreatedId ?? this.userCreatedId,
        userUpdatedId: userUpdatedId ?? this.userUpdatedId,
        userCreated: userCreated ?? this.userCreated,
        userUpdated: userUpdated ?? this.userUpdated,
        customer: customer ?? this.customer,
        services: services ?? this.services,
        patient: patient ?? this.patient,
      );

  factory AppointmentScheduleModel.fromJson(Map<String, dynamic> json) =>
      AppointmentScheduleModel(
        id: json['id'],
        code: json['code'],
        workspace: json['workspace_data'] == null
            ? null
            : CompanyModel.fromJson(json['workspace_data']),
        status: json['status'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        meetingAt: json['meeting_at'] == null
            ? null
            : DateTime.parse(json['meeting_at']),
        uuid: json['uuid'],
        note: json['note'],
        isRelatives: json['is_relatives'],
        orderInDay: json['order_in_day'],
        userCreatedId: json['user_created_id'],
        userUpdatedId: json['user_updated_id'],
        userCreated: json['user_created'] == null
            ? null
            : UserV2Model.fromJson(json['user_created']),
        userUpdated: json['user_updated'] == null
            ? null
            : UserV2Model.fromJson(json['user_updated']),
        customer: json['customer'] == null
            ? null
            : CustomerV2Model.fromJson(json['customer']),
        services: json['services'] == null
            ? []
            : List<AppointmentScheduleService>.from(json['services']!
                .map((x) => AppointmentScheduleService.fromJson(x))),
        patient: json['patient'] == null
            ? null
            : CustomerV2Model.fromJson(json['patient']),
        images: json['images'] == null
            ? []
            : List<ImageModel>.from(json['images']!
                .map((x) => ImageModel.fromJson(x))),
        filesConclusion: json['files_conclusion'] == null
            ? []
            : List<ImageModel>.from(json['files_conclusion']!
                .map((x) => ImageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'workspace_data': workspace?.toJson(),
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'meeting_at': meetingAt?.toIso8601String(),
        'uuid': uuid,
        'note': note,
        'is_relatives': isRelatives,
        'order_in_day': orderInDay,
        'user_created_id': userCreatedId,
        'user_updated_id': userUpdatedId,
        'user_created': userCreated?.toJson(),
        'user_updated': userUpdated,
        'customer': customer?.toJson(),
        'services': services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        'patient': patient?.toJson(),
      };
}

class AppointmentScheduleService {
  final int? id;
  final int? no;
  final ServiceV2Model? serviceData;
  final PriceService? priceData;
  final CustomerV2Model? employeeData;

  AppointmentScheduleService({
    this.id,
    this.no,
    this.serviceData,
    this.priceData,
    this.employeeData,
  });

  AppointmentScheduleService copyWith({
    int? id,
    int? no,
    ServiceV2Model? serviceData,
    PriceService? priceData,
    CustomerV2Model? employeeData,
  }) =>
      AppointmentScheduleService(
        id: id ?? this.id,
        no: no ?? this.no,
        serviceData: serviceData ?? this.serviceData,
        priceData: priceData ?? this.priceData,
        employeeData: employeeData ?? this.employeeData,
      );

  factory AppointmentScheduleService.fromJson(Map<String, dynamic> json) =>
      AppointmentScheduleService(
        id: json['id'],
        no: json['no'],
        serviceData: json['service_data'] == null
            ? null
            : ServiceV2Model.fromJson(json['service_data']),
        priceData: json['price_data'] == null
            ? null
            : PriceService.fromJson(json['price_data']),
        employeeData: json['employee_data'] == null
            ? null
            : CustomerV2Model.fromJson(json['employee_data']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'no': no,
        'service_data': serviceData?.toJson(),
        'price_data': priceData?.toJson(),
        'employee_data': employeeData,
      };
}

extension GetAppointmentScheduleModel on AppointmentScheduleModel {
  Widget get statusView {
    final iconCode = switch (enumStatus) {
      EnumCalendarTime.all => throw UnimplementedError(),
      EnumCalendarTime.booked => 'e470',
      EnumCalendarTime.comfirmed => 'f274',
      EnumCalendarTime.arrived => 'e0d1',
      EnumCalendarTime.consulting => 'e122',
      EnumCalendarTime.completed => 'f058',
      EnumCalendarTime.canceled => 'f273',
    };
    final colorIcon = switch (enumStatus) {
      EnumCalendarTime.all => throw UnimplementedError(),
      EnumCalendarTime.booked => AppColors.blue40,
      EnumCalendarTime.comfirmed => AppColors.green40,
      EnumCalendarTime.arrived => AppColors.carrot40,
      EnumCalendarTime.consulting => AppColors.green40,
      EnumCalendarTime.completed => AppColors.grey40,
      EnumCalendarTime.canceled => AppColors.red40,
    };
    final titleColor = switch (enumStatus) {
      EnumCalendarTime.all => throw UnimplementedError(),
      EnumCalendarTime.booked => AppColors.blue60,
      EnumCalendarTime.comfirmed => AppColors.green60,
      EnumCalendarTime.arrived => AppColors.carrot60,
      EnumCalendarTime.consulting => AppColors.green60,
      EnumCalendarTime.completed => AppColors.grey60,
      EnumCalendarTime.canceled => AppColors.red60,
    };
    final borderColor = switch (enumStatus) {
      EnumCalendarTime.all => throw UnimplementedError(),
      EnumCalendarTime.booked => AppColors.blue40,
      EnumCalendarTime.comfirmed => AppColors.green40,
      EnumCalendarTime.arrived => AppColors.carrot40,
      EnumCalendarTime.consulting => AppColors.green40,
      EnumCalendarTime.completed => AppColors.grey40,
      EnumCalendarTime.canceled => AppColors.red40,
    };
    final bgColor = switch (enumStatus) {
      EnumCalendarTime.all => throw UnimplementedError(),
      EnumCalendarTime.booked => AppColors.blue20,
      EnumCalendarTime.comfirmed => AppColors.green20,
      EnumCalendarTime.arrived => AppColors.carrot20,
      EnumCalendarTime.consulting => AppColors.green20,
      EnumCalendarTime.completed => AppColors.grey20,
      EnumCalendarTime.canceled => AppColors.red20,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: sp2,
        horizontal: sp6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(sp12),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          FaIcon(
            iconCode: iconCode,
            color: colorIcon,
            size: sp16,
          ),
          sp4.width,
          Text(
            enumStatus.title,
            style: s10w500.copyWith(
              color: titleColor,
            ),
          ),
        ],
      ),
    );
  }

  num get totalPriceService {
    return services?.fold<num>(
          0,
          (total, e) {
            total += (e.serviceData?.quantity ?? 0) *
                (e.serviceData?.price?.price ?? 0);
            return total;
          },
        ) ??
        0;
  }

  EnumCalendarTime get enumStatus {
    return EnumCalendarTime.values.firstWhere(
      (e) => e.code == status,
    );
  }
}
