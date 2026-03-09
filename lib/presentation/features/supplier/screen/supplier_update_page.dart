import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/screens/select_address.dart';
import 'package:pharmago/presentation/features/supplier/cubit/supplier_cubit.dart';
import 'package:pharmago/presentation/features/supplier/cubit/supplier_state.dart';

@RoutePage()
class SupplierUpdatePage extends StatefulWidget {
  final int? id;
  const SupplierUpdatePage({super.key, this.id});

  @override
  State<SupplierUpdatePage> createState() => _SupplierUpdatePageState();
}

class _SupplierUpdatePageState extends State<SupplierUpdatePage> {
  final myBloc = getIt.get<SupplierCubit>();
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: bg_5,
          appBar: BaseAppBar(
            title: widget.id != null
                ? 'Chỉnh sửa nhà cung cấp'
                : 'Tạo mới nhà cung cấp',
          ),
          body: Container(
            padding: const EdgeInsets.all(sp16),
            child: BlocProvider<SupplierCubit>(
              create: (context) => myBloc..getDetail(context, widget.id),
              child: BlocBuilder<SupplierCubit, SupplierState>(
                builder: (context, state) {
                  if (widget.id != null && state.supplier.id == null) {
                    return Container();
                  }
                  return SingleChildScrollView(
                    controller: myBloc.scrollController,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text('Nhà cung cấp', style: p3),
                            ),
                            const Divider(height: 15, color: borderColor_2),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Mã nhà cung cấp',
                              hintText: 'Nhập mã nhà cung cấp',
                              initialValue: state.supplier.code,
                              onChanged: myBloc.changeCode,
                              backgroundColor: whiteColor,
                              borderColor: whiteColor,
                            ),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Tên nhà cung cấp',
                              hintText: 'Nhập tên nhà cung cấp',
                              required: true,
                              initialValue: state.supplier.name,
                              onChanged: myBloc.changeName,
                              backgroundColor: whiteColor,
                              borderColor: whiteColor,
                            ),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Tên đại diện nhà cung cấp',
                              hintText: 'Nhập thên đại diện nhà cung cấp',
                              required: true,
                              initialValue: state.supplier.deputyName,
                              onChanged: myBloc.changeDeputyName,
                              backgroundColor: whiteColor,
                              borderColor: whiteColor,
                            ),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Số điện thoại nhà cung cấp',
                              hintText: 'Nhập số điện thoại',
                              required: true,
                              initialValue: state.supplier.phone,
                              onChanged: myBloc.changePhone,
                              backgroundColor: whiteColor,
                              borderColor: whiteColor,
                            ),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Số điện thoại đại diện',
                              hintText: 'Nhập số điện thoại',
                              required: true,
                              initialValue: state.supplier.phone,
                              onChanged: myBloc.changePhone,
                              backgroundColor: whiteColor,
                              borderColor: whiteColor,
                            ),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Địa chỉ',
                              hintText: 'Nhập địa chỉ',
                              readOnly: true,
                              backgroundColor: whiteColor,
                              borderColor: whiteColor,
                              suffixIcon: const Icon(
                                Icons.pin_drop_rounded,
                                color: greyTextColor,
                              ),
                              controller: TextEditingController(
                                text: SelectAddressView.formatAddress(
                                  state.supplier.address,
                                ),
                              ),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(sp16),
                                  ),
                                ),
                                builder: (context) => SizedBox(
                                  height: 0.9 * heightDevice(context),
                                  child: SelectAddressView(
                                    onConfirm: myBloc.updateAddress,
                                  ),
                                ),
                              ),
                            ),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Email',
                              hintText: 'Nhập emmail',
                              initialValue: state.supplier.email,
                              onChanged: myBloc.changeEmail,
                              backgroundColor: whiteColor,
                              borderColor: whiteColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
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
                gapHeight(sp12),
                Expanded(
                  child: MainButton(
                    title: widget.id != null ? 'Lưu lại' : 'Tạo mới',
                    event: () => widget.id != null
                        ? myBloc.update(context)
                        : myBloc.create(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
