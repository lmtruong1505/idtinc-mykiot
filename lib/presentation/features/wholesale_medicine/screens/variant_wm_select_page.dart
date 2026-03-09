import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/variant_wm_entity.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/app_bar.dart';
import '../../../base/cache_image.dart';
import '../../../base/check_box.dart';
import '../../../base/empty_container.dart';
import '../../../base/infinite_list.dart';
import '../../../base/loading.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../shared/utils/event.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_cubit.dart';

@RoutePage()
class SelectVariantPage extends StatefulWidget {
  const SelectVariantPage({
    super.key,
    required this.dataInit,
    this.onConfirm,
    required this.bloc,
  });

  final List<VariantWmEntity> dataInit;
  final Function(List<VariantWmEntity> value)? onConfirm;
  final OrderWmCreateCubit bloc;

  @override
  State<SelectVariantPage> createState() => _SelectVariantPageState();
}

class _SelectVariantPageState extends State<SelectVariantPage> {
  List<VariantWmEntity> listVariantSelected = [];

  @override
  void initState() {
    super.initState();

    listVariantSelected = List<VariantWmEntity>.from(widget.dataInit);
  }

  @override
  void deactivate() {
    super.deactivate();

    widget.bloc.searchKeyChange('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_4,
      appBar: const BaseAppBar(
        title: 'Chọn sản phẩm',
      ),
      body: Container(
        height: heightDevice(context),
        width: widthDevice(context),
        padding: const EdgeInsets.symmetric(
          vertical: sp24,
          horizontal: sp16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppInput(
                    hintText: 'Tìm tên, mã sản phẩm',
                    validate: (value) {},
                    prefixIcon: const Icon(Icons.search_rounded),
                    backgroundColor: whiteColor,
                    onChanged: (value) => widget.bloc.searchKeyChange(value),
                  ),
                ),
                const SizedBox(width: sp16),
              ],
            ),
            const SizedBox(height: sp24),
            Expanded(
              child: InfiniteList(
                physics: const BouncingScrollPhysics(),
                getData: (page) => widget.bloc.getListVariant(page),
                itemBuilder: (context, item, index) => Container(
                  width: widthDevice(context),
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.1),
                        offset: const Offset(0, 1),
                        blurRadius: sp4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      BaseCheckbox(
                        value: listVariantSelected
                            .map((e) => e.id)
                            .contains(item.id),
                        onChanged: (_) => _checkBoxHandle(item),
                      ),
                      const SizedBox(width: sp16),
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(sp0),
                          leading: Container(
                            width: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp8),
                              border: Border.all(color: borderColor_2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(sp8),
                              child: Image.network(
                                item.image ?? PrefKeys.imgProductDefault,
                              ),
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: p5.copyWith(color: blackColor),
                          ),
                          subtitle: Text(
                            '${FormatCurrency(item.priceSellDefault)}đ',
                            style: p5.copyWith(color: mainColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                scrollController: widget.bloc.scrollController,
                infiniteListController: widget.bloc.infiniteListController,
                circularProgressIndicator: const BaseLoading(),
                noItemFoundWidget: const EmptyContainer(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
        color: whiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${listVariantSelected.length} sản phẩm đã chọn',
                  style: p4.copyWith(color: blackColor),
                ),
                InkWell(
                  onTap: _menuHandle,
                  child: const Icon(
                    Icons.menu_rounded,
                    color: borderColor_4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: sp16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: ExtraButton(
                    title: 'Quay lại',
                    event: () => context.router.pop(),
                    borderColor: borderColor_2,
                    largeButton: true,
                    icon: null,
                  ),
                ),
                const SizedBox(width: sp16),
                Expanded(
                  flex: 1,
                  child: MainButton(
                    title: 'Xác nhận',
                    event: _confirmHandle,
                    largeButton: true,
                    icon: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _checkBoxHandle(VariantWmEntity item) {
    final checked = listVariantSelected.map((e) => e.id).contains(item.id);
    setState(() {
      if (checked) {
        listVariantSelected.removeWhere((e) => e.id == item.id);
      } else {
        listVariantSelected.add(item);
      }
    });
  }

  void _menuHandle() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(sp16),
        width: widthDevice(context),
        height: heightDevice(context) * 0.7,
        color: whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${listVariantSelected.length} Đã chọn',
              style: p5,
            ),
            const SizedBox(height: sp16),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final variant = listVariantSelected[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(sp0),
                    minVerticalPadding: 0,
                    leading: Container(
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp8),
                        border: Border.all(color: borderColor_2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(sp8),
                        child: BaseCacheImage(
                          url: variant.image ?? '',
                        ),
                      ),
                    ),
                    title: Text(
                      variant.title,
                      style: p5.copyWith(color: blackColor),
                    ),
                    subtitle: Text(
                      '${FormatCurrency(variant.priceSell)}đ',
                      style: p5.copyWith(color: mainColor),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        setState(() {
                          listVariantSelected.removeAt(index);
                        });
                        Navigator.of(context).pop();
                        _menuHandle();
                      },
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: greyColor,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 0),
                itemCount: listVariantSelected.length,
              ),
            ),
            const SizedBox(height: sp16),
            Container(
              width: double.infinity,
              child: MainButton(
                title: 'Xác nhận',
                event: _confirmHandle,
                largeButton: true,
                icon: null,
              ),
            ),
            const SizedBox(height: sp16),
          ],
        ),
      ),
    );
  }

  void _confirmHandle() {
    widget.onConfirm?.call(listVariantSelected);
    context.pop();
  }
}
