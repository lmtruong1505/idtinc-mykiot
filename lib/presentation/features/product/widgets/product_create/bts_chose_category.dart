import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/product/domain/entities/category_entity.dart';

import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../cubit/category_list_cubit/category_list_cubit.dart';

class BTSChoseCategory extends StatefulWidget {
  const BTSChoseCategory({
    super.key,
    this.categorySelected,
    this.onConfirm,
  });

  final CategoryEntity? categorySelected;
  final Function(CategoryEntity? value)? onConfirm;

  @override
  State<BTSChoseCategory> createState() => _BTSChoseCategoryState();
}

class _BTSChoseCategoryState extends State<BTSChoseCategory> {
  final _scrollController = ScrollController();
  final _infiniteListController = InfiniteListController<CategoryEntity>.init();
  final _categoryBloc = getIt.get<CategoryListCubit>();

  CategoryEntity? _categoryEntity;

  @override
  void initState() {
    super.initState();

    _categoryEntity = widget.categorySelected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryListCubit>(
      create: (context) => _categoryBloc,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(sp16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách danh mục',
                    style: p3.copyWith(color: blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _categoryEntity = null;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Đặt lại',
                          style: p5.copyWith(color: blue_1),
                        ),
                        gapWidth(sp8),
                        const Icon(
                          Icons.refresh_rounded,
                          color: blue_1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gapHeight(sp16),
              AppInputSupport(
                hintText: 'Tìm kiếm theo tên/mã',
                prefixIcon: const Icon(Icons.search_rounded),
                onChanged: _categoryBloc.search,
                onConfirm: (p0) => _infiniteListController.onRefresh(),
                backgroundColor: whiteColor,
              ),
              gapHeight(sp16),
              InfiniteList<CategoryEntity>(
                shrinkWrap: true,
                getData: (page) async {
                  return _categoryBloc.getList(page);
                },
                itemBuilder: (context, item, index) => Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp12),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _categoryEntity = item;
                      });
                      widget.onConfirm?.call(_categoryEntity);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(sp16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name ?? '',
                                style: p5.copyWith(color: blackColor),
                              ),
                              gapHeight(sp12),
                              Text(
                                'Mã thương hiệu: ${item.code}',
                                style: p6.copyWith(color: greyColor),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: _categoryEntity?.code == item.code,
                            child: const Icon(
                              Icons.check_circle_outline_rounded,
                              color: mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                scrollController: _scrollController,
                infiniteListController: _infiniteListController,
                noItemFoundWidget: const EmptyContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
