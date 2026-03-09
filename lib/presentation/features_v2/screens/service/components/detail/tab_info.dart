import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/items/item_price_create.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/items/item_service.dart';
import 'package:pharmago/shared/components/bg/bg_detail.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/label_container.dart';
import '../items/item_read_more_text.dart';

class TabInfoDetailService extends StatefulWidget {
  final DetailServiceV2Model model;
  final List<ServiceTypeV2Model> groupPrices;
  const TabInfoDetailService({
    super.key,
    required this.model,
    required this.groupPrices,
  });

  @override
  State<TabInfoDetailService> createState() => _TabInfoDetailServiceState();
}

class _TabInfoDetailServiceState extends State<TabInfoDetailService> {
  @override
  Widget build(BuildContext context) {
    return BgDetail(child: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: 16.pading + context.padding.bottom.padingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ItemServiceV2(
            isDetail: true,
            item: ServiceV2Model(
              active: widget.model.active,
              title: widget.model.title,
              images: widget.model.images?.map((e) => e.image ?? '').toList(),
              price: PriceService(
                title: widget.model.priceDefault?.priceName?.split(' ').last,
                price: widget.model.priceDefault?.price,
                priceName: widget.model.priceDefault?.priceType,
              ),
            ),
          ).radius(16.radiusTop),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              12.height,
              DividerCustom(),
              24.height,
              _buildBase(),
              24.height,
              _buildPrices(),
              8.height,
              _buildExtra(),
            ],
          ).padding(12.pading),
        ],
      ).container(
        padding: 0.pading,
        radius: 16,
        boxShadow: AppShadows.elevator0,
      ),
    );
  }

  Widget _buildExtra() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabelContainer(title: 'Thông tin bổ sung'),
          12.height,
          ItemReadMoreText(
            title: 'Chống chỉ định',
            description: widget.model.chongChiDinh,
          ),
          8.height,
          rowText(
            title: 'Thời gian thực hiện',
          ),
          8.height,
          ItemReadMoreText(
            title: 'Đối tượng',
            description: widget.model.entity,
          ),
          8.height,
          ItemReadMoreText(
            title: 'Công dụng',
            description: widget.model.congDung,
          ),
          8.height,
          ItemReadMoreText(
            title: 'Tác dụng phụ',
            description: widget.model.tacDungPhu,
          ),
          8.height,
          ItemReadMoreText(
            title: 'Lưu ý thận trọng',
            description: widget.model.luuY,
          ),
        ],
      );

  Widget _buildPrices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelContainer(title: 'Thông tin đơn giá'),
        12.height,
        ...List.generate(
          widget.groupPrices.length,
          (index) {
            if (widget.groupPrices[index].prices.validator.isEmpty) {
              return const SizedBox();
            }

            return ItemPriceCreate(
              isDetail: true,
              item: widget.groupPrices[index],
            ).padding(16.padingBottom);
          },
        ),
      ],
    );
  }

  Widget _buildBase() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabelContainer(
            title: 'Thông tin chung',
          ),
          12.height,
          rowText(
            title: 'Mã dịch vụ',
            content: widget.model.code ?? '',
          ),
          8.height,
          const ItemReadMoreText(
            title: 'Danh mục',
          ),
          8.height,
          ItemReadMoreText(
            title: 'Mô tả',
            description: widget.model.description,
          ),
        ],
      );

  Widget rowText({
    required String title,
    String? content,
  }) =>
      TextRow2(
        title: title,
        content: content,
        crossAxisAlignment: CrossAxisAlignment.start,
        titleStyle: AppStyle.bodyBsRegular.copyWith(
          color: AppColors.text_secondary,
        ),
        contentStyle: content.isEmptyOrNull ? null : AppStyle.bodyBsMedium,
      );
}
