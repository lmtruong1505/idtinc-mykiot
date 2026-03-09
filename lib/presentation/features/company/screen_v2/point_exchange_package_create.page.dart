import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:toastification/toastification.dart';

import '../../../../shared/components/input/overlay_input.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../base/app_bar.dart';
import '../../../base/two_button_box.dart';
import '../../../di/di.dart';
import '../../../features_v2/blocs/order_v2/product_selection_bloc.dart';
import '../../../features_v2/blocs/state/cubit_state.dart';
import '../../../features_v2/models/product/product_v2_model.dart';
import '../../../features_v2/screens/order/components/product_order_item.dart';
import '../../../features_v2/screens/product/components/product_list_item.dart';
import '../cubit/point_exchange_package_cubit/point_exchange_package_cubit.dart';

@RoutePage()
class PointExchangePackageCreatePage extends StatefulWidget {
  const PointExchangePackageCreatePage({super.key});

  @override
  State<PointExchangePackageCreatePage> createState() =>
      _PointExchangePackageCreatePageState();
}

class _PointExchangePackageCreatePageState
    extends State<PointExchangePackageCreatePage> {
  final _productSelectionBloc = getIt.get<ProductSelectionBloc>();
  final _pointExchangePackageCubit = getIt.get<PointExchangePackageCubit>();
  final _focusNode = FocusNode();
  final _searchCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PointExchangePackageCubit>(
      create: (context) => _pointExchangePackageCubit,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: const BaseAppBar(title: 'Tạo mới gói đổi điểm'),
          body: _bodyView,
        ),
      ),
    );
  }

  Widget get _bodyView {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(sp16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: sp16,
                children: [
                  Image.asset(
                    '${AssetsPath.image}/img_create_2.png',
                    width: widthDevice(context) / 5,
                  ),
                  InputColumn(
                    padding: const EdgeInsets.all(sp0),
                    isRequired: true,
                    label: 'Nhập tên gói',
                    onChanged: (p0) {
                      _pointExchangePackageCubit.stateChange(name: p0);
                    },
                  ),
                  InputColumn(
                    padding: const EdgeInsets.all(sp0),
                    isRequired: true,
                    label: 'Nhập số điểm',
                    textInputType: TextInputType.number,
                    onChanged: (p0) {
                      _pointExchangePackageCubit.stateChange(
                          point: int.tryParse(p0) ?? 0);
                    },
                  ),
                  InputColumn(
                    padding: const EdgeInsets.all(sp0),
                    label: 'Nhập mô tả',
                    minLines: 3,
                    maxLength: 3,
                    onChanged: (p0) {
                      _pointExchangePackageCubit.stateChange(note: p0);
                    },
                  ),
                  Text(
                    'Sản phẩm có thể chọn trong gói',
                    style: s20w700.copyWith(color: AppColors.text_primary),
                  ),
                  _buildSearch,
                  _buildHuongDan,
                  _buildList,
                ],
              ),
            ),
          ),
        ),
        TwoButtonBox(
          mainTitle: 'Áp dụng',
          extraTitle: 'Đặt lại',
          mainOnTap: () {
            toastification.show(
              title: const Text('Đang thực hiện thao tác'),
              type: ToastificationType.info,
              autoCloseDuration: const Duration(seconds: 3),
            );
            _pointExchangePackageCubit
                .createHandle(_productSelectionBloc.list)
                .then((e) {
              if (e != null) {
                toastification.show(
                  title: const Text('Tạo gói tích điểm thành công'),
                  type: ToastificationType.success,
                  autoCloseDuration: const Duration(seconds: 3),
                );
                if (mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                toastification.show(
                  title: const Text('Có lỗi xảy ra trong quá trình'),
                  type: ToastificationType.error,
                  autoCloseDuration: const Duration(seconds: 3),
                );
              }
            });
          },
          extraOnTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  OverlayInput<ProductV2Model> get _buildSearch {
    return OverlayInput<ProductV2Model>(
      controller: _searchCtl,
      itemBuilder: (BuildContext context, item, int index) {
        return ProductListItem(
          model: item,
          showHead: false,
        );
      },
      onChanged: (item) async {
        setState(() {
          _productSelectionBloc.addProduct(item);
        });
      },
      hintText: 'Tìm tên, mã sản phẩm',
      itemHeight: 105,
      lazyLoad: (isMore) {
        return _productSelectionBloc.getList(_searchCtl.text, isMore: isMore);
      },
      borderRadius: 999,
      header: Text(
        'Chọn sản phẩm',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      elevation: 1,
      prefix: const Icon(
        Icons.search,
        color: AppColors.input_iconDefault,
      ),
      focusNode: _focusNode,
    );
  }

  Widget get _buildList {
    return BlocBuilder<ProductSelectionBloc, CubitState>(
      bloc: _productSelectionBloc,
      builder: (context, state) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: _productSelectionBloc.list.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(_productSelectionBloc.list[index].id.toString()),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 1,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    onPressed: (context) =>
                        _productSelectionBloc.removeProduct(index),
                    backgroundColor: AppColors.ultility_negative_60,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Xóa',
                  ),
                ],
              ),
              child: ProductOrderItem(
                bloc: _productSelectionBloc,
                model: _productSelectionBloc.list[index],
                onUpdate: (model) => _productSelectionBloc.addProduct(model),
                onDelete: () => _productSelectionBloc.removeProduct(index),
                ghiChu: false,
                isShowShipmnet: false,
                isCheckStock: false,
              ),
            );
          },
          separatorBuilder: (context, index) => 8.height,
        );
      },
    );
  }

  Container get _buildHuongDan {
    return Container(
      padding: 8.padingVer + 12.padingHor,
      decoration: BoxDecoration(
        color: AppColors.bg_secondary,
        borderRadius: 8.radius,
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Trượt sang trái để xem thêm',
                  style: AppStyle.bodySmRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
                TextSpan(
                  text: '  Tùy chọn',
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
          ).expanded(),
          FaIcon(iconCode: 'f323', type: FaIconType.solid),
        ],
      ),
    );
  }
}
