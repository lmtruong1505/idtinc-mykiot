import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/product/domain/entities/brand_entity.dart';

import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../cubit/brand_list_cubit/brand_list_cubit.dart';

class BTSChoseBrand extends StatefulWidget {
  const BTSChoseBrand({
    super.key,
    this.brandSelected,
    this.onConfirm,
  });

  final BrandEntity? brandSelected;
  final Function(BrandEntity? value)? onConfirm;

  @override
  State<BTSChoseBrand> createState() => _BTSChoseBrandState();
}

class _BTSChoseBrandState extends State<BTSChoseBrand> {
  final _scrollController = ScrollController();
  final _infiniteListController = InfiniteListController<BrandEntity>.init();
  final _brandBloc = getIt.get<BrandListCubit>();

  BrandEntity? _brandEntity;

  @override
  void initState() {
    super.initState();

    _brandEntity = widget.brandSelected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrandListCubit>(
      create: (context) => _brandBloc,
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
                    'Danh sách thương hiệu',
                    style: p3.copyWith(color: blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _brandEntity = null;
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
                onChanged: _brandBloc.search,
                onConfirm: (p0) => _infiniteListController.onRefresh(),
                backgroundColor: whiteColor,
              ),
              gapHeight(sp16),
              InfiniteList<BrandEntity>(
                shrinkWrap: true,
                getData: (page) async {
                  return _brandBloc.getListBrand(page);
                },
                itemBuilder: (context, item, index) => Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp12),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _brandEntity = item;
                      });
                      widget.onConfirm?.call(_brandEntity);
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
                            visible: _brandEntity?.code == item.code,
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
