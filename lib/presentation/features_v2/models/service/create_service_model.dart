part of 'service.dart';

class CreateServiceV2Model {
  BaseSeviceModel? baseService;
  List<PriceServiceModel>? prices;
  ExtraServiceModel? additional;
  List<MapEntry<int, XFile>>? images;
  List<int>? products;
  List<int>? indexRemove;
  CreateServiceV2Model({
    required this.baseService,
    required this.prices,
    this.additional,
    this.images,
    this.products,
    this.indexRemove,
  });

  Map<String, dynamic> toMap() {
    final baseParam = baseService?.toMap();
    baseParam?.removeWhere(
      (key, value) => value == '' || value == null,
    );
    return {
      'company': getCompanyId,
      'base': baseService?.toMap(),
      'prices': prices?.map((x) => x.toJson()).toList(),
      'additional': additional?.toMap(),
      'image_delete': indexRemove?.join(','),
      'images': images
          ?.map(
            (e) => MultipartFile.fromFileSync(e.value.path),
          )
          .toList(),
      'products': products?.join(','),
    };
  }
}

class BaseSeviceModel {
  String? title;
  String? code;
  String? description;
  String? type;
  int? vat;
  bool? active;
  BaseSeviceModel({
    required this.title,
    this.code,
    this.description,
    this.type,
    this.vat,
    this.active = true,
  });

  Map<String, dynamic> toMap() {
    final json = {
      'title': title,
      'code': code,
      'description': description,
      'type': type,
      'vat': vat,
      'active': active,
    };

    json.removeWhere((key, value) => value == null || value == '');
    return json;
  }
}

class ExtraServiceModel {
  String? entity;
  String? chiDinh;
  String? chongChiDinh;
  String? congDung;
  String? luuY;
  String? tacDungPhu;
  ExtraServiceModel({
    this.entity,
    this.chiDinh,
    this.chongChiDinh,
    this.congDung,
    this.luuY,
    this.tacDungPhu,
  });

  Map<String, dynamic> toMap() {
    final json = {
      'entity': entity,
      'chiDinh': chiDinh,
      'chongChiDinh': chongChiDinh,
      'congDung': congDung,
      'luuY': luuY,
      'tacDungPhu': tacDungPhu,
    };
    json.removeWhere((key, value) => value == null || value == '');
    return json;
  }
}
