import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/cubit/product_manager_cubit/product_manager_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/product_manager_cubit/product_manager_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../shared/components/button/custom_btn.dart';
import '../../../../shared/components/input/app_input.dart';
import '../../../../shared/style_app/color_app.dart';
import '../../../../shared/style_app/dimensions.dart';
import '../../../../shared/style_app/style_text.dart';
import '../domain/entities/product_entity.dart';

@RoutePage()
class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final myBloc = getIt.get<ProductManagerCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductManagerCubit>(
      create: (context) => myBloc,
      child: BlocBuilder<ProductManagerCubit, ProductManagerState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_5,
            appBar: const BaseAppBar(
              title: 'Quản lý sản phẩm',
            ),
            body: Container(
              height: heightDevice(context),
              width: widthDevice(context),
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp24,
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  myBloc.productsILC.onRefresh();
                },
                child: SingleChildScrollView(
                  controller: myBloc.scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          title: 'Tạo sản phẩm',
                          event: () async {
                            await context.router.push(ProductCreateRoute());
                            myBloc.productsILC.onRefresh();
                          },
                        ),
                      ),
                      gapHeight(sp16),
                      _buildFilter(state),
                      16.height,
                      _buildStatus().size(height: sp40),
                      sp16.height,
                      InfiniteList(
                        shrinkWrap: true,
                        getData: (page) async {
                          return myBloc.getProducts(page);
                        },
                        itemBuilder: (context, item, index) {
                          return _buildItem(item);
                        },
                        scrollController: myBloc.scrollController,
                        infiniteListController: myBloc.productsILC,
                        circularProgressIndicator: const BaseLoading(),
                        noItemFoundWidget: const EmptyContainer(),
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

  Widget _buildItem(ProductEntity item) {
    return InkWell(
      onTap: () async {
        await context.router.push(
          ProductDetailRoute(id: item.id ?? 0),
        );
        myBloc.productsILC.onRefresh();
      },
      child: Container(
        padding: const EdgeInsets.all(sp16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(sp12),
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              leading: SizedBox(
                height: sp48,
                width: sp48,
                child: BaseCacheImage(
                  url: (item.image?.isNotEmpty ?? false)
                      ? (item.image?[0] ?? PrefKeys.imgProductDefault)
                      : PrefKeys.imgProductDefault,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    item.name ?? '',
                    style: StyleApp.normal(),
                  ).expanded(),
                  Text(
                    '${FormatCurrency(item.unit?.sellPrice ?? 0)}đ',
                    style: StyleApp.bold(color: green_4),
                  )
                ],
              ),
              subtitle: Text(
                'Còn ${FormatCurrency(item.quantity ?? 0)} sản phẩm',
                style: StyleApp.semibold(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => BtnStatusCount(
        onPressed: () {
          myBloc.selectFilterButton(myBloc.state.listFilter[index]);
        },
        title: myBloc.state.listFilter[index].title,
        isActive: myBloc.state.listFilter[index] == myBloc.state.selectFilter,
        count: _getCount(myBloc.state.listFilter[index].code),
      ),
      separatorBuilder: (context, index) => sp16.width,
      itemCount: myBloc.state.listFilter.length,
    );
  }

  Row _buildFilter(ProductManagerState state) {
    return Row(
      children: [
        Expanded(
          child: AppInputV2(
            hintText: 'Tìm mã, tên sản phẩm',
            borderColor: ColorApp.greyE2,
            backgroundColor: ColorApp.white,
            radius: Dimensions.sp8,
            prefixIcon: const Icon(
              Icons.search,
              color: ColorApp.black,
            ),
            onChanged: (p0) {
              myBloc.searchChange(p0);
            },
            onConfirm: (p0) {},
          ),
        ),
        // Dimensions.sp16.width,
        // GestureDetector(
        //   onTap: () {},
        //   child: Container(
        //     width: 45,
        //     height: 45,
        //     clipBehavior: Clip.antiAlias,
        //     decoration: ShapeDecoration(
        //       color: Colors.white,
        //       shape: RoundedRectangleBorder(
        //         side: const BorderSide(
        //           width: 1,
        //           color: ColorApp.greyE2,
        //         ),
        //         borderRadius: Dimensions.sp8.radius,
        //       ),
        //     ),
        //     child: Center(
        //       child: Image.asset(
        //         Assets.iconsIcSort,
        //         width: 20,
        //         color: ColorApp.greyAA,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  int _getCount(String code) {
    return myBloc.state.productCount.fold(0, (total, e) {
      if (e.code == code) {
        return e.value;
      }
      return total;
    });
  }
}
