import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_type_entity.dart';

import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../cubit/product_type_list_cubit/product_type_list_cubit.dart';

class BTSChoseProductType extends StatefulWidget {
  const BTSChoseProductType({
    super.key,
    this.productTypeEntity,
    this.onConfirm,
  });

  final ProductTypeEntity? productTypeEntity;
  final Function(ProductTypeEntity? value)? onConfirm;

  @override
  State<BTSChoseProductType> createState() => _BTSChoseProductTypeState();
}

class _BTSChoseProductTypeState extends State<BTSChoseProductType> {
  final _scrollController = ScrollController();
  final _infiniteListController = InfiniteListController<ProductTypeEntity>.init();
  final _productTypeBloc = getIt.get<ProductTypeListCubit>();

  ProductTypeEntity? _productTypeEntity;

  @override
  void initState() {
    super.initState();

    _productTypeEntity = widget.productTypeEntity;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductTypeListCubit>(
      create: (context) => _productTypeBloc,
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
                    'Danh sách loại sản phẩm',
                    style: p3.copyWith(color: blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _productTypeEntity = null;
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
                onChanged: _productTypeBloc.search,
                onConfirm: (p0) => _infiniteListController.onRefresh(),
                backgroundColor: whiteColor,
              ),
              gapHeight(sp16),
              InfiniteList<ProductTypeEntity>(
                shrinkWrap: true,
                getData: (page) async {
                  return _productTypeBloc.getListProductType(page);
                },
                itemBuilder: (context, item, index) => Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp12),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _productTypeEntity = item;
                      });
                      widget.onConfirm?.call(_productTypeEntity);
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
                            visible: _productTypeEntity?.code == item.code,
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
