// To parse this JSON data, do
//
//     final packagingModel = packagingModelFromJson(jsonString);

import 'dart:convert';

PackagingModel packagingModelFromJson(String str) => PackagingModel.fromJson(json.decode(str));

String packagingModelToJson(PackagingModel data) => json.encode(data.toJson());

class PackagingModel {
    final TypeData? parentTypeData;
    final TypeData? childTypeData;
    final PackagingModel? childPackagingData;
    final int? quantity;
    final int? product;
    final String? code;

    PackagingModel({
        this.parentTypeData,
        this.childTypeData,
        this.childPackagingData,
        this.quantity,
        this.product,
        this.code,
    });

    PackagingModel copyWith({
        TypeData? parentTypeData,
        TypeData? childTypeData,
        PackagingModel? childPackagingData,
        int? quantity,
        int? product,
        String? code,
    }) => 
        PackagingModel(
            parentTypeData: parentTypeData ?? this.parentTypeData,
            childTypeData: childTypeData ?? this.childTypeData,
            childPackagingData: childPackagingData ?? this.childPackagingData,
            quantity: quantity ?? this.quantity,
            product: product ?? this.product,
            code: code ?? this.code,
        );

    factory PackagingModel.fromJson(Map<String, dynamic> json) => PackagingModel(
        parentTypeData: json["parent_type_data"] == null ? null : TypeData.fromJson(json["parent_type_data"]),
        childTypeData: json["child_type_data"] == null ? null : TypeData.fromJson(json["child_type_data"]),
        childPackagingData: json["child_packaging_data"] == null ? null : PackagingModel.fromJson(json["child_packaging_data"]),
        quantity: json["quantity"],
        product: json["product"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "parent_type_data": parentTypeData?.toJson(),
        "child_type_data": childTypeData?.toJson(),
        "child_packaging_data": childPackagingData?.toJson(),
        "quantity": quantity,
        "product": product,
        "code": code,
    };
}

class TypeData {
    final int? id;
    final String? title;
    final String? code;

    TypeData({
        this.id,
        this.title,
        this.code,
    });

    TypeData copyWith({
        int? id,
        String? title,
        String? code,
    }) => 
        TypeData(
            id: id ?? this.id,
            title: title ?? this.title,
            code: code ?? this.code,
        );

    factory TypeData.fromJson(Map<String, dynamic> json) => TypeData(
        id: json["id"],
        title: json["title"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "code": code,
    };
}
