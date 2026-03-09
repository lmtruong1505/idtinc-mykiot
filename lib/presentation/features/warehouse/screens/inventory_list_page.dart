import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/screens/price_list_page.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/inventory_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/inventory_state.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/inventory_entity.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

@RoutePage()
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  final myBloc = getIt.get<InventoryCreateCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: bg_5,
      appBar: const BaseAppBar(title: 'Danh sách tồn kho'),
      body: Container(
          padding: const EdgeInsets.fromLTRB(sp16, 0, sp16, sp16),
          child: BlocProvider<InventoryCreateCubit>(
              create: (context) => myBloc..getWareHouseList(),
              child: BlocBuilder<InventoryCreateCubit, InventoryState>(
                  builder: (context, state) => SingleChildScrollView(
                      controller: myBloc.scrollController,
                      child: Column(children: [
                        gapHeight(sp16),
                        Row(children: [
                          Expanded(
                            child: CommonDropdown(
                              items: state.warehouseDrops,
                              hintText: 'Chọn kho',
                              value: state.warehouseId,
                              onChanged: myBloc.changeWarehouseId,
                            ),
                          ),
                          const SizedBox(width: sp16),
                          InkWell(
                              onTap: () async =>
                                  DialogUtils.showBottomDialogText(
                                    context,
                                    SearchPopup(),
                                  ),
                              child: Container(
                                  padding: const EdgeInsets.all(sp16 + 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(sp8),
                                    border: Border.all(
                                      color: borderColor_2,
                                    ),
                                    color: whiteColor,
                                  ),
                                  child: IcSvg.img(IcSvg.iconFilter,
                                      color: greyColor)))
                        ]),
                        gapHeight(sp16),
                        InfiniteList(
                          shrinkWrap: true,
                          getData: (page) => myBloc.getList(page),
                          itemBuilder: (context, item, index) => _oneItem(item),
                          scrollController: myBloc.scrollController,
                          infiniteListController: myBloc.entityILC,
                          circularProgressIndicator: const BaseLoading(),
                          noItemFoundWidget: const EmptyContainer(),
                        )
                      ]))))));

  Widget _oneItem(InventoryEntity item) => Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(sp12),
          boxShadow: [
            BoxShadow(
                color: blackColor.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 0))
          ]),
      child: Column(children: [
        Stack(children: [
          ListTile(
              contentPadding: const EdgeInsets.all(sp0),
              leading: Container(
                height: sp48,
                width: sp48,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: BaseCacheImage(
                        url: item.image ?? PrefKeys.imgProductDefault)),
              ),
              title: Text('Mã lô: ${item.code}',
                  style: p5.copyWith(color: blackColor)),
              subtitle: Text('Tên mẫu mã: ${item.name}',
                  style: p6.copyWith(color: accentColor_7))),
          const Positioned(
            bottom: 10,
            left: sp48,
            child: Icon(Icons.circle, size: 10, color: green_1),
          ),
        ]),
        gapHeight(sp16),
        RowItem(title: 'Số lượng tồn', content: FormatCurrency(item.amount)),
        gapHeight(sp12),
        RowItem(
            title: 'ĐVT cơ bản', content: "${item.variant?.units?[0].name}"),
        gapHeight(sp12),
        RowItem(
            title: 'Giá trị tồn',
            content:
                '${FormatCurrency((item.amount ?? 0) * (item.price ?? 0))} VNĐ'),
      ]));
}
