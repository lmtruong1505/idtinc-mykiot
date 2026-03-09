import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/product_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/product_list_item.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../models/product/product_v2_model.dart';

class BtsChoseProduct extends StatefulWidget {
  const BtsChoseProduct({super.key, this.services, this.initData, this.onConfirm});

  final List<int>? services;
  final List<ProductV2Model>? initData;
  final Function(List<ProductV2Model> value)? onConfirm;

  @override
  State<BtsChoseProduct> createState() => _BtsChoseProductState();
}

class _BtsChoseProductState extends State<BtsChoseProduct> {
  final _bloc = ProductManagerBloc();

  @override
  void initState() {
    super.initState();
    _bloc.changeFilter(services: widget.services, active: true);
    // _bloc.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      height: heightDevice(context) / 4 * 3,
      child: Column(
        children: [
          Text(
            'Chọn sản phẩm liên quan',
            style: AppStyle.headingMd,
          ),
          16.height,
          Row(
            children: [
              CupertinoCheckbox(
                value: _isTotalSelect,
                onChanged: (e) {
                  _selectAllHandle();
                },
              ),
              Expanded(
                child: Text(
                  'Chọn tất cả',
                  style: AppStyle.bodySmMedium,
                ),
              ),
            ],
          ),
          BlocBuilder<ProductManagerBloc, CubitState>(
            bloc: _bloc,
            builder: (context, state) {
              return state.status == BlocStatus.loadList
                  ? const BaseLoading()
                  : Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final item = _bloc.list[index];
                          if (widget.initData?.map((e) => e.id).toList().contains(item.id) ?? false) {
                            item.isSelected = true;
                          }
                          return Row(
                            children: [
                              CupertinoCheckbox(
                                value: item.isSelected,
                                onChanged: (e) {
                                  setState(() {
                                    item.isSelected = !item.isSelected;
                                  });
                                },
                              ),
                              Expanded(child: ProductListItem(model: item)),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => 16.height,
                        itemCount: _bloc.list.length,
                      ),
                    );
            },
          ),
          DividerCustom(),
          Row(
            children: [
              Expanded(
                child: ExtraButton(
                  borderRadius: sp24,
                  title: 'Hủy bỏ',
                  largeButton: false,
                  event: () => context.pop(),
                ),
              ),
              16.width,
              Expanded(
                child: MainButton(
                  radius: sp24,
                  title: 'Xác nhận',
                  largeButton: false,
                  event: () {
                    widget.onConfirm?.call(_bloc.list.where((e) => e.isSelected).toList());
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool get _isTotalSelect {
    if (_bloc.list.isEmpty) {
      return false;
    }
    for (final e in _bloc.list) {
      if (!e.isSelected) {
        return false;
      }
    }
    return true;
  }

  void _selectAllHandle() {
    setState(() {
      for (final item in _bloc.list) {
        item.isSelected = !_isTotalSelect;
      }
    });
  }
}
