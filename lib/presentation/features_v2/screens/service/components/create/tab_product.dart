import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/components/widgets/title_add.dart';
import 'package:pharmago/presentation/features_v2/blocs/service/bloc_index.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/items/item_prd.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/divider_custom.dart';
import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../blocs/state/init_state.dart';
import '../../../../models/product/product_v2_model.dart';

class TabProductCreateService extends StatefulWidget {
  final CreateServiceV2Bloc bloc;
  const TabProductCreateService({
    super.key,
    required this.bloc,
  });

  @override
  State<TabProductCreateService> createState() =>
      _TabProductCreateServiceState();
}

class _TabProductCreateServiceState extends State<TabProductCreateService>
    with AutomaticKeepAliveClientMixin {
  final bloc = AddPrdServiceBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.setList(widget.bloc.products);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<AddPrdServiceBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.status == BlocStatus.success) {
          widget.bloc.products = bloc.list;
        }
      },
      builder: (context, state) {
        if (bloc.list.isEmpty) {
          return _buildEmpty();
        }
        return SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchFilterCustom(
                onChange: (p0) {
                  bloc.filterPrd(p0);
                },
                hintText: 'Tìm kiếm tên sản phẩm',
              ),
              24.height,
              TitleAdd(
                title: 'Sản phẩm',
                labelButton: 'Thêm sản phẩm',
                onPressed: addPrd,
              ),
              DividerCustom(),
              ListView.separated(
                shrinkWrap: true,
                padding: 0.pading,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ItemPrdService(
                  product: bloc.searchList[index],
                  remove: () =>
                      bloc.removeById(bloc.searchList[index].id ?? -1),
                ),
                separatorBuilder: (context, index) => DividerCustom(),
                itemCount: bloc.searchList.length,
              ),
            ],
          ),
        );
      },
    );
  }

  addPrd() {
    context.pushRoute(const AddPrdServiceV2Route()).then(
      (value) {
        if (value is List<ProductV2Model>) {
          value.removeWhere(
            (element) => bloc.ids.contains(element.id),
          );
          bloc.add(value);
        }
      },
    );
  }

  Widget _buildEmpty() {
    return EmptyComfirm(
      labelBtn: 'Thêm sản phẩm',
      text: 'Chưa có SP liên quan',
      onPressed: addPrd,
      btnColor: AppColors.button_neutral_solid_backgroundDefault,
      icon: FaIcon(
        iconCode: 'f1b2',
        type: FaIconType.solid,
        size: 32,
        color: AppColors.fg_tertiary,
      ),
      suffixIcon: const Icon(
        Icons.add,
        size: 20,
        color: AppColors.button_neutral_solid_iconDefault,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
