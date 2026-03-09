import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/variant_wm_entity.dart';

import '../../../../../data/mapper/base/data_mapper.dart';
import '../../../../shared/utils/check_type_promotion_item.dart';
import '../../domain/entities/promotion_detail_wm_entity.dart';
import '../models/promotion_model.dart';

@injectable
class PromotionDetailMapper
    extends BaseDataMapper<PromotionDetailModel, PromotionDetailEntity> {
  @override
  PromotionDetailEntity mapToEntity(PromotionDetailModel? data) {
    return PromotionDetailEntity(
      id: data?.id,
      title: data?.title,
      code: data?.code,
      sameTime: data?.sameTime,
      manyTime: data?.manyTime,
      applyPromotion: data?.applyPromotion,
      limitOrder: data?.limitOrder,
      // promotionStatusData: PromotionStatusData(
      //   id: data?.s
      // ),
      consumerData: ConsumerDataEntity(
        id: data?.variantConsumerData?.id,
        variantId: data?.variantConsumerData?.variantData?.id,
        variantTitle: data?.variantConsumerData?.variantData?.title,
        variantCode: data?.variantConsumerData?.variantData?.code,
        variantImage: data?.variantConsumerData?.variantData?.image,
        variantPriceSell: data?.variantConsumerData?.variantData?.priceSell,
        quantityBonus: data?.variantConsumerData?.quantityBonus,
        quantityBuy: data?.variantConsumerData?.quantityBuy,
      ),
      promotionTypeData: PromotionTypeData(
        id: data?.promotionTypeData?.id,
        title: data?.promotionTypeData?.title,
        code: data?.promotionTypeData?.code,
      ),
      promotionItemData: (data?.promotionItemData ?? []).map((e) {
        final amountGiftNomal = e.variantValueData?.fold(0, (total, item) {
          if (item.variant == data?.variantConsumerData?.variantData?.id) {
            total += item.quantity ?? 0;
          }
          return total;
        });
        final giftForOneApply =
            (((e.valueMin ?? 0).round() + (amountGiftNomal ?? 0)) /
                    (data?.variantConsumerData?.quantityBuy == 0
                        ? 1
                        : (data?.variantConsumerData?.quantityBuy ?? 1)) *
                    (data?.variantConsumerData?.quantityBonus == 0
                        ? 1
                        : (data?.variantConsumerData?.quantityBonus ?? 0)))
                .floor();

        return PromotionItemDataEntity(
          id: e.id,
          valueMax: e.valueMax,
          valueMin: e.valueMin,
          quantity: e.quantity,
          type: checkType(e),
          typeDiscount: e.discountType,
          discountValue: e.discountValue ?? 0,
          promotionValue: e.promotionValue,
          gifForOneApply: giftForOneApply,
          variantValueData: (e.variantValueData ?? [])
              .map(
                (item) => VariantValueDataEntity(
                  id: item.id,
                  variant: item.variantData?.id,
                  title: item.variantData?.title,
                  code: item.variantData?.code,
                  image: item.variantData?.image,
                  priceSell: item.variantData?.priceSell,
                  priceImport: item.variantData?.priceImport,
                  quantity: item.quantity,
                ),
              )
              .toList(),
          groupVariantData: (e.groupVariantData ?? [])
              .map(
                (item) => GroupVariantItemEntity(
                  id: item.id,
                  promotionId: item.promotionItem,
                  variantValue: item.variantValueData
                      ?.map(
                        (e) => GroupVariantValueEntity(
                          id: e.id,
                          variant: VariantWmEntity.fromJson(
                            e.variantData?.toJson() ?? {},
                          ),
                          quantity: e.quantity,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        );
      }).toList(),
    );
  }
}
