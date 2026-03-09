import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/dotted_border_button.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/create_warehouse_receipt_cubit.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/create/tab_images.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/bts_choose_image.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class CreateReceiptInfor extends StatefulWidget {
  const CreateReceiptInfor({
    super.key,
    required this.bloc,
    required this.inforKey,
  });
  final CreateWarehouseReceiptCubit bloc;
  final GlobalKey<FormState> inforKey;
  @override
  State<CreateReceiptInfor> createState() => _CreateReceiptInforState();
}

class _CreateReceiptInforState extends State<CreateReceiptInfor>
    with AutomaticKeepAliveClientMixin {
  final codeCtrl = TextEditingController();
  final providerCtrl = TextEditingController();
  final inputDateCtrl =
      TextEditingController(text: DateTime.now().fomatCustom());
  final warehouseCtrl = TextEditingController();
  final reasionCtrl = TextEditingController();

  @override
  void dispose() {
    codeCtrl.dispose();
    inputDateCtrl.dispose();
    warehouseCtrl.dispose();
    reasionCtrl.dispose();
    providerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = widget.bloc;
    return BlocListener<CreateWarehouseReceiptCubit, CubitState>(
      listener: (context, state) {
        if (state.status == BlocStatus.submitSuccess) {
          codeCtrl.clear();
          inputDateCtrl.clear();
          warehouseCtrl.clear();
          reasionCtrl.clear();
          providerCtrl.clear();
          bloc.addLot();
        }
      },
      child: Form(
        key: widget.inforKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                visible: false,
                child: InputColumn(
                  controller: codeCtrl,
                  label: 'Mã phiếu',
                  isRequired: true,
                  padding: 0.pading,
                  maxLength: 30,
                  onChanged: (val) {
                    bloc.code = val;
                  },
                  validate: (value) {
                    if (value == null || value == '') {
                      return 'Nhập mã phiếu';
                    }
                    return null;
                  },
                ),
              ),
              16.height,
              InputColumn(
                controller: inputDateCtrl,
                readOnly: true,
                label: 'Ngày nhập',
                isRequired: true,
                padding: 0.pading,
                maxLength: 30,
                onTap: () {
                  final date = inputDateCtrl.text.toDateV2;
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    locale: const Locale('vi'),
                  ).then((value) {
                    if (value != null) {
                      inputDateCtrl.text = value.fomatCustom();
                      bloc.startDate = inputDateCtrl.text;
                    }
                  });
                },
                suffixIcon: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(child: FaIcon(iconCode: 'f133')),
                ),
                validate: (value) {
                  if (value == null || value == '') {
                    return 'Nhập ngày nhập';
                  }
                  return null;
                },
              ),
              16.height,
              BlocBuilder<CreateWarehouseReceiptCubit, CubitState>(
                bloc: bloc,
                builder: (context, state) {
                  return CommonDropdown(
                    showIconRemove: false,
                    value: bloc.warehouse,
                    borderColor: AppColors.input_borderDefault,
                    items: List.generate(
                      bloc.listWareHouse.length,
                      (index) => DropdownMenuItem(
                        value: bloc.listWareHouse[index],
                        child: Text(
                          bloc.listWareHouse[index].title ?? '',
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      bloc.warehouse = value;
                    },
                    required: true,
                    label: 'Kho nhập',
                    hintText: 'Chọn kho nhập',
                    color: AppColors.white,
                  );
                },
              ),
              16.height,
              InputColumn(
                label: 'Lý do nhập',
                padding: 0.pading,
                maxLength: 30,
                onChanged: (val) {
                  bloc.reason = val;
                },
              ),
              16.height,
              InputColumn(
                controller: providerCtrl,
                label: 'Người cung cấp',
                padding: 0.pading,
                maxLength: 30,
                onChanged: (val) {
                  bloc.provider = val;
                },
                validate: (value) {},
              ),
              16.height,
              BlocBuilder<CreateWarehouseReceiptCubit, CubitState>(
                bloc: bloc,
                builder: (context, state) {
                  return CommonDropdown(
                    showIconRemove: false,
                    value: bloc.userCheck,
                    borderColor: AppColors.input_borderDefault,
                    items: List.generate(
                      bloc.listUser.length,
                      (index) => DropdownMenuItem(
                        value: bloc.listUser[index],
                        child: Text(
                          bloc.listUser[index].fullName ?? '',
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      bloc.userCheck = value;
                    },
                    required: true,
                    label: 'Người kiểm tra',
                    hintText: 'Chọn tài khoản',
                    color: AppColors.white,
                  );
                },
              ),
              16.height,
              Row(
                children: [
                  const Text(
                    'Tài liệu đi kèm',
                    style: s14w500,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => chooseImages(showCamera: false),
                    child: BaseContainer(
                      borderColor: AppColors.green20,
                      width: 32,
                      height: 32,
                      borderRadius: 999,
                      color: AppColors.green60,
                      child: Center(
                        child: FaIcon(iconCode: 'f093', color: AppColors.white),
                      ),
                    ),
                  ),
                  8.width,
                  GestureDetector(
                    onTap: () => chooseImages(showGalary: false),
                    child: BaseContainer(
                      borderColor: AppColors.text_tertiary,
                      width: 32,
                      height: 32,
                      borderRadius: 999,
                      color: AppColors.white,
                      child: Center(
                        child: FaIcon(
                          iconCode: 'f030',
                          color: AppColors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              8.height,
              Visibility(
                visible: false,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UploadButton(
                      preIcon:
                          FaIcon(iconCode: 'f093', color: AppColors.blue60),
                      subIcon:
                          FaIcon(iconCode: 'f093', color: AppColors.blue60),
                      title: 'Tải lên tài liệu',
                      onTap: () {
                        chooseImages(showCamera: false);
                      },
                    ).expanded(),
                    const SizedBox(width: sp16),
                    GestureDetector(
                      onTap: () => chooseImages(showGalary: false),
                      child: BaseContainer(
                        borderColor: AppColors.green20,
                        width: 48,
                        height: 48,
                        borderRadius: 999,
                        color: AppColors.green20,
                        child: Center(
                          child: FaIcon(
                            iconCode: 'f030',
                            color: AppColors.brand,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<CreateWarehouseReceiptCubit, CubitState>(
                bloc: bloc,
                builder: (context, state) {
                  return Column(
                    children: [
                      Visibility(
                        visible: bloc.images.isNotEmpty,
                        child: MainButtonV2(
                          title: 'Sử dụng AI để lấy sản phẩm',
                          onTap: () => bloc.getPrdsFromAI(context),
                        ),
                      ),
                      ...List.generate(
                        bloc.images.length,
                        (index) {
                          return ItemImage(
                            index: index,
                            files: bloc.images,
                            onTap: () {
                              bloc.removeFile(index);
                            },
                          ).padding(8.padingVer);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ).padding(16.pading),
        ),
      ),
    );
  }

  void chooseImages({
    bool showCamera = true,
    bool showGalary = true,
  }) {
    final images = widget.bloc.images;
    final bloc = widget.bloc;
    if (bloc.images.length >= 4) {
      ToastCustom.show(
        context,
        title: 'Cảnh báo',
        msg: 'Tối đa 4 ảnh đại diện',
        svgIcon: Assets.svgWarningOutline,
        color: AppColors.ultility_negative_60,
      );
      return;
    }
    BtsChooseImage.show(
      context,
      limit: 4 - images.length,
      showCamera: showCamera,
      showGalary: showGalary,
    ).then(
      (value) {
        if (value is List<XFile>) {
          for (final element in value) {
            if (images.length < 4) {
              bloc.addFiles(element);
            }
          }
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
