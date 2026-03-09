import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';

import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../cubit/product_master_data_cubit/product_master_data_cubit.dart';

enum ProductMasterData {
  classify,
  preparationType,
  productionStandard,
}

class BTSMasterDataProduct extends StatefulWidget {
  const BTSMasterDataProduct({
    super.key,
    this.title,
    this.initValue,
    this.onConfirm,
    required this.type,
  });

  final ProductMasterData type;
  final String? title;
  final BasicEntity? initValue;
  final Function(BasicEntity? value)? onConfirm;

  @override
  State<BTSMasterDataProduct> createState() => _BTSMasterDataProductState();
}

class _BTSMasterDataProductState extends State<BTSMasterDataProduct> {
  final _scrollController = ScrollController();
  final _infiniteListController = InfiniteListController<BasicEntity>.init();
  final _myBloc = getIt.get<ProductMasterDataCubit>();

  BasicEntity? _value;

  @override
  void initState() {
    super.initState();

    _value = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductMasterDataCubit>(
      create: (context) => _myBloc,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(sp16),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách ${widget.title}',
                    style: p3.copyWith(color: blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _value = null;
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
                onChanged: _myBloc.search,
                onConfirm: (p0) => _infiniteListController.onRefresh(),
                backgroundColor: whiteColor,
              ),
              gapHeight(sp16),
              InfiniteList<BasicEntity>(
                shrinkWrap: true,
                getData: (page) async {
                  switch (widget.type) {
                    case ProductMasterData.classify:
                      return _myBloc.getListClassify(page);
                    case ProductMasterData.preparationType:
                      return _myBloc.getListPreparationType(page);
                    default:
                      return _myBloc.getListProductionStandard(page);
                  }
                },
                itemBuilder: (context, item, index) => Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp12),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _value = item;
                      });
                      widget.onConfirm?.call(_value);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(sp16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name ?? '',
                                  style: p5.copyWith(color: blackColor),
                                ),
                                gapHeight(sp12),
                                Text(
                                  'Mã: ${item.code}',
                                  style: p6.copyWith(color: greyColor),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _value?.code == item.code,
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
