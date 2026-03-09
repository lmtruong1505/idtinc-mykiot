import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

import '../cubit/brand_list_cubit/brand_list_cubit.dart';
import '../cubit/brand_list_cubit/brand_list_state.dart';
import '../domain/entities/brand_entity.dart';

@RoutePage()
class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  final myBloc = getIt.get<BrandListCubit>();

  final _scrollController = ScrollController();
  final _infiniteListController = InfiniteListController<BrandEntity>.init();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrandListCubit>(
      create: (context) => myBloc,
      child: BlocBuilder<BrandListCubit, BrandListState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_6,
            appBar: BaseAppBar(
              title: 'Thương hiệu',
              actions: [
                const Icon(Icons.search_rounded, size: sp20),
                gapWidth(sp16),
                InkWell(
                  onTap: () => context.navPush(const BrandCreateRoute()).then(
                        (value) => _infiniteListController.onRefresh(),
                      ),
                  child: const Icon(Icons.add_rounded, size: sp24),
                ),
                gapWidth(sp12),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp16,
              ),
              height: heightDevice(context),
              width: widthDevice(context),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    InfiniteList<BrandEntity>(
                      shrinkWrap: true,
                      getData: (page) {
                        return myBloc.getListBrand(page);
                      },
                      itemBuilder: (context, item, index) {
                        return InkWell(
                          onTap: () => context.router.push(
                            BrandDetailRoute(
                              id: item.id ?? 0,
                            ),
                          ).then((value) => _infiniteListController.onRefresh()),
                          child: Container(
                            padding: const EdgeInsets.all(sp16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp12),
                              color: whiteColor,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(sp0),
                                  title: Text(
                                    item.name ?? '',
                                    style: h6.copyWith(color: blackColor),
                                  ),
                                  subtitle: Text(
                                    item.code ?? '',
                                    style: h6.copyWith(color: greyColor),
                                  ),
                                  trailing: InkWell(
                                    onTap: () => context.navPush(
                                      BrandUpdateRoute(
                                        id: item.id ?? 0,
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(sp8),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: borderColor_2),
                                        borderRadius:
                                            BorderRadius.circular(sp8),
                                      ),
                                      child: const Icon(
                                        Icons.mode_edit_outline_outlined,
                                        color: blackColor,
                                      ),
                                    ),
                                  ),
                                ),
                                RowItem(
                                  title: 'Số sản phẩm',
                                  content: item.products.toString(),
                                ),
                                gapHeight(sp8),
                                RowItem(
                                  title: 'Người tạo',
                                  content: item.userCreated ?? '',
                                ),
                                gapHeight(sp8),
                                RowItem(
                                  title: 'Thời gian tạo',
                                  content: item.createdAt != null
                                      ? DateFormat().format(item.createdAt!)
                                      : '',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      scrollController: _scrollController,
                      infiniteListController: _infiniteListController,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
