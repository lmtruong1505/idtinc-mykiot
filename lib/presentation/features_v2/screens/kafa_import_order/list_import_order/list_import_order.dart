import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/kafa/list_order_kafa.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';

import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

@RoutePage()
class ListImportOrderPage extends StatefulWidget {
  const ListImportOrderPage({super.key});

  @override
  State<ListImportOrderPage> createState() => _ListImportOrderPageState();
}

class _ListImportOrderPageState extends State<ListImportOrderPage> {
  final bloc = getIt<ListOrderKafaBloc>();
  final _scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getList();
    _scroll.onMore(
      () => bloc.getList(isMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.greyF5,
      appBar: const BaseAppBar(title: 'Danh sách đơn nhập hàng'),
      body: BlocBuilder<ListOrderKafaBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              bloc.getList();
            },
            child: SingleChildScrollView(
              padding: 16.pading,
              controller: _scroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainButtonV2(
                    onTap: () {
                      context.pushRoute(const DrugCartRoute());
                    },
                    radius: 8,
                    alignment: Alignment.center,
                    textStyle: StyleApp.medium(color: ColorApp.white),
                    title: 'Tạo đơn nhập hàng\n(Truy cập chợ thuốc sỉ)',
                  ),
                  16.height,
                  _buildStatus(),
                  16.height,
                  AppInputV2(
                    hintText: 'Tìm theo mã ĐH, tên KH',
                    borderColor: ColorApp.greyE2,
                    backgroundColor: ColorApp.white,
                    radius: Dimensions.sp8,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ColorApp.black,
                    ),
                    onChanged: bloc.setSearch,
                  ),
                  LoadListPage(
                    state: state,
                    height: 200,
                    listEmpty: bloc.list.isEmpty,
                    child: ListView.separated(
                      itemCount: bloc.list.length,
                      shrinkWrap: true,
                      padding: 16.padingVer,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => 16.height,
                      itemBuilder: (context, index) => _buildOrder(index),
                    ),
                  ),
                  context.padding.bottom.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatus() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => BtnStatusCount(
        onPressed: () {
          bloc.setStatus(bloc.statusCounts[index].status);
        },
        title: bloc.statusCounts[index].status.title,
        isActive: bloc.statusCounts[index].status == bloc.status,
        count: bloc.statusCounts[index].count,
      ),
      separatorBuilder: (context, index) => 16.width,
      itemCount: bloc.statusCounts.length,
    ).size(height: 40);
  }

  Widget _buildOrder(int index) {
    final titleStyle = StyleApp.normal(color: ColorApp.grey79);
    final contentStyle = StyleApp.semibold();
    final model = bloc.list[index];
    return InkWell(
      onTap: () {
        context.pushRoute(KafaOrderDetailRoute(id: model.id ?? -1));
      },
      child: Container(
        padding: 16.pading,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 8.radius,
          border: Border.all(
            color: ColorApp.greyE2,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '#${model.code ?? ""}',
                  style: StyleApp.medium(
                    color: ColorApp.grey79,
                  ),
                ).expanded(),
                8.width,
                Icon(
                  model.status?.icon ?? StatusOrderKafa.pending.icon,
                  size: 17,
                  color: model.status?.color ?? StatusOrderKafa.pending.color,
                ),
                4.width,
                Text(
                  model.status?.title ?? StatusOrderKafa.pending.title,
                  style: StyleApp.medium(
                    color: model.status?.color ?? StatusOrderKafa.pending.color,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 32,
              color: ColorApp.greyF2,
            ),
            TextRow2(
              title: 'Người tạo',
              content: model.fullName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Thời gian tạo',
              content:
                  model.createdAt.toDate.fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Hoá đơn đỏ',
              content: model.redInvoice == true ? 'Có' : 'Không',
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            8.height,
            TextRow2(
              title: 'Tổng tiền',
              content: model.total.formatPrice(type: ' VNĐ'),
              titleStyle: titleStyle,
              contentStyle: StyleApp.medium(color: ColorApp.main),
            ),
          ],
        ),
      ),
    );
  }
}
