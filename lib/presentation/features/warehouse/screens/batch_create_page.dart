import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/batch_create_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/batch_create_state.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/batch_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/variant_warehouse_entity.dart';

import '../widgets/form_add_consignment.dart';

@RoutePage()
class BatchCreatePage extends StatefulWidget {
  final VariantWarehouseEntity item;
  final List<BatchEntity> batchs;
  const BatchCreatePage({super.key, required this.item, required this.batchs});

  @override
  State<BatchCreatePage> createState() => _BatchCreatePageState();
}

class _BatchCreatePageState extends State<BatchCreatePage> {
  final myBloc = getIt.get<BatchCreateCubit>();
  @override
  Widget build(BuildContext context) => BlocProvider<BatchCreateCubit>(
        create: (context) => myBloc..init(widget.batchs),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: bg_5,
            appBar: const BaseAppBar(title: 'Thêm lô cho sản phẩm'),
            body: Container(
              margin: const EdgeInsets.all(sp16),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(sp0),
                        leading: Container(
                          height: sp64,
                          width: sp64,
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor_2),
                            borderRadius: BorderRadius.circular(sp12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(sp12),
                            child: BaseCacheImage(url: widget.item.image),
                          ),
                        ),
                        title: Text(
                          widget.item.name,
                          style: p5.copyWith(color: blackColor),
                        ),
                        subtitle: Text(
                          widget.item.code,
                          style: p6.copyWith(color: greyTextColor),
                        ),
                      ),
                      const Positioned(
                        bottom: 10,
                        left: sp48 + 10,
                        child: Icon(Icons.circle, size: 10, color: green_1),
                      ),
                    ],
                  ),
                  gapHeight(sp16),
                  BlocBuilder<BatchCreateCubit, BatchCreateState>(
                    builder: (context, state) => Column(
                      children: [
                        for (var i = 0; i < state.list.length; i++)
                          FormAddConsignment(
                            item: state.list[i],
                            index: i,
                            myBloc: myBloc,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ExtraButton(
                      title: 'Thêm lô',
                      icon: const Icon(
                        Icons.add,
                        color: mainColor,
                      ),
                      largeButton: false,
                      backgroundColor: whiteColor,
                      event: myBloc.addBatch,
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.1),
                    offset: const Offset(0, -1),
                    blurRadius: sp4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ExtraButton(
                      title: 'Huỷ bỏ',
                      event: () => context.router.pop(),
                      backgroundColor: bg_4,
                      borderColor: borderColor_2,
                    ),
                  ),
                  gapWidth(sp12),
                  Expanded(
                    child: MainButton(
                      title: 'Xác nhận',
                      event: () => myBloc.onTapConfirm(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
