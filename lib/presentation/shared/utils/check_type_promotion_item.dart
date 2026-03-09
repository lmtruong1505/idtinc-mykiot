import '../../features/wholesale_medicine/data/models/promotion_model.dart';
import '../../features/wholesale_medicine/domain/entities/promotion_detail_wm_entity.dart';

TypePromotionItem? checkType(PromotionItemDatum item) {
  if (item.discountType == null && (item.groupVariantData?.isNotEmpty ?? false)) {
    return TypePromotionItem.groupPackageVariant;
  } else if (item.discountType == null && (item.groupVariantData?.isEmpty ?? false)) {
    return TypePromotionItem.groupVariant;
  } else if (item.discountType != null) {
    return TypePromotionItem.discountTicket;
  }
  return null;
} 