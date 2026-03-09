import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_state.dart';

import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../product_create/bts_chose_brand.dart';
import '../product_create/bts_chose_company_pharma.dart';
class ServiceExtraView extends StatefulWidget {
  const ServiceExtraView({super.key, required this.myBloc});

  final ServiceCreateCubit myBloc;

  @override
  State<ServiceExtraView> createState() => _ServiceExtraViewState();
}

class _ServiceExtraViewState extends State<ServiceExtraView> {

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
    return BlocBuilder<ServiceCreateCubit, ServiceCreateState>(
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
                      validate: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng chọn công ty đăng ký';
                        }
                        return null;
                      },
                    ),
                    _buildInput(
                      title: 'Số quyết định',
                      isRequired: false,
                      initialValue: widget.myBloc.state.servicePayload.soQuyetDinh,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        soQuyetDinh: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Số đăng ký',
                      initialValue: widget.myBloc.state.servicePayload.soDangKy,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        soDangKy: value,
                      ),
                      isRequired: false,
                    ),
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
                      validate: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng chọn thương hiệu';
                        }
                        return null;
                      },
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
                    _buildInput(
                      title: 'Thời gian thực hiện',
                      initialValue: state.servicePayload.actionTime,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        actionTime: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Chỉ định',
                      initialValue: state.servicePayload.chongChiDinh,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        chiDinh: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Chống chỉ định',
                      initialValue: state.servicePayload.chongChiDinh,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        chongChiDinh: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Công dụng',
                      initialValue: state.servicePayload.congDung,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        congDung: value,
                      ),
                    ),
                    _buildInput(
                      title: 'Lưu ý thận trọng',
                      initialValue: state.servicePayload.luuY,
                      onChange: (value) {
                        widget.myBloc.infoFormChange(luuY: value);
                      },
                    ),
                    _buildInput(
                      title: 'Hình thức',
                      initialValue: state.servicePayload.hinhThuc,
                      onChange: (value) {
                        widget.myBloc.infoFormChange(hinhThuc: value);
                      },
                    ),
                    _buildInput(
                      title: 'Tác dụng phụ',
                      initialValue: state.servicePayload.tacDungPhu,
                      onChange: (value) => widget.myBloc.infoFormChange(
                        tacDungPhu: value,
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

  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
