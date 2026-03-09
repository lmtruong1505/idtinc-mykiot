import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../cubit/product_create_cubit/product_create_cubit.dart';
import '../../cubit/product_create_cubit/product_create_state.dart';
import 'bts_chose_brand.dart';
import 'bts_chose_category.dart';
import 'bts_chose_company_pharma.dart';
import 'bts_chose_product_type.dart';

class InfoExtraFormView extends StatefulWidget {
  const InfoExtraFormView({
    super.key,
    required this.myBloc,
  });

  final ProductCreateCubit myBloc;

  @override
  State<InfoExtraFormView> createState() => _InfoExtraFormViewState();
}

class _InfoExtraFormViewState extends State<InfoExtraFormView> with AutomaticKeepAliveClientMixin{
  late ExpandableController expandableController;

  @override
  void initState() {
    expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ProductCreateCubit, ProductCreateState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(sp8),
                margin: const EdgeInsets.all(sp8),
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
                  children: [
                    AppInputSupport(
                      controller: TextEditingController(
                        text: state.brandSelected?.name ?? '',
                      ),
                      required: false,
                      label: 'Thương hiệu',
                      hintText: 'Chọn thương hiệu',
                      backgroundColor: whiteColor,
                      borderColor: borderColor_2,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                      readOnly: true,
                      onTap: () => showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(sp12),
                          ),
                        ),
                        enableDrag: false,
                        context: context,
                        builder: (context) => BTSChoseBrand(
                          brandSelected: state.brandSelected,
                          onConfirm: (value) {
                            widget.myBloc.selectBrand(value);
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                    gapHeight(sp12),
                    AppInputSupport(
                      controller: TextEditingController(
                        text: state.categorySelected?.name ?? '',
                      ),
                      label: 'Danh mục sản phẩm',
                      hintText: 'Chọn danh mục sản phẩm',
                      backgroundColor: whiteColor,
                      borderColor: borderColor_2,
                      textInputType: TextInputType.text,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                      readOnly: true,
                      onTap: () => showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(sp12),
                          ),
                        ),
                        enableDrag: false,
                        context: context,
                        builder: (context) => BTSChoseCategory(
                          categorySelected: state.categorySelected,
                          onConfirm: (value) {
                            widget.myBloc.selectCategory(value);
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                    gapHeight(sp12),
                    AppInputSupport(
                      controller: TextEditingController(
                        text: state.productTypeEntity?.name ?? '',
                      ),
                      label: 'Loại sản phẩm',
                      hintText: 'Chọn loại sản phẩm',
                      backgroundColor: whiteColor,
                      borderColor: borderColor_2,
                      textInputType: TextInputType.text,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                      readOnly: true,
                      onTap: () => showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(sp12),
                          ),
                        ),
                        enableDrag: false,
                        context: context,
                        builder: (context) => BTSChoseProductType(
                          productTypeEntity: state.productTypeEntity,
                          onConfirm: (value) {
                            widget.myBloc.selectProductType(value);
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                    _buildInput(
                      title: 'Liều dùng và cách dùng',
                      initialValue: state.productPayload.lieuDung,
                      onChange: (value) {
                        widget.myBloc.infoFormChange(
                          lieuDung: value,
                        );
                      },
                    ),
                    _buildInput(
                      title: 'Chỉ định',
                      initialValue: state.productPayload.chongChiDinh,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        chiDinh: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Chống chỉ định',
                      initialValue: state.productPayload.chongChiDinh,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        chongChiDinh: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Công dụng',
                      initialValue: state.productPayload.congDung,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        congDung: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Lưu ý thận trọng',
                      initialValue: state.productPayload.thanTrong,
                      onChange: (value) {
                        widget.myBloc.infoFormChange(thanTrong: value);
                      },
                    ),
                    _buildInput(
                      title: 'Hình thức',
                      onChange: (value) {
                        widget.myBloc.infoFormChange(hinhThuc: value);
                      },
                    ),
                    _buildInput(
                      title: 'Tác dụng phụ',
                      initialValue: state.productPayload.tacDungPhu,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        tacDungPhu: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Tương tác thuốc',
                      initialValue: state.productPayload.tuongTac,
                        onChange: (value) => widget.myBloc.infoFormChange(
                          tuongTac: value,
                        )
                    ),
                    _buildInput(
                      title: 'Bảo quản',
                      initialValue: state.productPayload.baoQuan,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        baoQuan: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Hình thức đóng gói',
                      initialValue: state.productPayload.dongGoi,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        dongGoi: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Nơi sản xuất',
                      initialValue: state.productPayload.noiSx,
                      onChange: (value) {
                        widget.myBloc.infoFormChange(
                          noiSx: value,
                        );
                      },
                    ),
                    _buildInput(
                      title: 'Tương tác thuốc',
                      initialValue: state.productPayload.tuongTac,
                      onChange: (value) {
                        widget.myBloc.infoFormChange(
                          tuongTac: value,
                        );
                      },
                    ),
                    12.height,
                    AppInputSupport(
                      controller: TextEditingController(
                        text: state.congTySx?.name,
                      ),
                      label: 'Công ty sản xuất',
                      required: false,
                      hintText: 'Chọn công ty sản xuất',
                      backgroundColor: whiteColor,
                      borderColor: borderColor_2,
                      textInputType: TextInputType.text,
                      readOnly: true,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                      onTap: () => showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(sp12),
                          ),
                        ),
                        enableDrag: false,
                        context: context,
                        builder: (context) => BTSChoseCompanyPharma(
                          initData: state.congTySx,
                          onConfirm: (value) {
                            widget.myBloc.selectMasterData(congTySx: value);
                            FocusScope.of(context).unfocus();
                          },
                          type: TypeCompanyPharma.production,
                        ),
                      ),
                    ),
                    12.height,
                    AppInputSupport(
                      controller: TextEditingController(
                        text: state.congTyDk?.name,
                      ),
                      label: 'Công ty đăng ký',
                      required: false,
                      hintText: 'Chọn công ty đăng ký',
                      backgroundColor: whiteColor,
                      borderColor: borderColor_2,
                      textInputType: TextInputType.text,
                      readOnly: true,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                      onTap: () => showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(sp12),
                          ),
                        ),
                        enableDrag: false,
                        context: context,
                        builder: (context) => BTSChoseCompanyPharma(
                          initData: state.congTyDk,
                          onConfirm: (value) {
                            widget.myBloc.selectMasterData(congTyDk: value);
                            FocusScope.of(context).unfocus();
                          },
                          type: TypeCompanyPharma.registered,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInput({
    required String title,
    bool isRequired = false,
    Function()? onTap,
    Function(String)? onChange,
    TextEditingController? controller,
    Icon? suffixIcon,
    String? initialValue,
  }) {
    return AppInputSupport(
      label: title,
      hintText: 'Nhập ${title.toLowerCase()}',
      backgroundColor: whiteColor,
      borderColor: borderColor_2,
      initialValue: initialValue,
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
