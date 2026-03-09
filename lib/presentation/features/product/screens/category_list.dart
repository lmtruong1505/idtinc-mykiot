import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/cubit/category_list_cubit/category_list_cubit.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

import '../../../base/app_bar.dart';
import '../../../base/infinite_list.dart';
import '../../../base/row_item.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../domain/entities/category_entity.dart';

@RoutePage()
class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final myBloc = getIt.get<CategoryListCubit>();

  final _infiniteListController = InfiniteListController<CategoryEntity>.init();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryListCubit>(
      create: (context) => myBloc,
      child: Scaffold(
        backgroundColor: bg_6,
        appBar: BaseAppBar(
          title: 'Danh mục',
          actions: [
            const Icon(Icons.search_rounded, size: sp20),
            gapWidth(sp16),
            InkWell(
              onTap: () => context.navPush(const CategoryCreateRoute()),
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
          child: Column(
            children: [
              Expanded(
                child: InfiniteList<CategoryEntity>(
                  physics: const BouncingScrollPhysics(),
                  getData: (page) {
                    return myBloc.getList(page);
                  },
                  itemBuilder: (context, item, index) {
                    return InkWell(
                      onTap: () => null,
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
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(sp8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: borderColor_2),
                                    borderRadius: BorderRadius.circular(sp8),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
