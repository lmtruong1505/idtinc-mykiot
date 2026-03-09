import 'package:injectable/injectable.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../domain/entities/promotion_item_wm_entity.dart';
import '../../domain/entities/variant_wm_entity.dart';
import '../models/variant_wm_model.dart';

@injectable
class VariantWmMapper extends BaseDataMapper<VariantWmModel, VariantWmEntity> {
  @override
  VariantWmEntity mapToEntity(VariantWmModel? data) {
    final PromotionItemModel? promotion =
        (data?.promotionItemSystem?.isNotEmpty ?? false)
            ? data?.promotionItemSystem![0]
            : null;

    return VariantWmEntity(
      image: (data?.image?.isEmpty ?? true) ? null : data?.image,
      title: data?.title ?? '',
      code: data?.code ?? '',
      amount: 0,
      priceSellDefault: data?.priceSellUnit?.round() ?? 0,
      priceSell: data?.priceSellUnit?.round() ?? 0,
      // promotion?.typeDiscount == 1
      //     ? ((data?.priceSell ?? 0) - (promotion?.discount ?? 0)).round()
      //     : ((data?.priceSell ?? 0) * (100 - (promotion?.discount ?? 0)) / 100)
      //         .round(), // data?.priceSell!.round() ?? 0,
      priceSellUnit: (data?.priceSellUnit ?? 0).round(),
      id: data?.id,
      inventory: (data?.quantityInStock ?? 0.0).round(),
      // optionsData: (data?.optionsData ?? [])
      //     .map(
      //       (e) => OptionDataEntity(
      //         id: e.id ?? 0,
      //         title: e.title ?? '',
      //         code: e.code,
      //         values: e.values ?? '',
      //         status: e.status ?? false,
      //       ),
      //     )
      //     .toList(),
      promotionItem: (data?.promotionItemData?.isNotEmpty ?? false)
          ? PromotionItemEntity(
              promotion: promotion?.promotion ?? 0,
              discount: (promotion?.discount ?? 0).toDouble(),
              quantity: promotion?.quantity ?? 0,
              typeDiscount: promotion?.typeDiscount ?? 0,
            )
          : null,
      // pricePolicy: PricePolicyEntity(
      //   priceList: (data?.pricePolicy?.priceList ?? [])
      //       .map(
      //         (e) => PriceListEntity(
      //           code: e.code,
      //           price: e.price,
      //           title: e.title,
      //         ),
      //       )
      //       .toList(),
      // ),
    );
  }
}
