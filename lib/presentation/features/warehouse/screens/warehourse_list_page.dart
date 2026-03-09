import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_state.dart';
import 'package:pharmago/presentation/features/warehouse/widgets/warehouse_more_action.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../domain/entities/warehouse_entity.dart';

@RoutePage()
class WarehouseListPage extends StatefulWidget {
  const WarehouseListPage({super.key});

  @override
  State<WarehouseListPage> createState() => _WarehouseListPageState();
}

class _WarehouseListPageState extends State<WarehouseListPage> {
  final myBloc = getIt.get<WarehouseCubit>();
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: bg_5,
          appBar: BaseAppBar(
            title: 'Danh sách kho',
            actions: [
              InkWell(
                onTap: () async {
                  await context.router.push(
                    WarehouseCreateRoute(),
                  );
                  myBloc.warehouseILC.onRefresh();
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: const Icon(
                    Icons.add,
                    size: sp24,
                    color: blackColor,
                  ),
                ),
              ),
            ],
          ),
          body: _body(),
        ),
      );

  Widget _oneItem(WarehouseEntity item) => GestureDetector(
        onTap: () => context.router.push(WarehouseDetailRoute(warehouse: 1)),
        child: Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp12),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(sp0),
                leading: Container(
                  height: sp48,
                  width: sp48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    color: bg_5,
                  ),
                  child: Center(
                    child: Text(
                      '${item.id}',
                      style: p5.copyWith(
                        color: blackColor,
                      ),
                    ),
                  ),
                ),
                title: Text('Tên kho: ${item.title}', style: p3),
                subtitle: Text('Mã kho: ${item.code}', style: p6),
                trailing: SizedBox(
                  width: sp48,
                  child: WarehouseMoreAction(id: item.id),
                ),
              ),
              Visibility(
                visible: item.address?.ward?.name != null,
                child: Text(
                  '${item.address?.title}, ${item.address?.ward?.name}, ${item.address?.district?.name}, ${item.address?.province?.name}',
                  style: p5.copyWith(color: blackColor),
                ),
              ),
              gapHeight(sp16),
              const RowItem(
                title: 'Quản lý kho',
                content: 'Chưa có thông tin',
              ),
            ],
          ),
        ),
      );

  Widget _body() => Container(
        padding: const EdgeInsets.fromLTRB(sp16, sp16, sp16, sp16),
        child: BlocProvider<WarehouseCubit>(
          create: (context) => myBloc,
          child: BlocBuilder<WarehouseCubit, WarehouseState>(
            builder: (context, state) => Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: myBloc.scrollController,
                    child: InfiniteList<WarehouseEntity>(
                      shrinkWrap: true,
                      getData: (page) => myBloc.getList(page),
                      itemBuilder: (context, item, index) => _oneItem(item),
                      scrollController: myBloc.scrollController,
                      infiniteListController: myBloc.warehouseILC,
                      noItemFoundWidget: const EmptyContainer(),
                      circularProgressIndicator: const BaseLoading(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
