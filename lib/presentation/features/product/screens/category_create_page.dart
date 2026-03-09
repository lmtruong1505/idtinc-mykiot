import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/product/cubit/category_create_cubit/category_create_cubit.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

import '../../../base/app_bar.dart';
import '../../../base/dialog.dart';
import '../../../base/empty_container.dart';
import '../../../base/text_field.dart';
import '../../../base/two_button_box.dart';
import '../../../common/bts_select_product.dart';
import '../../../common/card_product_info.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';

@RoutePage()
class CategoryCreatePage extends StatefulWidget {
  const CategoryCreatePage({super.key});

  @override
  State<CategoryCreatePage> createState() => _CategoryCreatePageState();
}

class _CategoryCreatePageState extends State<CategoryCreatePage> {
  final myBloc = getIt.get<CategoryCreateCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCreateCubit>(
      create: (context) => myBloc,
      child: BlocBuilder<CategoryCreateCubit, CategoryCreateState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_6,
            appBar: const BaseAppBar(title: 'Thêm mới danh mục'),
            body: Container(
              height: heightDevice(context),
              width: widthDevice(context),
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp16,
              ),
              child: SingleChildScrollView(
                child: Column(
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
    DialogUtils.showLoadingDialog(context, 'Đang tạo danh mục mới');
    myBloc.create().then((value) {
      Navigator.of(context).pop();
      if (value?.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo thương hiệu thành công',
          titleClose: 'Danh sách',
          titleConfirm: 'Chi tiết',
          accept: () {
            context.router.popUntil(
              (route) => route.settings.name == 'CategoryListRoute',
            );
            context.navPush(
              BrandDetailRoute(
                id: value?.data ?? 0,
              ),
            );
          },
          close: () {
            context.router.popUntil(
              (route) => route.settings.name == 'CategoryListRoute',
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
