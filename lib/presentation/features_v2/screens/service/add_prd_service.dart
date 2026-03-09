import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/product_manager_bloc.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/components/widgets/progess_stepper.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/bg/bg_btn_nav_bar.dart';
import '../../../../shared/components/widgets/divider_custom.dart';
import '../../../../shared/components/widgets/empty_view.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../blocs/service/bloc_index.dart';
import '../../blocs/state/init_state.dart';
import '../product/components/bts_filter_prod.dart';
import 'components/items/item_prd.dart';

@RoutePage()
class AddPrdServiceV2Page extends StatefulWidget {
  const AddPrdServiceV2Page({super.key});

  @override
  State<AddPrdServiceV2Page> createState() => _AddPrdServiceV2PageState();
}

class _AddPrdServiceV2PageState extends State<AddPrdServiceV2Page> {
  final bloc = ProductManagerBloc();
  final addBloc = AddPrdServiceBloc();
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getList();
    scroll.onMore(
      () => bloc.getList(isMore: true),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPrdServiceBloc, CubitState>(
      bloc: addBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarTitleCenter(
            title: 'Thêm mới sản phẩm',
            leadingText: 'Trở về',
          ),
          bottomNavigationBar: BgBtnNavBar(
            child: DoubleButton(
              confirmText: addBloc.tabIndex == 0 ? 'Tiếp tục' : 'Xác nhận',
              cancelText: 'Trở về',
              onCancel: () {
                if (addBloc.tabIndex == 1) {
                  addBloc.tabIndex = 0;
                  return;
                }
                context.pop();
              },
              onConfirm: addBloc.list.isEmpty
                  ? null
                  : () {
                      if (addBloc.tabIndex == 0) {
                        addBloc.tabIndex = 1;
                        return;
                      }
                      context.pop(result: addBloc.list);
                    },
            ),
          ),
          body: BlocBuilder<ProductManagerBloc, CubitState>(
            bloc: bloc,
            builder: (context, statePrd) {
              if (statePrd.status == BlocStatus.success &&
                  bloc.list.isEmpty &&
                  statePrd.isFirst) {
                return EmptyComfirm(
                  text: 'Không có sản phẩm',
                  onPressed: null,
                  icon: FaIcon(
                    iconCode: 'f1b2',
                    type: FaIconType.solid,
                    size: 32,
                  ),
                );
              }
              return SingleChildScrollView(
                padding: 16.pading,
                controller: scroll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProgessStepper(
                      current: addBloc.tabIndex,
                      steps: const [
                        'Chọn sản phẩm',
                        'Xác nhận thông tin',
                      ],
                    ).container(
                      radius: 12,
                      bgColor: AppColors.bg_secondary_subtle,
                    ),
                    24.height,
                    addBloc.tabIndex == 0 ? _listPrd() : _listPrdChoose(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _listPrd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchFilterCustom(
          onChange: (p0) {
            bloc.search = p0;
          },
          hintText: 'Tìm kiếm tên sản phẩm',
          isActive: bloc.isSort,
          onTap: () {
            context.bottomSheet(
              BtsFilterProd(
                active: bloc.active,
                category: bloc.category,
                brand: bloc.brand,
                type: bloc.type,
                price: bloc.price,
                company: null,
                onChange: (active, category, brand, type, price, company) {
                  bloc.changeFilter(
                    active: active,
                    category: category,
                    brand: brand,
                    type: type,
                    price: price,
                  );
                },
              ),
            );
          },
        ),
        24.height,
        Text(
          'Sản phẩm',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        6.height,
        DividerCustom(),
        LoadMoreListBloc(
          state: bloc.state,
          list: bloc.list,
          padding: 0.pading,
          itemBuilder: (context, item, index) => InkWell(
            onTap: () {
              if (addBloc.ids.contains(bloc.list[index].id)) {
                addBloc.removeById(bloc.list[index].id ?? -1);
              } else {
                addBloc.add([bloc.list[index]]);
              }
            },
            child: ItemPrdService(
              isList: true,
              product: bloc.list[index],
              isActive: addBloc.ids.contains(bloc.list[index].id),
            ),
          ),
          separatorBuilder: DividerCustom(),
        ),
      ],
    );
  }

  Widget _listPrdChoose() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Danh sách sản phẩm',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        6.height,
        DividerCustom(),
        if (addBloc.list.isEmpty) const EmptyContainer(),
        ListView.separated(
          shrinkWrap: true,
          padding: 0.pading,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ItemPrdService(
            product: addBloc.list[index],
            remove: () {
              addBloc.removeById(addBloc.list[index].id ?? -1);
            },
          ),
          separatorBuilder: (context, index) => DividerCustom(),
          itemCount: addBloc.list.length,
        ),
      ],
    );
  }
}
