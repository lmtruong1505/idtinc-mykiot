import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../base/button.dart';
import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../cubit/product_create_cubit/product_create_cubit.dart';
import '../../cubit/product_create_cubit/product_create_state.dart';

class IngredientFormView extends StatefulWidget {
  const IngredientFormView({
    super.key,
    required this.myBloc,
  });

  final ProductCreateCubit myBloc;

  @override
  State<IngredientFormView> createState() => _IngredientFormViewState();
}

class _IngredientFormViewState extends State<IngredientFormView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCreateCubit, ProductCreateState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(sp12)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    _buildInfo(state),
                    8.height,
                    const Divider(
                      color: borderColor_1,
                    ),
                    _buildList(state),
                    Visibility(
                      visible: state.ingredientPayload.isNotEmpty,
                      child: gapHeight(sp16),
                    ),
                    _buildAddBtn(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(ProductCreateState state) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: blue_2,
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bản ghi thành phần',
                    style: p5.copyWith(color: blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      widget.myBloc.removeingredient(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: yellow_1,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Đã xoá thành phần',
                            style: p5.copyWith(
                              color: whiteColor,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: sp48 - sp8,
                      height: sp48 - sp8,
                      decoration: BoxDecoration(
                        color: red_2.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(sp8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: sp16,
                          color: red_1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              gapHeight(sp16),
              AppInput(
                label: 'Tên thành phần',
                required: true,
                hintText: 'Nhập tên thành phần',
                backgroundColor: whiteColor,
                borderColor: whiteColor,
                initialValue: state.ingredientPayload[index].name,
                textInputType: TextInputType.text,
                onChanged: (value) {
                  widget.myBloc.ingredientFormChange(
                    index: index,
                    name: value,
                  );
                },
                validate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nhập tên thành phần';
                  }
                },
              ),
              gapHeight(sp12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppInput(
                      label: 'Trọng lượng',
                      hintText: 'Nhập trọng lượng',
                      initialValue: state.ingredientPayload[index].weight != null
                          ? state.ingredientPayload[index].weight.toString()
                          : '',
                      backgroundColor: whiteColor,
                      borderColor: whiteColor,
                      textInputType: TextInputType.number,
                      onChanged: (value) {
                        widget.myBloc.ingredientFormChange(
                          index: index,
                          weight: value,
                        );
                      },
                    ),
                  ),
                  gapWidth(sp16),
                  Expanded(
                    flex: 2,
                    child: AppInput(
                      label: 'Đơn vị',
                      hintText: 'g',
                      initialValue: state.ingredientPayload[index].unit,
                      backgroundColor: whiteColor,
                      borderColor: whiteColor,
                      onChanged: (value) {
                        widget.myBloc.ingredientFormChange(
                          index: index,
                          unit: value,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => gapHeight(sp16),
      itemCount: state.ingredientPayload.length,
    );
  }

  Widget _buildAddBtn() {
    return SizedBox(
      width: double.infinity,
      child: ExtraButton(
        largeButton: false,
        title: 'Thêm thành phần',
        icon: const Icon(
          Icons.add_rounded,
          size: sp16,
          color: blackColor,
        ),
        event: widget.myBloc.addIngredient,
        borderRadius: 8,
        backgroundColor: borderColor_1,
      ),
    );
  }

  Widget _buildInfo(ProductCreateState state) {
    return Row(
      children: [
        Expanded(
          child: _buildInput(
            title: 'Tên thành phần ',
            onChange: (value) {
              
            },
          ),
        ),
        8.width,
        Expanded(
          child: _buildInput(
            title: 'Trọng lượng (gr)',
            onChange: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildInput({
    required String title,
    bool isRequired = false,
    Function()? onTap,
    Function(String)? onChange,
    TextEditingController? controller,
    Icon? suffixIcon,
  }) {
    return AppInputSupport(
      label: title,
      hintText: 'Nhập ${title.toLowerCase()}',
      backgroundColor: whiteColor,
      borderColor: borderColor_2,
      onChanged: onChange,
      onTap: onTap,
      required: isRequired,
      controller: controller,
      readOnly: onTap != null,
      suffixIcon: suffixIcon,
      validate: (value) {
        if ((value?.isEmpty ?? true) && isRequired) {
          return 'Yêu cầu nhập ${title.toLowerCase()}  $isRequired';
        }
        return null;
      },
    );
  }
}
