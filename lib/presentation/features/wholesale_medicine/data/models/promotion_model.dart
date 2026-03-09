// To parse this JSON data, do
//
//     final promotionDetailModel = promotionDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

PromotionDetailModel promotionDetailModelFromJson(String str) => PromotionDetailModel.fromJson(json.decode(str));

String promotionDetailModelToJson(PromotionDetailModel data) => json.encode(data.toJson());

class PromotionDetailModel {
    final int? id;
    final String? title;
    final String? code;
    final DateTime? startDate;
    final DateTime? endDate;
    final String? description;
    final dynamic attachFiles;
    final int? applyPromotion;
    final String? applyPromotionData;
    final dynamic promotionNumber;
    final bool? sameTime;
    final bool? manyTime;
    @JsonKey(name: 'limit_order')
    final bool? limitOrder;
    final int? priority;
    final List<dynamic>? beneficiary;
    final List<dynamic>? beneficiaryType;
    final List<dynamic>? district;
    final List<int>? variant;
    final int? variantConsumer;
    final VariantConsumerData? variantConsumerData;
    final List<Variant>? variantPromotion;
    final int? promotionType;
    final Data? promotionTypeData;
    final int? status;
    final Data? statusData;
    final int? company;
    final int? system;
    final List<PromotionItemDatum>? promotionItemData;
    final int? userCreated;
    final int? userUpdated;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    PromotionDetailModel({
        this.id,
        this.title,
        this.code,
        this.startDate,
        this.endDate,
        this.description,
        this.attachFiles,
        this.applyPromotion,
        this.applyPromotionData,
        this.promotionNumber,
        this.sameTime,
        this.manyTime,
        this.limitOrder,
        this.priority,
        this.beneficiary,
        this.beneficiaryType,
        this.district,
        this.variant,
        this.variantConsumer,
        this.variantConsumerData,
        this.variantPromotion,
        this.promotionType,
        this.promotionTypeData,
        this.status,
        this.statusData,
        this.company,
        this.system,
        this.promotionItemData,
        this.userCreated,
        this.userUpdated,
        this.createdAt,
        this.updatedAt,
    });

    PromotionDetailModel copyWith({
        int? id,
        String? title,
        String? code,
        DateTime? startDate,
        DateTime? endDate,
        String? description,
        dynamic attachFiles,
        int? applyPromotion,
        String? applyPromotionData,
        dynamic promotionNumber,
        bool? sameTime,
        bool? manyTime,
        bool? limitOrder,
        int? priority,
        List<dynamic>? beneficiary,
        List<dynamic>? beneficiaryType,
        List<dynamic>? district,
        List<int>? variant,
        int? variantConsumer,
        VariantConsumerData? variantConsumerData,
        List<Variant>? variantPromotion,
        int? promotionType,
        Data? promotionTypeData,
        int? status,
        Data? statusData,
        int? company,
        int? system,
        List<PromotionItemDatum>? promotionItemData,
        int? userCreated,
        int? userUpdated,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        PromotionDetailModel(
            id: id ?? this.id,
            title: title ?? this.title,
            code: code ?? this.code,
            startDate: startDate ?? this.startDate,
            endDate: endDate ?? this.endDate,
            description: description ?? this.description,
            attachFiles: attachFiles ?? this.attachFiles,
            applyPromotion: applyPromotion ?? this.applyPromotion,
            applyPromotionData: applyPromotionData ?? this.applyPromotionData,
            promotionNumber: promotionNumber ?? this.promotionNumber,
            sameTime: sameTime ?? this.sameTime,
            manyTime: manyTime ?? this.manyTime,
            limitOrder: limitOrder ?? this.limitOrder,
            priority: priority ?? this.priority,
            beneficiary: beneficiary ?? this.beneficiary,
            beneficiaryType: beneficiaryType ?? this.beneficiaryType,
            district: district ?? this.district,
            variant: variant ?? this.variant,
            variantConsumer: variantConsumer ?? this.variantConsumer,
            variantConsumerData: variantConsumerData ?? this.variantConsumerData,
            variantPromotion: variantPromotion ?? this.variantPromotion,
            promotionType: promotionType ?? this.promotionType,
            promotionTypeData: promotionTypeData ?? this.promotionTypeData,
            status: status ?? this.status,
            statusData: statusData ?? this.statusData,
            company: company ?? this.company,
            system: system ?? this.system,
            promotionItemData: promotionItemData ?? this.promotionItemData,
            userCreated: userCreated ?? this.userCreated,
            userUpdated: userUpdated ?? this.userUpdated,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory PromotionDetailModel.fromJson(Map<String, dynamic> json) => PromotionDetailModel(
        id: json['id'],
        title: json['title'],
        code: json['code'],
        startDate: json['start_date'] == null ? null : DateTime.parse(json['start_date']),
        endDate: json['end_date'] == null ? null : DateTime.parse(json['end_date']),
        description: json['description'],
        attachFiles: json['attach_files'],
        applyPromotion: json['apply_promotion'],
        applyPromotionData: json['apply_promotion_data'],
        promotionNumber: json['promotion_number'],
        sameTime: json['same_time'],
        manyTime: json['many_time'],
        limitOrder: json['limit_order'],
        priority: json['priority'],
        beneficiary: json['beneficiary'] == null ? [] : List<dynamic>.from(json['beneficiary']!.map((x) => x)),
        beneficiaryType: json['beneficiary_type'] == null ? [] : List<dynamic>.from(json['beneficiary_type']!.map((x) => x)),
        district: json['district'] == null ? [] : List<dynamic>.from(json['district']!.map((x) => x)),
        variant: json['variant'] == null ? [] : List<int>.from(json['variant']!.map((x) => x)),
        variantConsumer: json['variant_consumer'],
        variantConsumerData: json['variant_consumer_data'] == null ? null : VariantConsumerData.fromJson(json['variant_consumer_data']),
        variantPromotion: json['variant_promotion'] == null ? [] : List<Variant>.from(json['variant_promotion']!.map((x) => Variant.fromJson(x))),
        promotionType: json['promotion_type'],
        promotionTypeData: json['promotion_type_data'] == null ? null : Data.fromJson(json['promotion_type_data']),
        status: json['status'],
        statusData: json['status_data'] == null ? null : Data.fromJson(json['status_data']),
        company: json['company'],
        system: json['system'],
        promotionItemData: json['promotion_item_data'] == null ? [] : List<PromotionItemDatum>.from(json['promotion_item_data']!.map((x) => PromotionItemDatum.fromJson(x))),
        userCreated: json['user_created'],
        userUpdated: json['user_updated'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'description': description,
        'attach_files': attachFiles,
        'apply_promotion': applyPromotion,
        'apply_promotion_data': applyPromotionData,
        'promotion_number': promotionNumber,
        'same_time': sameTime,
        'many_time': manyTime,
        'priority': priority,
        'beneficiary': beneficiary == null ? [] : List<dynamic>.from(beneficiary!.map((x) => x)),
        'beneficiary_type': beneficiaryType == null ? [] : List<dynamic>.from(beneficiaryType!.map((x) => x)),
        'district': district == null ? [] : List<dynamic>.from(district!.map((x) => x)),
        'variant': variant == null ? [] : List<dynamic>.from(variant!.map((x) => x)),
        'variant_consumer': variantConsumer,
        'variant_consumer_data': variantConsumerData?.toJson(),
        'variant_promotion': variantPromotion == null ? [] : List<dynamic>.from(variantPromotion!.map((x) => x.toJson())),
        'promotion_type': promotionType,
        'promotion_type_data': promotionTypeData?.toJson(),
        'status': status,
        'status_data': statusData?.toJson(),
        'company': company,
        'system': system,
        'promotion_item_data': promotionItemData == null ? [] : List<dynamic>.from(promotionItemData!.map((x) => x.toJson())),
        'user_created': userCreated,
        'user_updated': userUpdated,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
    };
}

class PromotionItemDatum {
    final int? id;
    final double? valueMin;
    final double? valueMax;
    final int? quantity;
    final num? discountValue;
    final dynamic price;
    final int? discountType;
    final List<int>? variantValue;
    final List<VariantValueDatum>? variantValueData;
    final int? promotion;
    final int? promotionValue;
    final PromotionValueData? promotionValueData;
    final DateTime? createdAt;
    final List<GroupVariantItemModel>? groupVariantData;

    PromotionItemDatum({
        this.id,
        this.valueMin,
        this.valueMax,
        this.quantity,
        this.price,
        this.discountType,
        this.discountValue,
        this.variantValue,
        this.variantValueData,
        this.promotion,
        this.promotionValue,
        this.promotionValueData,
        this.createdAt,
        this.groupVariantData,
    });

    PromotionItemDatum copyWith({
        int? id,
        double? valueMin,
        double? valueMax,
        int? quantity,
        dynamic price,
        int? discountType,
        dynamic discountValue,
        List<int>? variantValue,
        List<VariantValueDatum>? variantValueData,
        int? promotion,
        int? promotionValue,
        PromotionValueData? promotionValueData,
        DateTime? createdAt,
        List<GroupVariantItemModel>? groupVariantData,
    }) => 
        PromotionItemDatum(
            id: id ?? this.id,
            valueMin: valueMin ?? this.valueMin,
            valueMax: valueMax ?? this.valueMax,
            quantity: quantity ?? this.quantity,
            price: price ?? this.price,
            discountType: discountType ?? this.discountType,
            discountValue: discountValue ?? this.discountValue,
            variantValue: variantValue ?? this.variantValue,
            variantValueData: variantValueData ?? this.variantValueData,
            promotion: promotion ?? this.promotion,
            promotionValue: promotionValue ?? this.promotionValue,
            promotionValueData: promotionValueData ?? this.promotionValueData,
            createdAt: createdAt ?? this.createdAt,
            groupVariantData: groupVariantData ?? this.groupVariantData,
        );

    factory PromotionItemDatum.fromJson(Map<String, dynamic> json) => PromotionItemDatum(
        id: json['id'],
        valueMin: json['value_min']?.toDouble(),
        valueMax: json['value_max']?.toDouble(),
        quantity: json['quantity'],
        price: json['price'],
        discountType: json['type_discount'],
        discountValue: json['discount_value'],
        variantValue: json['variant_value'] == null ? [] : List<int>.from(json['variant_value']!.map((x) => x)),
        variantValueData: json['variant_value_data'] == null ? [] : List<VariantValueDatum>.from(json['variant_value_data']!.map((x) => VariantValueDatum.fromJson(x))),
        promotion: json['promotion'],
        promotionValue: json['promotion_value'],
        promotionValueData: json['promotion_value_data'] == null ? null : PromotionValueData.fromJson(json['promotion_value_data']),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        groupVariantData: json['group_variant_data'] == null ? [] : List<GroupVariantItemModel>.from(json['group_variant_data']!.map((x) => GroupVariantItemModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'value_min': valueMin,
        'value_max': valueMax,
        'quantity': quantity,
        'price': price,
        'discount_type': discountType,
        'discount_value': discountValue,
        'variant_value': variantValue == null ? [] : List<dynamic>.from(variantValue!.map((x) => x)),
        'variant_value_data': variantValueData == null ? [] : List<dynamic>.from(variantValueData!.map((x) => x.toJson())),
        'promotion': promotion,
        'promotion_value': promotionValue,
        'promotion_value_data': promotionValueData?.toJson(),
        'created_at': createdAt?.toIso8601String(),
    };
}

class GroupVariantItemModel {
    final int? id;
    final int? promotionItem;
    final List<VariantValueDatum>? variantValueData;

    GroupVariantItemModel({
        this.id,
        this.promotionItem,
        this.variantValueData,
    });

    GroupVariantItemModel copyWith({
        int? id,
        int? promotionItem,
        List<VariantValueDatum>? variantValueData,
    }) => 
        GroupVariantItemModel(
            id: id ?? this.id,
            promotionItem: promotionItem ?? this.promotionItem,
            variantValueData: variantValueData ?? this.variantValueData,
        );

    factory GroupVariantItemModel.fromJson(Map<String, dynamic> json) => GroupVariantItemModel(
        id: json["id"],
        promotionItem: json["promotion_item"],
        variantValueData: json["variant_value_data"] == null ? [] : List<VariantValueDatum>.from(json["variant_value_data"]!.map((x) => VariantValueDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "promotion_item": promotionItem,
        "variant_value_data": variantValueData == null ? [] : List<dynamic>.from(variantValueData!.map((x) => x.toJson())),
    };
}

class VariantData {
    final int? id;
    final String? title;
    final String? code;
    final dynamic image;
    final int? priceSell;
    final int? priceImport;

    VariantData({
        this.id,
        this.title,
        this.code,
        this.image,
        this.priceSell,
        this.priceImport,
    });

    VariantData copyWith({
        int? id,
        String? title,
        String? code,
        dynamic image,
        int? priceSell,
        int? priceImport,
    }) => 
        VariantData(
            id: id ?? this.id,
            title: title ?? this.title,
            code: code ?? this.code,
            image: image ?? this.image,
            priceSell: priceSell ?? this.priceSell,
            priceImport: priceImport ?? this.priceImport,
        );

    factory VariantData.fromJson(Map<String, dynamic> json) => VariantData(
        id: json["id"],
        title: json["title"],
        code: json["code"],
        image: json["image"],
        priceSell: json["price_sell"],
        priceImport: json["price_import"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "code": code,
        "image": image,
        "price_sell": priceSell,
        "price_import": priceImport,
    };
}

class PromotionValueData {
    final int? id;
    final String? title;
    final int? promotionType;

    PromotionValueData({
        this.id,
        this.title,
        this.promotionType,
    });

    PromotionValueData copyWith({
        int? id,
        String? title,
        int? promotionType,
    }) => 
        PromotionValueData(
            id: id ?? this.id,
            title: title ?? this.title,
            promotionType: promotionType ?? this.promotionType,
        );

    factory PromotionValueData.fromJson(Map<String, dynamic> json) => PromotionValueData(
        id: json['id'],
        title: json['title'],
        promotionType: json['promotion_type'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'promotion_type': promotionType,
    };
}

class VariantValueDatum {
    final int? id;
    final int? variant;
    final int? quantity;
    final Variant? variantData;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    VariantValueDatum({
        this.id,
        this.variant,
        this.quantity,
        this.variantData,
        this.createdAt,
        this.updatedAt,
    });

    VariantValueDatum copyWith({
        int? id,
        int? variant,
        int? quantity,
        Variant? variantData,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        VariantValueDatum(
            id: id ?? this.id,
            variant: variant ?? this.variant,
            quantity: quantity ?? this.quantity,
            variantData: variantData ?? this.variantData,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory VariantValueDatum.fromJson(Map<String, dynamic> json) => VariantValueDatum(
        id: json['id'],
        variant: json['variant'],
        quantity: json['quantity'],
        variantData: json['variant_data'] == null ? null : Variant.fromJson(json['variant_data']),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'variant': variant,
        'quantity': quantity,
        'variant_data': variantData?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
    };
}

class Variant {
    final int? id;
    final String? title;
    final String? code;
    final String? image;
    final double? priceSell;
    final double? priceImport;

    Variant({
        this.id,
        this.title,
        this.code,
        this.image,
        this.priceSell,
        this.priceImport,
    });

    Variant copyWith({
        int? id,
        String? title,
        String? code,
        String? image,
        double? priceSell,
        double? priceImport,
    }) => 
        Variant(
            id: id ?? this.id,
            title: title ?? this.title,
            code: code ?? this.code,
            image: image ?? this.image,
            priceSell: priceSell ?? this.priceSell,
            priceImport: priceImport ?? this.priceImport,
        );

    factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json['id'],
        title: json['title'],
        code: json['code'],
        image: json['image'],
        priceSell: json['price_sell']?.toDouble(),
        priceImport: json['price_import']?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'image': image,
        'price_sell': priceSell,
        'price_import': priceImport,
    };
}

class Data {
    final int? id;
    final String? title;
    final String? code;

    Data({
        this.id,
        this.title,
        this.code,
    });

    Data copyWith({
        int? id,
        String? title,
        String? code,
    }) => 
        Data(
            id: id ?? this.id,
            title: title ?? this.title,
            code: code ?? this.code,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        title: json['title'],
        code: json['code'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
    };
}

class VariantConsumerData {
    final int? id;
    final int? variant;
    final Variant? variantData;
    final int? quantityBuy;
    final int? quantityBonus;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    VariantConsumerData({
        this.id,
        this.variant,
        this.variantData,
        this.quantityBuy,
        this.quantityBonus,
        this.createdAt,
        this.updatedAt,
    });

    VariantConsumerData copyWith({
        int? id,
        int? variant,
        Variant? variantData,
        int? quantityBuy,
        int? quantityBonus,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        VariantConsumerData(
            id: id ?? this.id,
            variant: variant ?? this.variant,
            variantData: variantData ?? this.variantData,
            quantityBuy: quantityBuy ?? this.quantityBuy,
            quantityBonus: quantityBonus ?? this.quantityBonus,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory VariantConsumerData.fromJson(Map<String, dynamic> json) => VariantConsumerData(
        id: json['id'],
        variant: json['variant'],
        variantData: json['variant_data'] == null ? null : Variant.fromJson(json['variant_data']),
        quantityBuy: json['quantity_buy'],
        quantityBonus: json['quantity_bonus'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'variant': variant,
        'variant_data': variantData?.toJson(),
        'quantity_buy': quantityBuy,
        'quantity_bonus': quantityBonus,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
    };
}
