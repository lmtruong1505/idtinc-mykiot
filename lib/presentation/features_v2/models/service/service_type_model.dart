part of 'service.dart';

// ignore: must_be_immutable
class ServiceTypeV2Model extends Equatable {
  String? type;
  String? title;
  String? description;
  List<ServiceTypeV2Model>? choices;
  List<PriceTypeService>? prices;

  ServiceTypeV2Model({
    this.type,
    this.title,
    this.description,
    this.choices,
    this.prices,
  });

  static List<ServiceTypeV2Model> mapListPrice(
    List<ServiceTypeV2Model> types,
    List<PriceServiceModel> data,
  ) {
    final List<ServiceTypeV2Model> groupPrices = [];
    for (final type in types) {
      final prices = data.where((p) => p.type == type.type).toList();
      type.prices = prices.map((e) {
        return PriceTypeService(
          id: e.id,
          isActive: e.isDefault == true,
          price: e.price ?? 0,
          count: e.totalSession,
          isLimit: e.totalSession.validator > 0,
          priceName: e.priceName,
          valueName:
              e.priceName?.replaceAll('Vé ', '').replaceAll('Gói ', '') ??
                  'lượt',
          type: ServiceTypeV2Model(
            type: e.priceType,
          ),
        );
      }).toList();
      groupPrices.add(type);
    }
    groupPrices.removeWhere(
      (element) => element.prices?.isEmpty == true,
    );
    return groupPrices;
  }

  ServiceTypeV2Model.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    description = json['description'];
    prices = [];
    if (json['choices'] != null) {
      choices = <ServiceTypeV2Model>[];
      json['choices'].forEach((v) {
        choices!.add(ServiceTypeV2Model.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    data['description'] = description;
    if (choices != null) {
      data['choices'] = choices!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  ServiceTypeV2Model copyWith({
    List<PriceTypeService>? prices,
  }) {
    this.prices = prices ?? this.prices;
    return this;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [type];
}

class PriceTypeService {
  bool isActive;
  int price;
  String? priceName;
  int? count;
  bool? isLimit;
  String valueName;
  ServiceTypeV2Model? type;
  int? id;

  PriceTypeService({
    this.isActive = false,
    this.price = 0,
    this.valueName = 'lượt',
    this.priceName,
    this.count,
    this.isLimit,
    this.type,
    this.id,
  });

  PriceTypeService copyWith({
    bool? isActive,
    int? price,
    String? priceName,
    int? count,
    bool? isLimit,
    String? valueName,
    int? id,
    ServiceTypeV2Model? type,
  }) {
    return PriceTypeService(
      isActive: isActive ?? this.isActive,
      price: price ?? this.price,
      priceName: priceName ?? this.priceName,
      count: count ?? this.count,
      isLimit: isLimit ?? this.isLimit,
      valueName: valueName ?? this.valueName,
      type: type ?? this.type,
      id: id ?? this.id,
    );
  }
}

String servicePriceName(BuildContext context, String code) {
  final List<ServiceTypeV2Model> types = [];
  final list = context.read<ServiceTypeBloc>().list;
  for (final element in list) {
    types.addAll(element.choices ?? []);
  }
  final data = types
      .where(
        (element) => element.type == code,
      )
      .toList();
  final priceName = data.isEmpty ? 'lượt' : data.first.title ?? 'lượt';
  return priceName;
}
