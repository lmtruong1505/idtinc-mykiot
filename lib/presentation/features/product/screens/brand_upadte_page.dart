import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/two_button_box.dart';
import 'package:pharmago/presentation/common/bts_select_product.dart';
import 'package:pharmago/presentation/common/card_product_info.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

import '../../../base/app_bar.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../cubit/brand_update_cubit/brand_update_cubit.dart';
import '../cubit/brand_update_cubit/brand_update_state.dart';

@RoutePage()
class BrandUpdatePage extends StatefulWidget {
  const BrandUpdatePage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<BrandUpdatePage> createState() => _BrandUpdatePageState();
}

class _BrandUpdatePageState extends State<BrandUpdatePage> {
  final myBloc = getIt.get<BrandUpdateCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrandUpdateCubit>(
      create: (context) => myBloc..getDetail(widget.id),
      child: BlocBuilder<BrandUpdateCubit, BrandUpdateState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_6,
            appBar: const BaseAppBar(title: 'Chỉnh sửa thương hiệu'),
            body: Container(
              height: heightDevice(context),
              width: widthDevice(context),
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp16,
              ),
              child: SingleChildScrollView(
                child: state.isLoading
                    ? const BaseLoading()
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(sp16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp12),
                              color: whiteColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppInput(
                                  initialValue: state.brand?.code ?? '',
                                  label: 'Mã thương hiệu',
                                  hintText: 'Nhập mã thương hiệu',
                                  backgroundColor: bg_5,
                                  borderColor: bg_5,
                                  onChanged: (value) =>
                                      myBloc.infoChange(code: value),
                                ),
                                gapHeight(sp4),
                                Padding(
                                  padding: const EdgeInsets.only(left: sp24),
                                  child: Text(
                                    'Tối đa 50 ký tự',
                                    style: p6.copyWith(color: blackColor),
                                  ),
                                ),
                                gapHeight(sp12),
                                AppInput(
                                  initialValue: state.brand?.name ?? '',
                                  label: 'Tên thương hiệu',
                                  hintText: 'Nhập tên thương hiệu',
                                  backgroundColor: bg_5,
                                  borderColor: bg_5,
                                  required: true,
                                  onChanged: (value) =>
                                      myBloc.infoChange(name: value),
                                ),
                                gapHeight(sp4),
                                Padding(
                                  padding: const EdgeInsets.only(left: sp24),
                                  child: Text(
                                    'Tối đa 50 ký tự',
                                    style: p6.copyWith(color: blackColor),
                                  ),
                                ),
                                gapHeight(sp12),
                                AppInput(
                                  initialValue: state.brand?.description ?? '',
                                  label: 'Mô tả',
                                  hintText: 'Nhập mô tả',
                                  backgroundColor: bg_5,
                                  borderColor: bg_5,
                                  onChanged: (value) =>
                                      myBloc.infoChange(note: value),
                                ),
                              ],
                            ),
                          ),
                          gapHeight(sp16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gắn sản phẩm',
                                style: h6.copyWith(color: blackColor),
                              ),
                              TextButton(
                                onPressed: () => showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(sp12),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return BtsSelectProduct(
                                      initValue: state.products,
                                      onConfirm: myBloc.productSelect,
                                    );
                                  },
                                ),
                                child: const Text('Gắn sản phẩm'),
                              ),
                            ],
                          ),
                          gapHeight(sp8),
                          AppInputSupport(
                            hintText: 'Tìm kiếm sản phẩm',
                            backgroundColor: whiteColor,
                          ),
                          gapHeight(sp16),
                          state.products.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final product = state.products[index];
                                    return CardProductInfo(
                                      product: product,
                                      onDelete: myBloc.productRemove,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      gapHeight(sp16),
                                  itemCount: state.products.length,
                                )
                              : const EmptyContainer(),
                        ],
                      ),
              ),
            ),
            bottomNavigationBar: TwoButtonBox(
              mainTitle: 'Tạo mới',
              extraTitle: 'Huỷ bỏ',
              extraOnTap: () => Navigator.of(context).pop(),
              mainOnTap: _createHandle,
            ),
          );
        },
      ),
    );
  }

  void _createHandle() {
    DialogUtils.showLoadingDialog(context, 'Đang tạo thương hiệu mới');
    myBloc.update().then((value) {
      Navigator.of(context).pop();
      if (value?.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo thương hiệu thành công',
          titleClose: 'Danh sách',
          titleConfirm: 'Chi tiết',
          accept: () {
            context.router.popUntil(
              (route) => route.settings.name == 'BrandRoute',
            );
            context.navPush(
              BrandDetailRoute(
                id: value?.data ?? 0,
              ),
            );
          },
          close: () {
            context.router.popUntil(
              (route) => route.settings.name == 'BrandRoute',
            );
          },
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Tạo thương hiệu thất bại\n${value?.message}',
        );
      }
    });
  }
}
