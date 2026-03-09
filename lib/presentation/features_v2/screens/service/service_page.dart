import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/config/role/permission/index.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/items/item_service.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../config/role/check_role_per.dart';
import '../../../di/di.dart';
import '../../../../shared/components/widgets/title_add.dart';
import '../../blocs/service/bloc_index.dart';
import 'components/bottom_sheet/bts_filter_service.dart';

@RoutePage()
class ServiceV2Page extends StatefulWidget {
  const ServiceV2Page({super.key});

  @override
  State<ServiceV2Page> createState() => _ServiceV2PageState();
}

class _ServiceV2PageState extends State<ServiceV2Page> {
  final bloc = getIt<ListServiceBloc>();
  late ServiceTypeBloc typeBloc;
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    typeBloc = context.read<ServiceTypeBloc>();
    bloc.init();
    scroll.onMore(() => bloc.getList(isMore: true));
  }

  pushCreateScreen() {
    context.pushRoute(
      CreateServiceV2Route(service: null),
    );
  }

  Function()? get createFun =>
      isAdmin && checkPermission(PerServiceEnum.CREATE.code)
          ? pushCreateScreen
          : null;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceTypeBloc, CubitState>(
      listener: (context, state) {
        CheckStateBloc.checkNoLoad(
          context,
          state,
          isShowMsg: false,
        );
      },
      child: Scaffold(
        appBar: AppBarTitleCenter(
          title: 'Quản lý dịch vụ',
          leadingText: 'Trở về',
        ),
        body: BlocBuilder<ListServiceBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return LoadMoreListBloc(
              state: state,
              list: bloc.list,
              controller: scroll,
              isEmptyAll: state.isFirst,
              headerView: _filterAndAdd(),
              emptyViewAll: _buildEmpty(),
              sizePage: bloc.limit,
              itemBuilder: (context, item, index) => InkWell(
                onTap: checkPermission(PerServiceEnum.DETAIL.code)
                    ? () {
                        context.pushRoute(
                          DetailServiceV2Route(
                              id: item.id!, types: typeBloc.list),
                        );
                      }
                    : null,
                child: ItemServiceV2(item: item),
              ),
              separatorBuilder: const Divider(
                height: 0,
                color: AppColors.border_tertiary,
              ),
              spaceBottom: context.padding.bottom,
            );
          },
        ),
      ),
    );
  }

  Column _filterAndAdd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchFilterCustom(
          isActive: bloc.isFilter,
          onChange: bloc.setSearch,
          onTap: () {
            context.bottomSheet(
              BtsFilterService(
                status: bloc.status,
                type: bloc.type,
                rangePrice: bloc.rangePrice,
                onChanged: (status, rangePrice, type) {
                  bloc.setParam(
                    typeVal: type,
                    rangePriceVal: rangePrice,
                    statusVal: status,
                  );
                },
              ),
            );
          },
          hintText: 'Nhập tên dịch vụ',
        ),
        24.height,
        TitleAdd(
          labelButton: 'Thêm dịch vụ',
          onPressed: createFun,
        ),
        const Divider(
          height: 0,
          color: AppColors.border_tertiary,
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return EmptyComfirm(
      labelBtn: 'Tạo dịch vụ',
      text: 'Chưa có dịch vụ',
      icon: FaIcon(
        iconCode: 'f4be',
        type: FaIconType.solid,
        size: 32,
      ),
      suffixIcon: const Icon(
        Icons.add,
        color: AppColors.bg_primary,
      ),
      onPressed: createFun,
    );
  }
}
