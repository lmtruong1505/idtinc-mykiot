import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/cubit/variant_list_cubit/variant_list_cubit.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../../../base/dialog.dart';
import '../../../constants/spacing.dart';
import '../cubit/brand_detail_cubit/brand_detail_cubit.dart';
import '../cubit/brand_detail_cubit/brand_detail_state.dart';
import '../cubit/variant_list_cubit/variant_list_state.dart';

@RoutePage()
class BrandDetailPage extends StatefulWidget {
  const BrandDetailPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<BrandDetailPage> createState() => _BrandDetailPageState();
}

class _BrandDetailPageState extends State<BrandDetailPage> {
  final myBloc = getIt.get<BrandDetailCubit>();
  final variantCubit = getIt.get<VariantListCubit>();

  final _scrollController = ScrollController();
  final _infiniteListController = InfiniteListController<VariantEntity>.init();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrandDetailCubit>(
      create: (context) => myBloc..init(widget.id),
      child: BlocBuilder<BrandDetailCubit, BrandDetailState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: bg_6,
              appBar: BaseAppBar(
                title: 'Chi tiết thương hiệu',
                actions: [
                  InkWell(
                    onTap: () {
                      context.navPush(BrandUpdateRoute(id: widget.id));
                    },
                    child: const Icon(Icons.edit_outlined, size: sp20),
                  ),
                  gapWidth(sp16),
                  InkWell(
                    onTap: _deleteHandle,
                    child: const Icon(Icons.delete_outlined, size: sp24),
                  ),
                  gapWidth(sp12),
                ],
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp24,
                  horizontal: sp16,
                ),
                width: widthDevice(context),
                height: heightDevice(context),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(sp16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(sp12),
                          color: whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.brand?.name ?? '',
                              style: h6.copyWith(color: blackColor),
                            ),
                            gapHeight(sp8),
                            Text(
                              state.brand?.code ?? '',
                              style: h6.copyWith(color: greyColor),
                            ),
                            gapHeight(sp8),
                            Text(
                              state.brand?.description ?? 'Chưa có mô tả',
                              style: p6.copyWith(color: greyColor),
                            ),
                            gapHeight(sp8),
                            RowItem(
                              title: 'Người tạo',
                              content: state.brand?.userCreated ?? '',
                            ),
                            gapHeight(sp8),
                            RowItem(
                              title: 'Thời gian tạo',
                              content: state.brand?.updatedAt != null
                                  ? DateFormat('H:m d/MM/y')
                                      .format(state.brand!.createdAt!)
                                  : '',
                            ),
                            gapHeight(sp8),
                            RowItem(
                              title: 'Người cập nhật',
                              content: state.brand?.userUpdated ?? '',
                            ),
                            gapHeight(sp8),
                            RowItem(
                              title: 'Thời gian cập nhật',
                              content: state.brand?.updatedAt != null
                                  ? DateFormat('H:m d/MM/y')
                                      .format(state.brand!.updatedAt!)
                                  : '',
                            ),
                          ],
                        ),
                      ),
                      gapHeight(sp16),
                      Text(
                        'Sản phẩm được gán',
                        style: p5.copyWith(
                          color: blackColor,
                        ),
                      ),
                      gapHeight(sp16),
                      BlocBuilder<VariantListCubit, VariantListState>(
                        bloc: variantCubit,
                        builder: (context, state) {
                          return AppInputSupport(
                            hintText: 'Tìm kiếm sản phẩm',
                            backgroundColor: whiteColor,
                            prefixIcon: const Icon(Icons.search_rounded),
                            maxLines: 1,
                            onChanged: variantCubit.searchChange,
                          );
                        },
                      ),
                      gapHeight(sp12),
                      BlocBuilder<VariantListCubit, VariantListState>(
                        bloc: variantCubit,
                        builder: (context, state) =>
                            InfiniteList<VariantEntity>(
                          shrinkWrap: true,
                          getData: (page) {
                            return variantCubit.getList(page);
                          },
                          itemBuilder: (context, item, index) {
                            return Container(
                              padding: const EdgeInsets.all(sp16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(sp12),
                                color: whiteColor,
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(sp0),
                                    leading: SizedBox(
                                      height: sp48,
                                      width: sp48,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(sp8),
                                        child: BaseCacheImage(
                                          url: item.media ??
                                              PrefKeys.imgProductDefault,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      item.name ?? '',
                                      style: h6.copyWith(color: blackColor),
                                    ),
                                    subtitle: Text(
                                      item.code ?? '',
                                      style: p5.copyWith(color: greyColor),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          scrollController: _scrollController,
                          infiniteListController: _infiniteListController,
                          noItemFoundWidget: const EmptyContainer(),
                          circularProgressIndicator: const BaseLoading(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteHandle() {
    DialogUtils.showLoadingDialog(context, 'Đang xoá thương hiệu');
    myBloc.delete(widget.id).then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        context.router.popUntil(
          (route) => route.settings.name == 'BrandRoute',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: red_1,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Xoá thương hiệu thành công',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Xoá thương hiệu thất bại\n${value.message}',
        );
      }
    });
  }
}
