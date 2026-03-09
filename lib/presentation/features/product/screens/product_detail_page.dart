import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/expandable.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/product/cubit/product_detail_cubit/product_detail_state.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../../shared/style_app/init_style.dart';
import '../../../base/app_bar.dart';
import '../../../base/cache_image.dart';
import '../../../constants/size_device.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../../../shared/utils/event.dart';
import '../cubit/product_detail_cubit/product_detail_cubit.dart';
import '../domain/entities/ingredient_entity.dart';
import '../domain/entities/product_entity.dart';
import '../domain/entities/unit_entity.dart';

@RoutePage()
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final myBloc = getIt.get<ProductDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getDetail(widget.id),
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: BaseAppBar(
          title: 'Thông tin sản phẩm',
          actions: [
            _buildMenu(),
          ],
        ),
        body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: BaseLoading(),
              );
            }
            return Container(
              width: widthDevice(context),
              height: heightDevice(context),
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp16,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildInfo(state),
                    gapHeight(sp16),
                    _buildBasicInfo(state.product!),
                    gapHeight(sp16),
                    _buildUnit(state.units),
                    gapHeight(sp16),
                    _buildIngredientProduct(state.ingredients),
                    gapHeight(sp16),
                    _buildExtraInfo(state.product!),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBasicInfo(ProductEntity item) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp8),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: sp4,
          ),
        ],
      ),
      child: Expandable(
        header: 'Thông tin cơ bản',
        child: Column(
          children: [
            RowItem(
                title: 'Mã vạch',
                content: myBloc.state.variants.first.barcode ?? ''),
            gapHeight(sp12),
            RowItem(
              title: 'Số quyết định',
              content: myBloc.state.variants.first.decisionNumber ?? '',
            ),
            gapHeight(sp12),
            RowItem(
                title: 'Số đăng kí',
                content: myBloc.state.variants.first.registerNumber ?? ''),
            gapHeight(sp12),
            RowItem(
                title: 'Tuổi thọ',
                content: myBloc.state.variants.first.longevity ?? ''),
            gapHeight(sp12),
            RowItem(title: 'Mô tả', content: myBloc.state.product?.moTa ?? ''),
            gapHeight(sp12),
            const RowItem(
                title: 'Nguồn tạo sản phẩm', content: 'Chưa có thông tin'),
          ],
        ),
      ),
    );
  }

  Widget _buildUnit(List<UnitEntity> items) {
    final firstItem = items.first;
    final sellPrice = firstItem.sellPrice.validator;
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp8),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: sp4,
          ),
        ],
      ),
      child: Expandable(
        header: 'Đơn vị tính',
        child: items.isEmpty
            ? const EmptyContainer()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final e = items[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RowItem(title: 'Tên đơn vi', content: e.name ?? ''),
                      gapHeight(sp8),
                      RowItem(
                        title: 'Giá bán',
                        content:
                            '${FormatCurrency(sellPrice.validator * e.value.validator)}đ',
                      ),
                      gapHeight(sp8),
                      RowItem(
                          title: 'Trọng lượng',
                          content: e.weight == null || e.weightUnit == null
                              ? ''
                              : '${e.weight} ${e.weightUnit}'),
                      gapHeight(sp8),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: blackColor.withOpacity(0.1),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildIngredientProduct(List<IngredientEntity> items) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp8),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: sp4,
          ),
        ],
      ),
      child: Expandable(
        header: 'Thành phầm sản phẩm',
        child: items.isEmpty
            ? const EmptyContainer()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final e = items[index];
                  return Column(
                    children: [
                      RowItem(title: 'Tên thành phần', content: e.name ?? ''),
                      gapHeight(sp8),
                      RowItem(title: 'Trọng lượng', content: '${e.weight}'),
                      gapHeight(sp8),
                      RowItem(title: 'Mô tả', content: '${e.unit}'),
                    ],
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: blackColor.withOpacity(0.1),
                ),
                itemCount: items.length,
              ),
      ),
    );
  }

  Widget _buildExtraInfo(ProductEntity item) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp8),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: sp4,
          ),
        ],
      ),
      child: Expandable(
        header: 'Thông tin bổ sung',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Liều dùng và cách dùng',
              style: p6,
              textAlign: TextAlign.start,
            ),
            gapHeight(sp6),
            Text(
              item.lieuDung ?? 'Không có',
              style: p5.copyWith(fontWeight: MEDIUM),
            ),
            gapHeight(sp12),
            const Text(
              'Chỉ định',
              style: p6,
              textAlign: TextAlign.start,
            ),
            gapHeight(sp6),
            Text(
              item.chiDinh ?? 'Không có',
              style: p5.copyWith(fontWeight: MEDIUM),
            ),
            gapHeight(sp12),
            const Text(
              'Chống chỉ định',
              style: p6,
              textAlign: TextAlign.start,
            ),
            gapHeight(sp6),
            Text(
              item.chongChiDinh ?? 'Không có',
              style: p5.copyWith(fontWeight: MEDIUM),
            ),
            gapHeight(sp12),
            const Text(
              'Công dụng',
              style: p6,
              textAlign: TextAlign.start,
            ),
            gapHeight(sp6),
            Text(
              item.congDung ?? 'Không có',
              style: p5.copyWith(fontWeight: MEDIUM),
            ),
            gapHeight(sp12),
            const RowItem(title: 'Hình thức', content: 'Thuốc'),
            gapHeight(sp12),
            RowItem(title: 'Tác dụng phụ', content: item.tacDungPhu ?? ''),
            gapHeight(sp12),
            RowItem(title: 'Thận trọng', content: item.thanTrong ?? ''),
            gapHeight(sp12),
            RowItem(
              title: 'Tương tác thuốc',
              content: item.tuongTac ?? '',
            ),
            gapHeight(sp12),
            RowItem(title: 'Bảo quản', content: item.baoQuan ?? ''),
            gapHeight(sp12),
            RowItem(title: 'Đóng gói', content: item.dongGoi ?? ''),
            gapHeight(sp12),
            RowItem(
              title: 'Nơi sản xuất',
              content: item.noiSx ?? '',
            ),
            gapHeight(sp12),
            RowItem(
              title: 'Công ty sản xuất',
              content: item.congTySx ?? '',
            ),
            gapHeight(sp12),
            RowItem(
              title: 'Công ty đăng ký',
              content: item.congTyDk ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(ProductDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp8),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: sp4,
          ),
        ],
      ),
      padding: 16.pading,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: sp48,
                width: sp48,
                child: BaseCacheImage(
                  url: (state.variants.first.media?.isNotEmpty ?? false)
                      ? (state.variants.first.media ??
                          PrefKeys.imgProductDefault)
                      : PrefKeys.imgProductDefault,
                ),
              ),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.product?.name ?? '',
                    style: StyleApp.semibold(),
                  ),
                  4.height,
                  Text(
                    state.product?.code ?? 'Chưa có mã',
                    style: StyleApp.semibold(
                      color: ColorApp.grey79,
                    ),
                  ),
                  4.height,
                  Text(
                    'Tồn kho: ${(state.variants.isNotEmpty) ? state.variants[0].initialInventory ?? 0 : 0} sản phẩm',
                    style: StyleApp.semibold(
                      color: ColorApp.greyA7,
                    ),
                  ),
                ],
              ).expanded(),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.product?.active == true
                      ? ColorApp.green
                      : ColorApp.red,
                ),
              ),
            ],
          ),
          16.height,
          MainButton(
            title: 'Đặt hàng lên NPP',
            event: () {},
          ).size(width: double.infinity),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: Dimensions.sp8.radius,
      ),
      child: Padding(
        padding: Dimensions.sp16.pading,
        child: const Icon(
          Icons.more_vert_rounded,
          color: ColorApp.black,
        ),
      ),
      itemBuilder: (context) {
        return List.generate(
          MenuDetailProd.values.length,
          (index) => PopupMenuItem(
            onTap: () {
              switch (MenuDetailProd.values[index]) {
                case MenuDetailProd.edit:
                  context.router.push(
                    ProductCreateRoute(
                      prod: myBloc.state.productDetail,
                      id: widget.id,
                    ),
                  );
                  break;
                case MenuDetailProd.remove:
                  handeDelete();
                  break;
              }
            },
            child: Text(
              MenuDetailProd.values[index].name,
              textAlign: TextAlign.center,
              style: StyleApp.normal(),
            ),
          ),
        );
      },
    );
  }

  void handeDelete() {
    DialogUtils.showLoadingDialog(context, 'Đang xóa sản phẩm...');
    myBloc.delete(widget.id).then((value) {
      context.pop();
      if (value.code == 200) {
        context.pop();
        DialogUtils.showSuccessDialog(
          context,
          content: 'Xóa sản phẩm thành công',
          barrierDismissible: true,
        );
      } else {
        DialogUtils.showErrorDialog(context, content: 'Xóa sản phẩm thất bại');
      }
    });
  }
}
