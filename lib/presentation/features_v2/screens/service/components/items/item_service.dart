import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features_v2/blocs/service/bloc_index.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../config/app_style/init_app_style.dart';
import '../../../../models/service/service.dart';

class ItemServiceV2 extends StatelessWidget {
  final ServiceV2Model item;
  final bool isDetail;

  const ItemServiceV2({
    super.key,
    required this.item,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    print(item.images);
    return BlocBuilder<ServiceTypeBloc, CubitState>(
      builder: (context, state) {
        final priceName =
            servicePriceName(context, item.price?.priceName ?? '');
        return Row(
          children: [
            BaseCacheImage(
              url: item.images.validator.isEmpty ? '' : item.images!.first,
              width: 64,
              height: 64,
              borderRadius: 4.radius,
            ),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ChipBadgeCustom(
                      color: item.active == true
                          ? AppColors.ultility_positive_60
                          : AppColors.ultility_negative_60,
                      title:
                          item.active == true ? 'Hoạt động' : 'Không hoạt động',
                    ),
                    const Spacer(),
                    if (!isDetail)
                      const Icon(
                        Icons.arrow_outward_sharp,
                        size: 16,
                        color: AppColors.fg_quaternary,
                      ),
                  ],
                ),
                Text(
                  item.title ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodyBsMedium.copyWith(
                    height: 1.5,
                  ),
                ),
                if (item.price != null) 8.height,
                if (item.price != null)
                  RichText(
                    text: TextSpan(
                      text: item.price?.price.formatPrice(type: ' đ'),
                      style: AppStyle.bodyBsMedium.copyWith(
                        color: AppColors.text_secondary,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '/${priceName.toLowerCase().replaceAll('vé ', '').replaceAll('gói ', '')}',
                          style: AppStyle.bodyBsRegular.copyWith(
                            color: AppColors.text_tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ).expanded(),
          ],
        );
      },
    ).container(padding: 12.pading);
  }
}
