import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/cubit/order_wm_create_cubit/order_wm_create_cubit.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/domain/entities/variant_wm_entity.dart';
import 'package:pharmago/presentation/features/wholesale_medicine/widgets/variant_wm_create_card.dart';

@RoutePage()
class VariantWmListPage extends StatefulWidget {
  const VariantWmListPage({super.key});

  @override
  State<VariantWmListPage> createState() => _VariantWmListPageState();
}

class _VariantWmListPageState extends State<VariantWmListPage> {
  final _cubit = getIt.get<OrderWmCreateCubit>();
  final _infiniteListController =
      InfiniteListController<VariantWmEntity>.init();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Danh sách thuốc sỉ',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: sp24,
          horizontal: sp16,
        ),
        width: widthDevice(context),
        height: heightDevice(context),
        child: InfiniteList(
          physics: const BouncingScrollPhysics(),
          getData: (page) {
            return _cubit.getListVariant(page);
          },
          itemBuilder: (context, item, index) {
            return VariantWmCreateCard(variant: item);
          },
          scrollController: _scrollController,
          infiniteListController: _infiniteListController,
        ),
      ),
    );
  }
}
