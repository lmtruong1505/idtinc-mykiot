import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/product_detail_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';
import 'package:pharmago/presentation/features_v2/screens/profile/components/header_item.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../blocs/product/product_shipments_bloc.dart';

class PrdInforTab extends StatelessWidget {
  const PrdInforTab({
    super.key,
    required this.bloc,
    required this.shipmentBloc,
  });
  final ProductDetailBloc bloc;
  final ProductShipmentsBloc shipmentBloc;
  double get stock {
    final units = bloc.model?.product?.unit ?? [];
    return (units
            .firstWhere(
              (element) => element.sellUnit == true,
              orElse: () => units.isNotEmpty
                  ? units.last
                  : UnitV2Model(
                      count: bloc.model?.product?.availableStock,
                    ),
            )
            .stockChange ??
        0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelling = bloc.model?.product?.active ?? false;
    return SingleChildScrollView(
      child: Container(
        padding: 16.pading,
        margin: 16.pading,
        decoration: BoxDecoration(
          borderRadius: 16.radius,
          color: AppColors.bg_primary,
          border: Border.all(
            color: AppColors.border_tertiary,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChipBadgeCustom(
              color: isSelling
                  ? AppColors.ultility_positive_60
                  : AppColors.ultility_gray_60,
              bgColor: isSelling ? null : AppColors.ultility_gray_20,
              title: isSelling ? 'Đang bán' : 'Đã ẩn',
              icon: isSelling
                  ? null
                  : FaIcon(
                      iconCode: 'f070',
                      size: 12,
                      color: AppColors.text_tertiary,
                      type: FaIconType.solid,
                    ),
            ).size(height: 20),
            4.height,
            Text(
              bloc.model?.product?.name ?? '',
              style: AppStyle.bodyBsMedium,
            ),
            8.height,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${bloc.baseUnit?.sellPrice.formatCurrency} đ',
                    style: AppStyle.headingDisplay.copyWith(
                      color: AppColors.text_brand_primary_variant1,
                    ),
                  ),
                  TextSpan(
                    text: ' /${bloc.baseUnit?.name}',
                    style: AppStyle.bodyMdRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                ],
              ),
            ),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'Tồn: ',
            //         style: AppStyle.bodyBsRegular.copyWith(
            //           color: AppColors.text_tertiary,
            //         ),
            //       ),
            //       TextSpan(
            //         text: stock.formatPrice(),
            //         style: AppStyle.bodyBsMedium.copyWith(
            //           color: AppColors.text_secondary,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // 12.height,
            const Divider(
              color: AppColors.border_tertiary,
              thickness: 1.5,
            ),
            12.height,
            _recognition(),
            24.height,
            _legal(),
            24.height,
            _price(context),
            24.height,
            // _warehouse(),
            // 24.height,
            _ingredient(),
            24.height,
            _pharma(),
          ],
        ),
      ),
    );
  }

  Column _recognition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_info.svg'),
          title: 'Thông tin nhận diện',
        ),
        4.height,
        TextRow2(
          title: 'Mã vạch',
          content: bloc.model?.product?.barcode,
        ),
        8.height,
        TextRow2(title: 'Mã sản phẩm', content: bloc.model?.product?.code),
        8.height,
        TextRow2(
          title: 'Thương hiệu',
          content: bloc.model?.product?.brand?.name,
        ),
        8.height,
        TextRow2(title: 'Xuất xứ thương hiệu', content: ''),
        8.height,
        TextRow2(
          title: 'Công ty sản xuất',
          content: bloc.model?.product?.congTySx,
        ),
        8.height,
        TextRow2(
          title: 'Hình thức đóng gói',
          content: bloc.model?.product?.dongGoi,
        ),
        8.height,
        TextRowReadMore(
          title: 'Mô tả',
          content: bloc.model?.product?.description,
        ),
      ],
    );
  }

  Column _legal() {
    return Column(
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_info.svg'),
          title: 'Thông tin pháp lý',
        ),
        4.height,
        TextRow2(
          title: 'Công ty đăng  ký',
          content: bloc.model?.product?.congTyDk,
        ),
        8.height,
        TextRow2(
          title: 'Số đăng ký',
          content: bloc.model?.warehouse.firstOrNull?.soDangKy,
        ),
        8.height,
        TextRow2(
          title: 'Số quyết định',
          content: bloc.model?.warehouse.firstOrNull?.soQuyetDinh,
        ),
        8.height,
        TextRow2(title: 'Tuổi thọ', content: ''),
        8.height,
        TextRow2(title: 'Hình thức bán', content: ''),
      ],
    );
  }

  Column _price(BuildContext context) {
    final bool isEmp = bloc.model?.product?.unit.length == 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_info.svg'),
          title: 'Thông tin đơn giá',
        ),
        if (!isEmp) 24.height,
        if (isEmp) 12.height,
        _buildPriceOv(isEmp, context),
        4.height,
        Column(
          children: List.generate(
            bloc.model?.product?.unit.length ?? 0,
            (index) {
              final unit = bloc.model?.product?.unit[index];
              final bool isBase = unit?.sellUnit ?? false;
              final String text =
                  "${unit?.name}${isBase ? ' (Giá cơ sở)' : ''}";
              return TextRow2(
                title: text,
                content: '${unit?.sellPrice.formatCurrency} đ',
              ).padding(8.padingBottom);
            },
          ),
        ),
      ],
    );
  }

  Stack _buildPriceOv(bool isEmp, BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (!isEmp)
          Container(
            decoration: BoxDecoration(
              color: AppColors.bg_secondary,
              borderRadius: 12.radius,
            ),
            padding: 12.pading.copyWith(top: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bg_secondary,
                  borderRadius: 8.radius,
                  border: Border.all(
                    color: AppColors.border_tertiary,
                    width: 1.5,
                  ),
                ),
                padding: 12.padingHor + 8.padingVer,
                child: Wrap(
                  children: List.generate(
                    (bloc.model?.product?.unit.length ?? 0) - 1,
                    (index) {
                      final unit = bloc.model?.product?.unit[index + 1];
                      final bool isLast =
                          index == (bloc.model?.product?.unit.length ?? 0) - 2;
                      final String text =
                          "${unit?.value} ${unit?.name}${isLast ? '' : ' x '}";
                      return Text(text);
                    },
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: !isEmp ? -12 : null,
          left: !isEmp ? 16 : null,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                padding: 12.padingHor + 8.padingVer,
                width: !isEmp ? null : context.width,
                decoration: BoxDecoration(
                  color: AppColors.bg_secondary,
                  borderRadius: 8.radius,
                ),
                child: Text(
                  "1 ${bloc.model?.product?.unit.firstOrNull?.name ?? ''}",
                  style: AppStyle.bodyBsMedium,
                ),
              ),
              Container(
                height: 16,
                width: 3,
                decoration: BoxDecoration(
                  color: AppColors.border_brandSolid,
                  borderRadius: 8.radiusRight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _warehouse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_info.svg'),
          title: 'Thông tin kho',
        ),
        4.height,
        TextRow2(
          title: 'Mã sản phẩm KAFA',
          content: bloc.model?.product?.kafaCode ?? '',
        ),
        8.height,
        TextRow2(title: 'Tổng nhập', content: ''),
        8.height,
        TextRow2(title: 'Tổng bán', content: ''),
        8.height,
        TextRow2(
          title: 'Tồn kho',
          content: bloc.model?.product?.stockQuantity.formatCurrency,
        ),
      ],
    );
  }

  Column _ingredient() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_info.svg'),
          title: 'Thông tin thành phần',
        ),
        4.height,
        TextRow2(title: 'Khối lượng tịnh', content: ''),
        16.height,
        _buildTableIngre(),
        //16.height,
        // Text(
        //   'Tá dược',
        //   style: StyleApp.normal(),
        // ),
        // ReadMoreText(
        //   'Chưa có thông tin',
        //   trimMode: TrimMode.Line,
        //   trimLines: 1,
        //   textAlign: TextAlign.justify,
        //   isExpandable: true,
        //   trimCollapsedText: 'Xem thêm',
        //   trimExpandedText: 'Ẩn bớt',
        //   colorClickableText: AppColors.button_brand_ghost_textDefault,
        //   style: AppStyle.bodyBsMedium.copyWith(
        //     height: 1.2,
        //   ),
        // ).size(width: context.width),
      ],
    );
  }

  Container _buildTableIngre() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 12.radius,
        border: Border.all(color: AppColors.border_tertiary),
      ),
      child: ClipRRect(
        borderRadius: 12.radius,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Tên thành phần',
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ).expanded(flex: 1),
              ],
            ).padding(12.pading).container(
                  bgColor: AppColors.bg_secondary_subtle,
                  radius: 0,
                  padding: 0.pading,
                ),
            const Divider(
              color: AppColors.border_tertiary,
              height: 0,
              thickness: 1,
            ),
            ...List.generate(
              bloc.model?.ingredients.length ?? 0,
              (index) {
                final ingredient = bloc.model?.ingredients[index];
                final String? w = ingredient?.weight;
                return Row(
                  children: [
                    Text(
                      ingredient?.name ?? '',
                      style: AppStyle.bodyBsMedium.copyWith(
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).container(padding: 12.padingHor).expanded(flex: 1),
                    Text(
                      w ?? ' - ',
                      style: AppStyle.bodyBsMedium.copyWith(
                        height: 1.2,
                      ),
                      textAlign: TextAlign.right,
                    ).expanded(),
                    12.width,
                  ],
                ).container(
                  padding: 20.padingVer,
                  radius: 0,
                  border: const Border(
                    bottom: BorderSide(color: AppColors.border_tertiary),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Column _pharma() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_info.svg'),
          title: 'Thông tin dược lý',
        ),
        4.height,
        TextRow2(
          title: 'Loại sản phẩm',
          content: bloc.model?.product?.type?.name,
        ),
        8.height,
        TextRowReadMore(
          title: 'Danh mục',
          content: bloc.model?.product?.category?.name,
        ),
        8.height,
        TextRowReadMore(
          title: 'Chỉ định',
          content: bloc.model?.product?.chiDinh,
        ),
        8.height,
        TextRowReadMore(
          title: 'Chống chỉ định',
          content: bloc.model?.product?.chongChiDinh,
        ),
        8.height,
        TextRow2(title: 'Dạng bào chế', content: bloc.model?.product?.baoChe),
        8.height,
        TextRowReadMore(
          title: 'Liều dùng và cách dùng',
          content: bloc.model?.product?.lieuDung,
        ),
        8.height,
        TextRowReadMore(
          title: 'Công dụng',
          content: bloc.model?.product?.congDung,
        ),
        8.height,
        TextRowReadMore(
          title: 'Tác dụng phụ',
          content: bloc.model?.product?.tacDungPhu,
        ),
        8.height,
        TextRowReadMore(
          title: 'Tương tác thuốc',
          content: bloc.model?.product?.tuongTac,
        ),
        8.height,
        TextRowReadMore(
          title: 'Lưu ý thận trọng',
          content: bloc.model?.product?.thanTrong,
        ),
        8.height,
        TextRowReadMore(
          title: 'Bảo quản',
          content: bloc.model?.product?.baoQuan,
        ),
      ],
    );
  }
}
