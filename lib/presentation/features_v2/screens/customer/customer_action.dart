import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/customer_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/param/customer_param.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import '../../../features/customer/data/models/customer_model.dart';
import '../../blocs/customer/customer_manager_bloc.dart';
import 'components/action/infor_bank.dart';
import 'components/action/infor_contact.dart';
import 'components/action/infor_input.dart';
import 'components/action/infor_sub.dart';

@RoutePage()
class CustomerActionPage extends StatefulWidget {
  final CustomerModel? customer;
  const CustomerActionPage({
    this.customer,
  });
  @override
  State<CustomerActionPage> createState() => _CustomerActionPageState();
}

class _CustomerActionPageState extends State<CustomerActionPage> {
  final keyForm = GlobalKey<FormState>();

  final param = CustomerParam();
  // final fileBloc = FileBloc();

  final bloc = CustomerBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          isShowMsg: true,
          success: () {
            if (widget.customer != null) {
              context.read<CustomerManagerCubit>().getList();
            }
            context.pop(result: true);
          },
        );
      },
      child: Scaffold(
        backgroundColor: ColorApp.greyF5,
        appBar: BaseAppBar(
          title: widget.customer != null
              ? 'Cập nhật khách hàng'
              : 'Thêm mới khách hàng',
        ),
        bottomNavigationBar: _buildNavigationBar(),
        body: SingleChildScrollView(
          padding: Dimensions.sp16.pading,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: keyForm,
            onChanged: () {
              keyForm.currentState?.validate();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InforInput(
                  customer: widget.customer,
                  onChange: (p0) {
                    param.customer = p0;
                  },
                ),
                Dimensions.sp16.height,
                InforSubCustomer(
                  customer: widget.customer,
                  onChange: (p0) {
                    param.addition = p0;
                  },
                ),
                Dimensions.sp16.height,
                InforContactCustomer(
                  customer: widget.customer,
                  onChange: (p0) {
                    param.relation = p0;
                  },
                ),
                Dimensions.sp16.height,
                InforBankCustomer(
                  customer: widget.customer,
                  onChange: (p0) {
                    param.bank = p0;
                  },
                ),
                Dimensions.sp16.height,
                // BgAction(
                //   title: 'Thông tin tài liệu bệnh lý',
                //   click: true,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       BlocBuilder<FileBloc, CubitState>(
                //         bloc: fileBloc,
                //         builder: (context, state) {
                //           return Column(
                //             crossAxisAlignment: CrossAxisAlignment.stretch,
                //             children: List.generate(
                //               fileBloc.files.length,
                //               (index) => ItemFile(
                //                 file: fileBloc.files[index],
                //                 delete: () => fileBloc.remove(index),
                //               ),
                //             ),
                //           );
                //         },
                //       ),
                //       Dimensions.sp16.height,
                //       MainButton(
                //         title: 'Tải lên file',
                //         event: () {
                //           fileBloc.chooseFile();
                //         },
                //       ).padding(Dimensions.sp16.padingHor),
                //       Dimensions.sp16.height,
                //     ],
                //   ),
                // ),
                context.padding.bottom.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: Dimensions.sp16.pading + Dimensions.sp4.padingBottom,
      decoration: const BoxDecoration(
        color: ColorApp.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 20,
            offset: Offset(0, -10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomBtn(
              title: 'Huỷ bỏ',
              onPressed: () {
                context.pop();
              },
              textStyle: StyleApp.medium(),
              padding: Dimensions.sp12.pading,
              backgroundColor: Colors.transparent,
              side: const BorderSide(
                color: ColorApp.greyE2,
              ),
              fixedSize: const Size(
                double.infinity,
                45,
              ),
            ),
          ),
          Dimensions.sp16.width,
          Expanded(
            child: CustomBtn(
              title: 'Lưu lại',
              onPressed: () {
                if (keyForm.currentState?.validate() ?? false) {
                  bloc.create(
                    param,
                    id: widget.customer?.id,
                  );
                }
              },
              textStyle: StyleApp.medium(color: ColorApp.white),
              padding: Dimensions.sp12.pading,
              fixedSize: const Size(
                double.infinity,
                45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
