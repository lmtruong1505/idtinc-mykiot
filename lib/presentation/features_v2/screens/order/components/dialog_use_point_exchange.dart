import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/company/cubit/work_space/work_space_state.dart';
import 'package:pharmago/shared/components/input/input_qty.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../generated/assets.dart';
import '../../../../../shared/components/button/main_button.dart';
import '../../../../../shared/components/input/app_input.dart';
import '../../../../../shared/components/input/overlay_input.dart';
import '../../../../../shared/components/toast/toast_custom.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../shared/constants/pref_key.dart';
import '../../../../base/button.dart';
import '../../../../base/cache_image.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../../features/company/cubit/work_space/work_space_cubit.dart';
import '../../../../features/company/data/models/point_exchange_package_model.dart';
import '../../../../features/company/domain/entities/setting_point_entity.dart';
import '../../../../shared/utils/event.dart';
import '../../../blocs/order_v2/product_selection_bloc.dart';
import '../../../models/customer/v2/customer_point_item_model.dart';
import '../../../models/product/product_v2_model.dart';
import '../../product/components/product_list_item.dart';
import 'list_package_bts.dart';

class DialogUsePointExchange extends StatelessWidget {
  const DialogUsePointExchange({
    super.key,
    required this.point,
    required this.productsSelected,
    required this.productsFromPackage,
    required this.moneyExchange,
    this.callBack,
  });

  final num point;
  final List<ProductV2Model> productsSelected;
  final List<PointExchangePackageModel> productsFromPackage;
  final CustomerPointItemModel moneyExchange;
  final Function({
    required List<ProductV2Model> productsSelected,
    required List<PointExchangePackageModel> productsFromPackage,
    required CustomerPointItemModel moneyExchange,
  })? callBack;

  static void show(
    BuildContext context, {
    required num point,
    required List<ProductV2Model> productsSelected,
    required List<PointExchangePackageModel> productsFromPackage,
    required CustomerPointItemModel moneyExchange,
    Function({
      required List<ProductV2Model> productsSelected,
      required List<PointExchangePackageModel> productsFromPackage,
      required CustomerPointItemModel moneyExchange,
    })? callBack,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogUsePointExchange(
          point: point,
          productsSelected: productsSelected,
          productsFromPackage: productsFromPackage,
          moneyExchange: moneyExchange,
          callBack: callBack,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DialogUsePointExchange(
      point: point,
      productsSelected: productsSelected,
      productsFromPackage: productsFromPackage,
      moneyExchange: moneyExchange,
      callBack: callBack,
    );
  }
}

class _DialogUsePointExchange extends StatefulWidget {
  const _DialogUsePointExchange({
    required this.point,
    required this.productsSelected,
    required this.productsFromPackage,
    required this.moneyExchange,
    this.callBack,
  });

  final num point;
  final List<ProductV2Model> productsSelected;
  final List<PointExchangePackageModel> productsFromPackage;
  final CustomerPointItemModel moneyExchange;
  final Function({
    required List<ProductV2Model> productsSelected,
    required List<PointExchangePackageModel> productsFromPackage,
    required CustomerPointItemModel moneyExchange,
  })? callBack;

  @override
  State<_DialogUsePointExchange> createState() =>
      __DialogUsePointExchangeState();
}

class __DialogUsePointExchangeState extends State<_DialogUsePointExchange>
    with TickerProviderStateMixin {
  num get _point => widget.point;
  final _prodBloc = ProductSelectionBloc();
  final textCtrl = TextEditingController();
  final _wsCubit = getIt.get<WorkSpaceCubit>();

  late TextEditingController _textPointCtl;
  late TabController _tabController;
  late SettingPointEntity _settingPoint;

  late List<ProductV2Model> productsSelected;
  late List<PointExchangePackageModel> productsFromPackage;
  late CustomerPointItemModel moneyExchange;

  num get _totalPointProductUsed => productsSelected.fold(
        0,
        (total, e) {
          return total += (e.quantity ?? 0) * (e.exchangePoint ?? 0);
        },
      );

  num get _totalPointPackageUsed => productsFromPackage.fold(
        0,
        (total, e) {
          final listProductSelected =
              e.items?.where((e) => e.product?.isSelected == true) ?? [];
          if (listProductSelected.isNotEmpty) {
            total += e.point ?? 0;
          }
          return total;
        },
      );

  num get _totalPointUsed {
    return _totalPointProductUsed +
        _totalPointPackageUsed +
        (moneyExchange.point ?? 0);
  }

  @override
  void initState() {
    super.initState();

    productsSelected = widget.productsSelected;
    productsFromPackage = widget.productsFromPackage;
    moneyExchange = widget.moneyExchange;

    _settingPoint = _wsCubit.state.company!.settingPoint!;
    _tabController = TabController(length: 3, vsync: this);
    _textPointCtl =
        TextEditingController(text: '${widget.moneyExchange.point}');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: sp16,
        horizontal: sp16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sp16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sử dụng điểm tích luỹ',
            style: s18w700.copyWith(color: AppColors.text_primary),
          ),
          sp16.height,
          Container(
            padding: const EdgeInsets.all(sp8),
            decoration: BoxDecoration(
              color: AppColors.ultility_gray_20,
              borderRadius: BorderRadius.circular(sp12),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm tích luỹ',
                      style: s14w400.copyWith(color: AppColors.text_primary),
                    ),
                    Row(
                      children: [
                        Text(
                          _point.toStringAsFixed(3),
                          style: AppStyle.bodyBsSemiBold
                              .copyWith(color: AppColors.text_tertiary),
                        ),
                        sp8.width,
                        SvgPicture.asset('assets/svg/point.svg'),
                      ],
                    ),
                  ],
                ),
                // const Spacer(),
                // Row(
                //   children: [
                //     Text(
                //       'Cấp độ:',
                //       style: s14w500.copyWith(color: AppColors.text_primary),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Đổi quà'),
              Tab(text: 'Giảm tiền'),
              Tab(text: 'Đổi quà từ gói'),
            ],
            indicatorColor: AppColors.brand,
            labelColor: AppColors.brand,
            onTap: (value) => setState(() {}),
          ),
          sp16.height,
          Expanded(
            child: IndexedStack(
              index: _tabController.index,
              children: [
                _productExchangeView,
                _moneyExchangeView,
                _productPackageView,
              ],
            ),
          ),
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Đã sử dụng từ ',
                      style: s12w500.copyWith(color: AppColors.text_primary),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Giảm tiền',
                              style: s12w400.copyWith(
                                  color: AppColors.text_secondary),
                            ),
                            const Spacer(),
                            Text(
                              moneyExchange.point.formatCurrency,
                              style: s12w500.copyWith(
                                  color: AppColors.text_primary),
                            ),
                            sp4.width,
                            SvgPicture.asset('assets/svg/point.svg'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Đổi quà',
                              style: s12w400.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _totalPointProductUsed.formatCurrency,
                              style: s12w500.copyWith(
                                color: AppColors.text_primary,
                              ),
                            ),
                            sp4.width,
                            SvgPicture.asset('assets/svg/point.svg'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Đổi quà từ gói',
                              style: s12w400.copyWith(
                                  color: AppColors.text_secondary),
                            ),
                            const Spacer(),
                            Text(
                              _totalPointPackageUsed.formatCurrency,
                              style: s12w500.copyWith(
                                color: AppColors.text_primary,
                              ),
                            ),
                            sp4.width,
                            SvgPicture.asset('assets/svg/point.svg'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sp4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Giảm từ điểm: ',
                          style:
                              s12w400.copyWith(color: AppColors.text_tertiary),
                        ),
                        Text(
                          '${moneyExchange.moneyExchange.formatCurrency}đ',
                          style:
                              s14w500.copyWith(color: AppColors.text_primary),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'Số điểm còn lại',
                            style: s12w400.copyWith(
                                color: AppColors.text_tertiary),
                          ),
                        ),
                        sp8.width,
                        Text(
                          (widget.point - _totalPointUsed).formatCurrency,
                          style:
                              s12w500.copyWith(color: AppColors.text_primary),
                        ),
                        sp4.width,
                        SvgPicture.asset('assets/svg/point.svg'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          12.height,
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
                    if (widget.point - _totalPointUsed < 0) {
                      ToastCustom.show(
                        context,
                        title: 'Thất bại',
                        msg: 'Điểm của bạn chưa đủ để quy đổi',
                        svgIcon: Assets.svgError,
                        color: AppColors.red50,
                        timeClose: 2.seconds,
                      );
                      return;
                    }
                    widget.callBack?.call(
                      moneyExchange: moneyExchange,
                      productsFromPackage: productsFromPackage,
                      productsSelected: productsSelected
                          .where((e) => e.quantity != 0)
                          .toList(),
                    );
                    Navigator.of(context).pop();
                  },
                  radius: sp48,
                ),
              ),
            ],
          ),
        ],
      ).padding(const EdgeInsets.all(sp16)),
    );
  }

  Widget get _productExchangeView {
    return Column(
      children: [
        _buildSearch(),
        sp12.height,
        Text(
          'Danh sách sản phẩm đổi điểm:',
          style: s14w500.copyWith(color: AppColors.text_tertiary),
        ),
        const Divider(height: sp24),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final item = productsSelected[index];
              return _itemSeleted(item);
            },
            separatorBuilder: (context, index) => 12.height,
            itemCount: productsSelected.length,
          ),
        ),
      ],
    );
  }

  Widget get _moneyExchangeView {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: sp12,
      children: [
        Text(
          'Tỉ lệ quy đổi: ${_settingPoint.paymentExchangePoint} điểm = ${_settingPoint.paymentExchangeMoney.formatCurrency}đ',
          style: s14w400.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        Row(
          spacing: sp48,
          children: [
            Text(
              'Số điểm muốn sử dụng',
              style: s14w500.copyWith(
                color: AppColors.text_primary,
              ),
            ),
            InputQuantity(
              controller: _textPointCtl,
              max: _point.toInt(),
              // enabled: enabled,
              action: (value) {
                int point = moneyExchange.point?.toInt() ?? 0;
                point = point + (value ? 1 : -1);
                setState(() {
                  _textPointCtl.text = '$point';
                  moneyExchange = moneyExchange.copyWith(
                    point: point,
                    moneyExchange: point *
                        (_settingPoint.paymentExchangeMoney /
                            _settingPoint.paymentExchangePoint),
                  );
                });
              },
              onChanged: (point) {
                setState(() {
                  _textPointCtl.text = '$point';
                  moneyExchange = moneyExchange.copyWith(
                    point: point,
                    moneyExchange: point *
                        (_settingPoint.paymentExchangeMoney /
                            _settingPoint.paymentExchangePoint),
                  );
                });
              },
              onTapOutside: () {},
            ).expanded(),
          ],
        ),
        Text(
          '= ${moneyExchange.moneyExchange.formatCurrency}đ',
          textAlign: TextAlign.right,
          style: s14w400.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
      ],
    );
  }

  Widget get _productPackageView {
    return Column(
      children: [
        MainButtonV2(
          title: 'Chọn sản phẩm từ gói',
          backgroundColor: AppColors.button_brand_alpha_backgroundActive,
          textStyle: s14w500.copyWith(
            color: AppColors.button_brand_alpha_textDefault,
          ),
          radius: sp48,
          onTap: () {
            ListPackageBts.show(
              context,
              onCallback: (package) {
                final index = productsFromPackage.indexWhere(
                  (e) => e.id == package?.id,
                );
                if (index == -1 && package != null) {
                  productsFromPackage.add(package);
                } else if (index != -1 && package != null) {
                  productsFromPackage[index] = package;
                }
                setState(() {});
              },
            );
          },
        ),
        const Divider(height: sp24),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final item = productsFromPackage[index];
              return _itemPackage(
                item,
                (indexProduct) {
                  final listCopy = List<PointExchangePackageModel>.from(productsFromPackage);
                  listCopy[index]
                        .items?[indexProduct]
                        .product
                        ?.isSelected = false;
                  setState(() {
                    productsFromPackage = listCopy;
                  });
                },
              );
            },
            separatorBuilder: (context, index) => 12.height,
            itemCount: productsFromPackage.length,
          ),
        ),
      ],
    );
  }

  OverlayInput<ProductV2Model> _buildSearch() {
    return OverlayInput<ProductV2Model>(
      itemBuilder: (BuildContext context, item, int index) {
        return ProductListItem(
          model: item,
          showHead: false,
        );
      },
      onChanged: (item) {
        // _prodBloc.addProduct(item);
        setState(() {
          if (!productsSelected.contains(item)) {
            productsSelected.add(item.copyWith(quantity: 1));
          }
        });
      },
      hintText: 'Tìm tên, mã sản phẩm',
      itemHeight: 105,
      lazyLoad: (isMore) {
        return _prodBloc.getList(
          textCtrl.text,
          isMore: isMore,
          exchangeable: true,
        );
      },
      controller: textCtrl,
      borderRadius: 999,
      header: Text(
        'Chọn sản phẩm',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      elevation: 1,
      prefix: InkWell(
        onTap: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: 1.pading.copyWith(right: 0),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bg_secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(999),
                    bottomLeft: Radius.circular(999),
                  ),
                ),
                height: 48,
                width: 48,
                alignment: Alignment.center,
                child: FaIcon(iconCode: 'f465', type: FaIconType.solid),
              ),
            ),
            const VerticalDivider(
              color: AppColors.input_borderDefault,
              thickness: 1,
              width: 0,
            ).size(height: 48),
            8.width,
            const Icon(
              Icons.search,
              color: AppColors.input_iconDefault,
            ),
            4.width,
          ],
        ),
      ),
    );
  }

  Widget _itemSeleted(ProductV2Model item) {
    return Container(
      padding: const EdgeInsets.all(sp12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.border_tertiary,
        ),
        borderRadius: BorderRadius.circular(sp12),
      ),
      child: Row(
        children: [
          BaseCacheImage(
            loadPharmagoLogo: true,
            url: item.images?.firstOrNull?.url ?? '',
            width: 56,
            height: 56,
            borderRadius: 4.radius,
            fit: BoxFit.cover,
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodyBsMedium.copyWith(
                        height: 1.5,
                        color: AppColors.text_primary,
                      ),
                    ),
                  ),
                  12.width,
                  InkWell(
                    onTap: () {
                      setState(() {
                        productsSelected.remove(item);
                      });
                    },
                    child: FaIcon(iconCode: 'f1f8'),
                  ),
                ],
              ),
              8.height,
              Row(
                children: [
                  Text(
                    '${item.exchangePoint ?? 0}',
                    style: AppStyle.bodyBsSemiBold
                        .copyWith(color: AppColors.text_tertiary),
                  ),
                  sp8.width,
                  SvgPicture.asset('assets/svg/point.svg'),
                  const Spacer(),
                  Text(
                    'Tồn: ${item.unit.first.stockChange}',
                    style: AppStyle.bodyBsSemiBold
                        .copyWith(color: AppColors.text_tertiary),
                  ),
                ],
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppInputV2(
                    controller: TextEditingController(
                      text: (item.quantity ?? 0).toString(),
                    ),
                    hintText: '-',
                    textAlign: TextAlign.center,
                    radius: 6,
                    textInputType: TextInputType.number,
                    contentPadding: EdgeInsets.zero,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                    onConfirm: (value) {
                      item.quantity = int.tryParse(value) ?? 0;
                    },
                    prefixIcon: _iconAction(
                      icon: Icons.remove,
                      onTap: () {
                        if (item.quantity == null || item.quantity == 0) return;
                        if (item.quantity! - 1 == 0) return;
                        _quantityItemChange(item, item.quantity! - 1);
                      },
                    ),
                    suffixIcon: _iconAction(
                      icon: Icons.add,
                      isLeft: true,
                      onTap: () {
                        // if (item.quantity == null) return;
                        _quantityItemChange(item, (item.quantity ?? 0) + 1);
                      },
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(maxWidth: 32, maxHeight: 32),
                    suffixIconConstraints:
                        const BoxConstraints(maxWidth: 32, maxHeight: 32),
                    borderColor: AppColors.border_secondary,
                  ).size(height: 32, width: 100),
                ],
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  Widget _itemPackage(
    PointExchangePackageModel item,
    Function(int indexProduct) deleteCallBack,
  ) {
    return Column(
      children: [
        Row(
          spacing: sp4,
          children: [
            SvgPicture.asset('assets/svg/point.svg'),
            Text(
              '${item.point.formatCurrency} điểm',
              style: s14w700.copyWith(
                color: AppColors.text_primary,
              ),
            ),
            const Spacer(),
            Text(
              'Đổi từ',
              style: s12w400.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            Text(
              '${item.name}',
              style: s12w500.copyWith(
                color: AppColors.text_primary,
              ),
            ),
          ],
        ),
        ...(item.items ?? [])
            .where((e) => e.product?.isSelected == true)
            .map((e) {
          return Row(
            spacing: sp8,
            children: [
              GestureDetector(
                onTap: () {
                  final index = item.items
                      ?.indexWhere((i) => i.product?.id == e.product?.id);
                  if (index == null) return;
                  deleteCallBack.call(index);
                },
                child: const Icon(
                  Icons.remove_circle_rounded,
                  color: AppColors.icon_iconSecondary,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(sp4),
                child: Image.network(
                  e.product?.images?.firstOrNull?.url ??
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
                      e.product?.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: s14w500.copyWith(color: AppColors.text_primary),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${FormatCurrency(e.unit?.sellPrice)} đ',
                          style: p5.copyWith(color: blackColor),
                        ),
                        Text(
                          '/${e.unit?.name}',
                          style: p5.copyWith(color: blackColor),
                        ),
                        const Spacer(),
                        Text(
                          '${FormatCurrency(e.quantity)} ${e.unit?.name}',
                          style: p3.copyWith(color: mainColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  void _quantityItemChange(ProductV2Model item, int quantity) {
    final index = productsSelected.indexWhere((e) => e.id == item.id);
    setState(() {
      productsSelected[index] =
          productsSelected[index].copyWith(quantity: quantity);
    });
  }
}

InkWell _iconAction({
  required Function() onTap,
  required IconData icon,
  bool isLeft = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        border: Border(
          right: isLeft
              ? BorderSide.none
              : const BorderSide(
                  color: AppColors.border_secondary,
                  width: 1,
                ),
          left: !isLeft
              ? BorderSide.none
              : const BorderSide(
                  color: AppColors.border_secondary,
                  width: 1,
                ),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 12,
        ),
      ),
    ),
  );
}
