import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_cubit.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/features/product/widgets/service_create/service_unit_form_view.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/button.dart';
import '../../../base/cache_image.dart';
import '../../../base/dialog.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../cubit/service_create_cubit/service_create_state.dart';
import '../widgets/service_create/service_infor_basic_view.dart';

@RoutePage()
class ServiceCreatePage extends StatefulWidget {
  const ServiceCreatePage({super.key});

  @override
  State<ServiceCreatePage> createState() => _ServiceCreatePageState();
}

class _ServiceCreatePageState extends State<ServiceCreatePage> {
  final myBloc = getIt.get<ServiceCreateCubit>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc,
      child: BlocBuilder<ServiceCreateCubit, ServiceCreateState>(
        builder: (BuildContext context, ServiceCreateState state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: bg_5,
              appBar: const BaseAppBar(
                title: 'Tạo dịch vụ',
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp24,
                  horizontal: sp16,
                ),
                height: heightDevice(context),
                width: widthDevice(context),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // ============= Info Basic Form =============
                        ServiceInfoBasicView(myBloc: myBloc),
                        gapHeight(sp16),

                        // ============= Unit Form =============
                        ServiceUnitFormView(
                          myBloc: myBloc,
                        ),
                        gapHeight(sp16),

                        //ServiceAttachProduct(canAdd: true, myBloc: myBloc, ),
                        _buildAttachProduct(myBloc),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
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
                padding: const EdgeInsets.all(sp16),
                width: double.infinity,
                child: MainButton(
                  title: 'Xác nhận',
                  event: _createServiceHandle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _createServiceHandle() {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang tạo dịch vụ...');
    myBloc.createService().then((value) {
      Navigator.pop(context);
      if (value?.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo dịch vụ thành công',
          titleClose: 'Danh sách dịch vụ',
          titleConfirm: 'Chi tiết',
          close: () {
            context.router.popUntil(
                  (route) => route.settings.name == 'ServiceListRoute',
            );
          },
          accept: () {
            context.router.popUntil(
              (route) => route.settings.name == 'ServiceListRoute',
            );
            context.router.push(
              ServiceDetailRoute(id: value?.data),
            );
          },
        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo dịch vụ thất bại \n ${value?.message}',
      );
    });
  }

  Widget _buildAttachProduct(ServiceCreateCubit myBloc) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Danh sách danh mục',
                style: p3.copyWith(color: blackColor),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      context.router.push(
                        ServiceSelectionProductRoute(
                          serviceCreateCubit: myBloc,
                        ),
                      );
                    },
                    child: Text(
                      'Chọn sản phẩm',
                      style: p5.copyWith(color: blue_1),
                    ),
                  ),
                  gapWidth(sp8),
                ],
              ),
            ],
          ),
          gapHeight(sp16),
          AppInputSupport(
            hintText: 'Tìm kiếm theo tên/mã',
            prefixIcon: const Icon(Icons.search_rounded),
            backgroundColor: whiteColor,
            onChanged: (value) {

            },
          ),
          gapHeight(sp16),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: myBloc.state.variantSearchPayload.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final item = myBloc.state.variantPayload[index];
          //     return Container(
          //       padding: const EdgeInsets.all(sp16),
          //       decoration: BoxDecoration(
          //         color: whiteColor,
          //         borderRadius: BorderRadius.circular(sp12),
          //         boxShadow: [
          //           BoxShadow(
          //             color: blackColor.withOpacity(0.1),
          //             offset: const Offset(1, 1),
          //             blurRadius: 1,
          //           ),
          //         ],
          //       ),
          //       child: Column(
          //         children: [
          //           _buildVariant(item),
          //           gapHeight(sp16),
          //           RowItem(
          //             title: 'Giá nhập',
          //             content: FormatCurrency(item.priceSell ?? 0),
          //           ),
          //           gapHeight(sp12),
          //           const RowItem(title: 'Số lượng', content: 'Fix'),
          //           gapHeight(sp12),
          //           const RowItem(title: 'Tổng tiền', content: 'Fix'),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildVariant(VariantEntity item) {
    return SizedBox(
      width: widthDevice(context),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: SizedBox(
          height: sp48,
          width: sp48,
          child: BaseCacheImage(
            url: (item.media?.isNotEmpty ?? false)
                ? (item.media ?? PrefKeys.imgProductDefault)
                : PrefKeys.imgProductDefault,
          ),
        ),
        title: Text(
          item.name ?? '',
          style: p5.copyWith(
            color: blue_3,
          ),
        ),
        subtitle: Text(
          item.code ?? '',
          style: p6.copyWith(
            color: greyColor,
          ),
          maxLines: 2,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: () {
            //myBloc.removeVariant(index);
          },
        ),
      ),
    );
  }
}
