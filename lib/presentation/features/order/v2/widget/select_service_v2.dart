import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/v2/cubit/service_for_order_cubit.dart';
import 'package:pharmago/presentation/features/order/v2/cubit/service_for_order_state.dart';
import 'package:pharmago/presentation/features/order/v2/widget/bts_edit_service.dart';
import 'package:pharmago/presentation/features/order/v2/widget/service_preview_card.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../shared/style_app/color_app.dart';
import '../../../../base/empty_container.dart';
import '../../../../base/infinite_list.dart';
import '../../../../base/loading.dart';
import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_device.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../cubit/order_create_cubit/order_create_state.dart';
import '../cubit/order_create_v2_cubit.dart';

class SelectServiceV2 extends StatefulWidget {
  const SelectServiceV2({
    super.key,
    required this.orderCreateCubit,
    this.onSelected,
    this.data,
    this.inSelectedTab,
  });

  final OrderCreateV2Bloc orderCreateCubit;
  final Function(ServiceEntity? value)? onSelected;
  final List<ServiceEntity>? data;
  final Function(bool)? inSelectedTab;

  @override
  State<SelectServiceV2> createState() => _SelectServiceV2State();
}

class _SelectServiceV2State extends State<SelectServiceV2>
    with AutomaticKeepAliveClientMixin {
  final _cubit = getIt.get<ServiceForOrderCubit>();
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
                      _buildTypeService().size(height: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildService(),
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
      hintText: 'Tìm kiếm dịch vụ',
      prefixIcon: const Icon(Icons.search_rounded),
      onConfirm: (p0) => {},
      backgroundColor: whiteColor,
      onChanged: (value) {
        if (timerSearch != null) {
          timerSearch!.cancel();
        }
        timerSearch = Timer(const Duration(milliseconds: 500), () {
          _cubit.searchServiceHandle(value);
        });
      },
    );
  }

  Widget _buildTypeService() {
    return BlocBuilder<ServiceForOrderCubit, ServiceForOrderState>(
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
                    _cubit.searchServiceHandle('');
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
                                ? ' (${widget.orderCreateCubit.state.serviceSelected.length.toString()})'
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

  Widget _buildService() {
    return BlocBuilder<ServiceForOrderCubit, ServiceForOrderState>(
      builder: (context, state) {
        if (state.selectFilter.label == 'Đã chọn') {
          final data = widget.orderCreateCubit.state.serviceSelected
              .where(
                (element) =>
                    element.title?.contains(state.searchKey) ??
                    false || (element.code?.contains(state.searchKey) ?? false),
              )
              .toList();
          keys = List.generate(
            data.length,
            (index) => GlobalKey(),
          );
          return widget.orderCreateCubit.state.serviceSelected.isEmpty
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
                    final service = data[index];
                    return Column(
                      children: [
                        16.height,
                        _oneItem(
                          service,
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
                  return _cubit.getListService(
                    page: page + 1,
                  );
                },
                itemBuilder: (context, item, index) {
                  final service = _cubit.getServiceSelected(item.id);
                  keys.add(GlobalKey());
                  return _oneItem(service, index, key: keys[index]);
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
    ServiceEntity item,
    int index, {
    int? type,
    Key? key,
  }) {
    final isSelected = _cubit.checkServiceIsSelected(item.id) && item.isChoose;
    return InkWell(
      key: key,
      onTap: () async {
        if (widget.orderCreateCubit.state.customerSelected == null) {
          return;
        }
        scrollItem(index);
        await _cubit.selectService(
          serviceId: item.id!,
        );
        final service = _cubit.getServiceSelected(item.id);
        _showSessionEditAmout(service);
      },
      child: ServicePreviewCard(
        item: item,
        borderColor: isSelected ? mainColor : borderColor_2,
        isSelected: isSelected,
        onRemove: () {
          _cubit.unChooseService(item.id!);
          widget.orderCreateCubit.removeService(item.id!);
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

  void _showSessionEditAmout(ServiceEntity item) async {
    final of = heightDevice(context).toInt();
    await showModalBottomSheet(
      backgroundColor: whiteColor.withOpacity(0),
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: whiteColor.withOpacity(0),
      context: context,
      builder: (context) {
        return BtsEditService(
          service: item,
          onConfirm: (item) {
            _cubit.updateService(item);
            if (_cubit.checkServiceIsSelected(item.id)) {
              widget.orderCreateCubit.addService(item.copyWith(isChoose: true));
            } else {
              widget.orderCreateCubit.removeService(item.id!);
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
