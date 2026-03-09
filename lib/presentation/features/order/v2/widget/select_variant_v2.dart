import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/v2/cubit/variant_for_order_cubit.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/style_app/color_app.dart';

import '../../../../base/empty_container.dart';
import '../../../../base/infinite_list.dart';
import '../../../../base/loading.dart';
import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_device.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../product/domain/entities/variant_entity.dart';
import '../../cubit/order_create_cubit/order_create_state.dart';
import '../cubit/order_create_v2_cubit.dart';
import '../cubit/variant_for_order_state.dart';
import 'bts_edit_amout.dart';
import 'variant_preview_card.dart';

class SelectVariantV2 extends StatefulWidget {
  const SelectVariantV2({
    super.key,
    required this.orderCreateCubit,
    this.onSelected,
    this.data,
    this.inSelectedTab,
  });

  final OrderCreateV2Bloc orderCreateCubit;
  final Function(VariantEntity? value)? onSelected;
  final List<VariantEntity>? data;
  final Function(bool)? inSelectedTab;

  @override
  State<SelectVariantV2> createState() => _SelectVariantV2State();
}

class _SelectVariantV2State extends State<SelectVariantV2> with AutomaticKeepAliveClientMixin{

  final _cubit = getIt.get<VariantForOrderCubit>();
  late TextEditingController search = TextEditingController();
  Timer? timerSearch;
  late ScrollController _controllerSelectedVar;
  List<GlobalKey> keys = [];
  @override
  void initState() {
    _controllerSelectedVar = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    timerSearch?.cancel();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => _cubit..init(widget.data ?? []),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: widthDevice(context),
            height: heightDevice(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(sp16).copyWith(bottom: sp0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearch(),
                      const SizedBox(height: sp12),
                      _buildTypeVariant().size(height: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildVariant(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Visibility(
            visible: widget.orderCreateCubit.state.customerSelected == null,
            child: Container(
              height: sp48,
              padding: const EdgeInsets.symmetric(horizontal: sp16),
              color: red_1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bạn chưa chọn Khách hàng',
                  style: p5.copyWith(color: whiteColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSearch() {
    return AppInputSupport(
      hintText: 'Tìm kiếm sản phẩm',
      prefixIcon: const Icon(Icons.search_rounded),
      onConfirm: (p0) => {},
      backgroundColor: whiteColor,
      onChanged: (value) {
        if (timerSearch != null) {
          timerSearch!.cancel();
        }
        timerSearch = Timer(const Duration(milliseconds: 500), () {
          _cubit.searchVariantHandle(value);
        });
      },
    );
  }

  Widget _buildTypeVariant() {
    return BlocBuilder<VariantForOrderCubit, VariantForOrderState>(
      builder: (context, state) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.listFilter.length,
          shrinkWrap: true,
          controller: _controllerSelectedVar,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                _cubit.selectFilterButton(
                  state.listFilter[index],
                );
                keys = [];
                switch (state.listFilter[index].value) {
                  case FilterItemOrder.had_choose:
                    // widget.inSelectedTab?.call(true);
                     search.clear();
                    _cubit.searchVariantHandle('');
                    break;
                  default:
                    widget.inSelectedTab?.call(false);
                    break;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp8,
                  horizontal: sp12,
                ),
                margin: const EdgeInsets.only(right: sp16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp8),
                  color: state.listFilter[index] == state.selectFilter
                      ? ColorApp.main
                      : whiteColor,
                  border: Border.all(
                    color: state.listFilter[index] == state.selectFilter
                        ? ColorApp.main
                        : borderColor_2,
                  ),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        state.listFilter[index].label +
                            (index == 0
                                ? ' (${widget.orderCreateCubit.state.variantSelected.length.toString()})'
                                : ' '),
                        style: p5.copyWith(
                          color: state.listFilter[index] == state.selectFilter
                              ? whiteColor
                              : greyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVariant() {
    return BlocBuilder<VariantForOrderCubit, VariantForOrderState>(
      builder: (context, state) {
        if (state.selectFilter.label == 'Đã chọn') {
          final data = widget.orderCreateCubit.state.variantSelected
              .where(
                (element) =>
            element.name?.contains(state.searchKey) ?? false||
                (element.code?.contains(state.searchKey) ?? false),
          )
              .toList();
          keys = List.generate(
            data.length,
                (index) => GlobalKey(),
          );
          return widget.orderCreateCubit.state.variantSelected.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Bạn chưa chọn sản phẩm nào',
              style: p5.copyWith(color: greyColor),
            ),
          )
              : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final variant = data[index];
              return Column(
                children: [
                  16.height,
                  _oneItem(
                    variant,
                    index,
                    type: 1,
                    key: keys[index],
                  ),
                ],
              );
            },
          );
        }
        return SingleChildScrollView(
          controller: _cubit.scrollController,
          child: Column(
            children: [
              16.height,
              InfiniteList(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                getData: (page) async {
                  if (page == 0) {
                    _cubit.infiniteListController.itemList = [];
                  }
                  keys = [];
                  return _cubit.getListVariant(
                    page: page + 1,
                  );
                },
                itemBuilder: (context, item, index) {
                  final variant = _cubit.getVariantSelected(item.id);
                  keys.add(GlobalKey());
                  return _oneItem(variant, index, key: keys[index]);
                },
                heightGap: 0,
                scrollController: _cubit.scrollController,
                infiniteListController: _cubit.infiniteListController,
                circularProgressIndicator: const BaseLoading(),
                noItemFoundWidget: const EmptyContainer(),
              ),
              SizedBox(height: heightDevice(context) / 2.5),
            ],
          ),
        );
      },
    );
  }

  Widget _oneItem(
      VariantEntity item,
      int index, {
        int? type,
        Key? key,
      }) {
    final isSelected = _cubit.checkVariantIsSelected(item.id) && item.isChoose;
    return InkWell(
      key: key,
      onTap: () async {
        if (widget.orderCreateCubit.state.customerSelected == null) {
          return;
        }
        scrollItem(index);
        await _cubit.selectVariant(
          variantId: item.id!,
        );
        final variant = _cubit.getVariantSelected(item.id);
        _showSessionEditAmout(variant);
      },
      child: VariantPreviewCard(
        item: item,
        borderColor: isSelected ? mainColor : borderColor_2,
        isSelected: isSelected,
        onRemove: () {
          _cubit.unChooseVariant(item.id!);
          widget.orderCreateCubit.removeVariant(item.id!);
        },
      ),
    );
  }

  Future scrollItem(int index) async {
    final context = keys[index].currentContext;
    if (context != null) {
      await Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showSessionEditAmout(VariantEntity item) async {
    final of = heightDevice(context).toInt();
    await showModalBottomSheet(
      backgroundColor: whiteColor.withOpacity(0),
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: whiteColor.withOpacity(0),
      context: context,
      builder: (context) {
        return BtsEditAmount(
          variant: item,
          onConfirm: (item) {
            _cubit.updateVariant(item);
            if (_cubit.checkVariantIsSelected(item.id)) {
              widget.orderCreateCubit.addVariant(item.copyWith(isChoose: true));
            } else {
              widget.orderCreateCubit.removeVariant(item.id!);
            }
          },
          offset: of ~/ 3 + 100,
        );
      },
    );
}

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
