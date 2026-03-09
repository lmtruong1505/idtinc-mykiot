import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/constants/pref_key.dart';
import '../base/cache_image.dart';
import '../base/check_box.dart';
import '../base/infinite_list.dart';
import '../base/loading.dart';
import '../base/text_field.dart';
import '../constants/colors.dart';
import '../constants/size_device.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';
import '../di/di.dart';
import '../features/product/cubit/product_manager_cubit/product_manager_cubit.dart';
import '../features/product/cubit/product_manager_cubit/product_manager_state.dart';
import '../features/product/domain/entities/product_entity.dart';

class BtsSelectProduct extends StatefulWidget {
  const BtsSelectProduct({
    super.key,
    this.initValue,
    this.onConfirm,
  });

  final List<ProductEntity>? initValue;
  final Function(List<ProductEntity> value)? onConfirm;

  @override
  State<BtsSelectProduct> createState() => _BtsSelectProductState();
}

class _BtsSelectProductState extends State<BtsSelectProduct> {
  final myBloc = getIt.get<ProductManagerCubit>();

  final search = TextEditingController();
  var list = <ProductEntity>[];

  @override
  void initState() {
    super.initState();

    list = List<ProductEntity>.from(widget.initValue ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductManagerCubit>(
      create: (context) => myBloc,
      child: BlocBuilder<ProductManagerCubit, ProductManagerState>(
        builder: (context, state) {
          if (search.text != state.search) {
            search.text = state.search;
          }

          return Container(
            padding: const EdgeInsets.all(sp16),
            width: widthDevice(context),
            height: heightDevice(context) * 0.9,
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  sp12,
                ),
              ),
            ),
            child: SingleChildScrollView(
              controller: myBloc.scrollController,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Huỷ',
                          style: p5.copyWith(color: borderColor_4),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onConfirm?.call(list);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Xác nhận',
                          style: p5.copyWith(color: blue_1),
                        ),
                      ),
                    ],
                  ),
                  gapHeight(sp16),
                  AppInputSupport(
                    controller: search,
                    hintText: 'Tìm kiếm sản phẩm',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                    ),
                    onChanged: myBloc.searchChange,
                    suffixIcon: Visibility(
                      visible: state.search.isNotEmpty,
                      child: InkWell(
                        onTap: () => myBloc.searchChange(''),
                        child: const Icon(
                          Icons.close_rounded,
                        ),
                      ),
                    ),
                  ),
                  gapHeight(sp16),
                  InfiniteList<ProductEntity>(
                    shrinkWrap: true,
                    getData: (page) async {
                      if (page == 0) {
                        myBloc.productsILC.itemList = [];
                      }
                      return myBloc.getProducts(page);
                    },
                    itemBuilder: (context, item, index) => Container(
                      padding: const EdgeInsets.all(sp16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp12),
                        color: bg_4,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: SizedBox(
                              height: sp48,
                              width: sp48,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(sp8),
                                child: BaseCacheImage(
                                  url: (item.image?.isNotEmpty ?? false) ? item.image![0] : PrefKeys.imgProductDefault,
                                ),
                              ),
                            ),
                            title: Text(
                              item.name ?? 'Chưa có dữ liệu',
                              style: p5.copyWith(color: blackColor),
                            ),
                            subtitle: Text(
                              item.code ?? 'Chưa có dữ liệu',
                              style: p6.copyWith(color: greyColor),
                            ),
                            trailing: BaseCheckbox(
                              value: list.contains(item),
                              onChanged: (value) {
                                setState(() {
                                  if (list.contains(item)) {
                                    list.remove(item);
                                    return;
                                  }
                                  list.add(item);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    scrollController: myBloc.scrollController,
                    infiniteListController: myBloc.productsILC,
                    circularProgressIndicator: const BaseLoading(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
