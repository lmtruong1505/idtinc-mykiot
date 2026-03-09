import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/cache_image.dart';
import '../../../base/check_box.dart';
import '../../../base/infinite_list.dart';
import '../../../base/loading.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../product/cubit/variant_list_cubit/variant_list_cubit.dart';
import '../../product/cubit/variant_list_cubit/variant_list_state.dart';
import '../../product/domain/entities/variant_entity.dart';

class BtsSelectVariant extends StatefulWidget {
  const BtsSelectVariant({
    super.key,
    this.initValue,
    this.onConfirm,
  });

  final List<VariantEntity>? initValue;
  final Function(List<VariantEntity> value)? onConfirm;

  @override
  State<BtsSelectVariant> createState() => _BtsSelectVariantState();
}

class _BtsSelectVariantState extends State<BtsSelectVariant> {
  final myBloc = getIt.get<VariantListCubit>();

  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VariantListCubit>(
      create: (context) => myBloc
        ..init(
          listInit: widget.initValue,
        ),
      child: BlocBuilder<VariantListCubit, VariantListState>(
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
                          widget.onConfirm?.call(state.variantSelected);
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
                  InfiniteList<VariantEntity>(
                    shrinkWrap: true,
                    getData: (page) async {
                      if (page == 0) {
                        myBloc.infiniteListController.itemList = [];
                      }
                      return myBloc.getList(page);
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
                                  url: item.media ?? PrefKeys.imgProductDefault,
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
                              value: state.variantSelected.contains(item),
                              onChanged: (value) => myBloc.selectVariant(item),
                            ),
                          ),
                        ],
                      ),
                    ),
                    scrollController: myBloc.scrollController,
                    infiniteListController: myBloc.infiniteListController,
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
