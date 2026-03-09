import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../../shared/constants/pref_key.dart';
import '../../../../base/button.dart';
import '../../../../constants/asset_path.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../../features/company/cubit/point_exchange_package_cubit/point_exchange_package_cubit.dart';
import '../../../../features/company/cubit/work_space/work_space_cubit.dart';
import '../../../../features/company/cubit/work_space/work_space_state.dart';
import '../../../../features/company/data/models/point_exchange_package_model.dart';
import '../../../../shared/utils/event.dart';

class ListPackageBts extends StatefulWidget {
  const ListPackageBts({
    super.key,
    this.onCallback,
  });

  final Function(
    PointExchangePackageModel? package,
  )? onCallback;

  static void show(
    BuildContext context, {
    Function(
      PointExchangePackageModel? package,
    )? onCallback,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(sp16),
        ),
      ),
      builder: (context) => ListPackageBts(
        onCallback: onCallback,
      ),
    );
  }

  @override
  State<ListPackageBts> createState() => _ListPackageBtsState();
}

class _ListPackageBtsState extends State<ListPackageBts> {
  final _cubit = getIt.get<PointExchangePackageCubit>();
  final _wsCubit = getIt.get<WorkSpaceCubit>();

  PointExchangePackageModel? _package;

  @override
  void initState() {
    super.initState();

    _wsCubit.getListPointExchangePackage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PointExchangePackageCubit>(
      create: (context) => _cubit,
      child: SizedBox(
        height: heightDevice(context) * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(sp16),
          child: Column(
            spacing: sp12,
            children: [
              Container(
                width: sp64,
                padding: const EdgeInsets.all(sp2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: AppColors.border_tertiary,
                  border: Border.all(color: AppColors.border_tertiary),
                ),
              ),
              Text(
                'Danh sách gói',
                style: s16w700.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              _package == null ? _listPackageView : _packageDetailView,
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: ExtraButton(
                      title: 'Huỷ',
                      event: () {
                        Navigator.of(context).pop();
                      },
                      backgroundColor: AppColors.border_primary_active,
                      borderRadius: sp48,
                    ),
                  ),
                  sp12.width,
                  Expanded(
                    child: MainButton(
                      title: 'Xác nhận',
                      event: () {
                        widget.onCallback?.call(_package);
                        Navigator.of(context).pop();
                      },
                      radius: sp48,
                    ),
                  ),
                ],
              ),
              12.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _listPackageView {
    return BlocSelector<WorkSpaceCubit, WorkSpaceState,
        List<PointExchangePackageModel>>(
      bloc: _wsCubit,
      selector: (state) {
        return state.listPointExchangePackage;
      },
      builder: (context, listPointExchangePackage) {
        return Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return _itemView(listPointExchangePackage[index]);
            },
            separatorBuilder: (_, __) => sp12.height,
            itemCount: listPointExchangePackage.length,
          ),
        );
      },
    );
  }

  Widget get _packageDetailView {
    return Expanded(
      child: Column(
        spacing: sp12,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _itemView(_package!),
          Text(
            'Chọn sản phẩm từ gói',
            style: s14w700.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final item = _package!.items![index];
                return Row(
                  spacing: sp8,
                  children: [
                    BaseCheckbox(
                      value: item.product?.isSelected ?? false,
                      onChanged: (value) {
                        final listCopy =
                            List<PointExchangePackageItemModel>.from(
                          _package!.items!,
                        );
                        listCopy[index] = listCopy[index].copyWith(
                          product: listCopy[index].product?.copyWith(
                                isSelected:
                                    !(item.product?.isSelected ?? false),
                              ),
                        );
                        setState(() {
                          _package = _package?.copyWith(items: listCopy);
                        });
                      },
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(sp4),
                      child: Image.network(
                        item.product?.images?.firstOrNull?.url ??
                            PrefKeys.imgProductDefault,
                        width: sp48,
                        height: sp48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    gapWidth(sp16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product?.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                s14w500.copyWith(color: AppColors.text_primary),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                '${FormatCurrency(item.unit?.sellPrice)} đ',
                                style: p5.copyWith(color: blackColor),
                              ),
                              Text(
                                '/${item.unit?.name}',
                                style: p5.copyWith(color: blackColor),
                              ),
                              const Spacer(),
                              Text(
                                '${FormatCurrency(item.quantity)} ${item.unit?.name}',
                                style: p3.copyWith(color: mainColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => const Divider(height: sp12),
              itemCount: _package!.items!.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemView(PointExchangePackageModel item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _package = item;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(sp12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sp12),
          border: Border.all(color: AppColors.border_tertiary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: sp4,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name ?? '',
                  style: s14w600.copyWith(color: AppColors.text_secondary),
                ),
                Row(
                  spacing: sp8,
                  children: [
                    Image.asset(
                      '${AssetsPath.image}/img_star.png',
                      width: sp24,
                    ),
                    Text(
                      '${item.point ?? 0} điểm',
                      style: s14w600.copyWith(color: AppColors.text_secondary),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '${item.items?.length ?? 0} sản phẩm',
              style: s12w400.copyWith(color: AppColors.text_secondary),
            ),
          ],
        ),
      ),
    );
  }
}
