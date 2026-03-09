import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/cubit/price_update_cubit/price_update_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/price_update_cubit/price_update_state.dart';
import 'package:pharmago/presentation/features/product/domain/entities/price_entity.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';

@RoutePage()
class PriceUpdatePage extends StatefulWidget {
  final PriceEntity priceEntity;

  const PriceUpdatePage({super.key, required this.priceEntity});

  @override
  State<PriceUpdatePage> createState() => _PriceUpdatePageState();
}

class _PriceUpdatePageState extends State<PriceUpdatePage> {
  final myBloc = getIt.get<PriceUpdateCubit>();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PriceUpdateCubit, PriceUpdateState>(
        bloc: myBloc,
        builder: (context, state) => Scaffold(
          backgroundColor: bg_5,
          appBar: const BaseAppBar(title: 'Chỉnh sửa bảng giá'),
          body: Container(
            margin: const EdgeInsets.all(sp16),
            padding: const EdgeInsets.all(sp16),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.1),
                  offset: const Offset(1, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: SizedBox(
                    height: sp48,
                    width: sp48,
                    child: BaseCacheImage(
                      url: widget.priceEntity.image ??
                          PrefKeys.imgProductDefault,
                    ),
                  ),
                  title: AppInputSupport(
                    label: 'Tên mẫu mã',
                    readOnly: true,
                    hintText: '',
                    textInputType: TextInputType.number,
                    initialValue: widget.priceEntity.name ?? '',
                    backgroundColor: whiteColor,
                    borderColor: borderColor_2,
                    boxShadow: [],
                  ),
                ),
                gapHeight(sp16),
                Row(children: [
                  Expanded(
                    child: AppInputSupport(
                      label: 'Giá nhập cũ',
                      readOnly: true,
                      hintText: '',
                      initialValue: '${widget.priceEntity.priceImport ?? 0}',
                      backgroundColor: whiteColor,
                      borderColor: borderColor_2,
                      boxShadow: [],
                    ),
                  ),
                  gapWidth(sp12),
                  Expanded(
                    child: AppInputSupport(
                      label: 'Giá bán cũ',
                      readOnly: true,
                      hintText: '',
                      initialValue: '${widget.priceEntity.priceSell ?? 0}',
                      onConfirm: (String value) => {},
                      backgroundColor: whiteColor,
                      borderColor: borderColor_2,
                      boxShadow: [],
                    ),
                  ),
                ]),
                gapHeight(sp12),
                Row(
                  children: [
                    Expanded(
                      child: AppInputSupport(
                        label: 'Giá nhập mới',
                        hintText: 'Nhập giá',
                        textInputType: TextInputType.number,
                        initialValue: '',
                        onChanged: myBloc.changePriceImport,
                        backgroundColor: whiteColor,
                        borderColor: borderColor_2,
                        boxShadow: [],
                      ),
                    ),
                    gapWidth(sp12),
                    Expanded(
                      child: AppInputSupport(
                        label: 'Giá bán mới',
                        hintText: 'Nhập giá',
                        textInputType: TextInputType.number,
                        initialValue: '',
                        onChanged: myBloc.changePriceSell,
                        backgroundColor: whiteColor,
                        borderColor: borderColor_2,
                        boxShadow: [],
                      ),
                    ),
                  ],
                ),
                gapHeight(sp16),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(sp16),
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
                    title: 'Lưu lại',
                    event: () =>
                        myBloc.onTapSave(context, widget.priceEntity.id),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
