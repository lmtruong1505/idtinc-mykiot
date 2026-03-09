import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';

import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../cubit/product_master_data_cubit/product_master_data_cubit.dart';
import '../../domain/entities/company_pharma_entity.dart';

enum TypeCompanyPharma {
  production(code: 'PRODUCTION'),
  registered(code: 'REGISTERED');

  final String code;
  const TypeCompanyPharma({required this.code});
}

class BTSChoseCompanyPharma extends StatefulWidget {
  const BTSChoseCompanyPharma({
    super.key,
    this.initData,
    this.onConfirm,
    required this.type,
  });

  final CompanyPharmaEntity? initData;
  final Function(CompanyPharmaEntity? value)? onConfirm;
  final TypeCompanyPharma type;

  @override
  State<BTSChoseCompanyPharma> createState() => _BTSChoseCompanyPharmaState();
}

class _BTSChoseCompanyPharmaState extends State<BTSChoseCompanyPharma> {
  final _scrollController = ScrollController();
  final _infiniteListController =
      InfiniteListController<CompanyPharmaEntity>.init();
  final _myBloc = getIt.get<ProductMasterDataCubit>();

  CompanyPharmaEntity? _data;

  @override
  void initState() {
    super.initState();

    _data = widget.initData;
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
                    'Danh sách công ty',
                    style: p3.copyWith(color: blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _data = null;
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
              InfiniteList<CompanyPharmaEntity>(
                shrinkWrap: true,
                getData: (page) async {
                  return _myBloc.getListCompanyPharma(
                    page,
                    widget.type.code,
                  );
                },
                itemBuilder: (context, item, index) => Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp12),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _data = item;
                      });
                      widget.onConfirm?.call(_data);
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
                                  item.name ?? 'Chưa có thông tin',
                                  style: p5.copyWith(color: blackColor),
                                ),
                                gapHeight(sp12),
                                Text(
                                  'Mã công ty: ${item.code ?? 'Chưa có thông tin'}',
                                  style: p6.copyWith(color: greyColor),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _data?.id == item.id,
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
