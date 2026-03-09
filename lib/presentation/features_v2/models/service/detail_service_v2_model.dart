part of 'service.dart';

class DetailServiceV2Model {
  int? id;
  String? title;
  String? code;
  String? entity;
  String? description;
  int? company;
  int? vat;
  String? chiDinh;
  String? chongChiDinh;
  String? congDung;
  String? luuY;
  String? tacDungPhu;
  List<ImageServiceModel>? images;
  bool? active;
  List<PriceServiceModel>? prices;
  PriceServiceModel? priceDefault;
  List<ProductV2Model>? products;

  DetailServiceV2Model({
    this.id,
    this.title,
    this.code,
    this.entity,
    this.description,
    this.company,
    this.chiDinh,
    this.chongChiDinh,
    this.congDung,
    this.luuY,
    this.tacDungPhu,
    this.images,
    this.active,
    this.prices,
    this.priceDefault,
    this.products,
    this.vat,
  });

  DetailServiceV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vat = json['vat'].toString().toDouble?.round();
    title = json['title'];
    code = json['code'];
    entity = json['entity'];
    description = json['description'];
    company = json['company'];
    chiDinh = json['chiDinh'];
    chongChiDinh = json['chongChiDinh'];
    congDung = json['congDung'];
    luuY = json['luuY'];
    tacDungPhu = json['tacDungPhu'];
    active = json['active'];
    if (json['images'] != null) {
      images = <ImageServiceModel>[];
      json['images'].forEach((v) {
        images!.add(ImageServiceModel.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      prices = <PriceServiceModel>[];
      json['prices'].forEach((v) {
        prices!.add(PriceServiceModel.fromJson(v));
      });
      final dataPriceDefault =
          prices?.where((element) => element.isDefault == true).toList();

      if (dataPriceDefault?.isNotEmpty == true) {
        priceDefault = dataPriceDefault!.first;
      }
    }
    if (json['products'] != null) {
      products = <ProductV2Model>[];
      json['products'].forEach((v) {
        products!.add(ProductV2Model.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['code'] = code;
    data['entity'] = entity;
    data['description'] = description;
    data['company'] = company;
    data['chiDinh'] = chiDinh;
    data['chongChiDinh'] = chongChiDinh;
    data['congDung'] = congDung;
    data['luuY'] = luuY;
    data['tacDungPhu'] = tacDungPhu;
    data['active'] = active;
    if (images != null) {
      data['images'] = images!.map((v) => v.toMap()).toList();
    }
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageServiceModel {
  String? image;
  int? order;
  ImageServiceModel({
    this.image,
    this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'order': order,
    };
  }

  factory ImageServiceModel.fromJson(Map<String, dynamic> map) {
    return ImageServiceModel(
      image: map['image'],
      order: map['order']?.toInt(),
    );
  }
}
