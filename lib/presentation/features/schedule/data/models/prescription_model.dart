import 'package:pharmago/presentation/features_v2/models/customer/v2/customer_model.dart';
import 'package:pharmago/presentation/features_v2/models/customer/v2/user_model.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';

class PrescriptionModel {
    final int? id;
    final String? code;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? userCreatedId;
    final int? userUpdatedId;
    final CustomerV2Model? patient;
    final UserV2Model? userCreated;
    final UserV2Model? userUpdated;
    final List<PrescriptionItem>? items;

    PrescriptionModel({
        this.id,
        this.code,
        this.createdAt,
        this.updatedAt,
        this.userCreatedId,
        this.userUpdatedId,
        this.patient,
        this.userCreated,
        this.userUpdated,
        this.items,
    });

    PrescriptionModel copyWith({
        int? id,
        String? code,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? userCreatedId,
        int? userUpdatedId,
        CustomerV2Model? patient,
        UserV2Model? userCreated,
        UserV2Model? userUpdated,
        List<PrescriptionItem>? items,
    }) => 
        PrescriptionModel(
            id: id ?? this.id,
            code: code ?? this.code,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            userCreatedId: userCreatedId ?? this.userCreatedId,
            userUpdatedId: userUpdatedId ?? this.userUpdatedId,
            patient: patient ?? this.patient,
            userCreated: userCreated ?? this.userCreated,
            userUpdated: userUpdated ?? this.userUpdated,
            items: items ?? this.items,
        );

    factory PrescriptionModel.fromJson(Map<String, dynamic> json) => PrescriptionModel(
        id: json['id'],
        code: json['code'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
        userCreatedId: json['user_created_id'],
        userUpdatedId: json['user_updated_id'],
        patient: json['patient'] == null ? null : CustomerV2Model.fromJson(json['patient']),
        userCreated: json['user_created'] == null ? null : UserV2Model.fromJson(json['user_created']),
        userUpdated: json['user_updated'] == null ? null : UserV2Model.fromJson(json['user_updated']),
        items: json['items'] == null ? [] : List<PrescriptionItem>.from(json['items']!.map((x) => PrescriptionItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'user_created_id': userCreatedId,
        'user_updated_id': userUpdatedId,
        'patient': patient?.toJson(),
        'user_created': userCreated?.toJson(),
        'user_updated': userUpdated?.toJson(),
        'items': items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class PrescriptionItem {
    final int? id;
    final String? lieuDung;
    final int? quantity;
    final ProductV2Model? productData;

    PrescriptionItem({
        this.id,
        this.lieuDung,
        this.quantity,
        this.productData,
    });

    PrescriptionItem copyWith({
        int? id,
        String? lieuDung,
        int? quantity,
        ProductV2Model? productData,
    }) => 
        PrescriptionItem(
            id: id ?? this.id,
            lieuDung: lieuDung ?? this.lieuDung,
            quantity: quantity ?? this.quantity,
            productData: productData ?? this.productData,
        );

    factory PrescriptionItem.fromJson(Map<String, dynamic> json) => PrescriptionItem(
        id: json['id'],
        lieuDung: json['lieu_dung'],
        quantity: json['quantity'],
        productData: json['product_data'] == null ? null : ProductV2Model.fromJson(json['product_data']),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'lieu_dung': lieuDung,
        'quantity': quantity,
        'product_data': productData?.toJson(),
    };
}

extension PrescriptionModelExt on PrescriptionModel {
  num get totalPrice {
    return items?.fold<num>(0, (total, e) {
      total += (e.quantity ?? 0) * (e.productData?.unitData?.sellPrice ?? 0);
      return total;
    },) ?? 0;
  }
}