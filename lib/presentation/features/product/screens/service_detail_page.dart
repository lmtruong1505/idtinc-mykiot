import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/features/product/cubit/service_detail_cubit/service_detail_cubit.dart';
import 'package:pharmago/presentation/features/product/widgets/service_detail/service_detail_extra.dart';
import 'package:pharmago/presentation/features/product/widgets/service_detail/service_detail_info_basic.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../../shared/style_app/color_app.dart';
import '../../../../shared/style_app/dimensions.dart';
import '../../../../shared/style_app/style_text.dart';
import '../../../base/cache_image.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../cubit/service_detail_cubit/service_detail_state.dart';
import '../widgets/service_detail/service_detail_reminder.dart';

@RoutePage()
class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({required this.id, super.key});

  final int id;

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  final myBloc = getIt.get<ServiceDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getDetail(widget.id),
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: BaseAppBar(
          title: 'Chi tiết dịch vụ',
          actions: [
            _buildMenu(),
          ],
        ),
        body: BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp16,
              ),
              height: heightDevice(context),
              width: widthDevice(context),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildOverview(),
                    16.height,
                    ServiceDetailInfoBasic(myBloc: myBloc),
                    gapHeight(sp16),
                    ServiceDetailReminder(myBloc: myBloc),
                    gapHeight(sp16),
                    ServiceDetailExtra(
                      myBloc: myBloc,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: Dimensions.sp8.radius,
      ),
      child: Padding(
        padding: Dimensions.sp16.pading,
        child: const Icon(
          Icons.more_vert_rounded,
          color: ColorApp.black,
        ),
      ),
      itemBuilder: (context) {
        return List.generate(
          MenuDetailService.values.length,
          (index) => PopupMenuItem(
            onTap: () {
              switch (MenuDetailService.values[index]) {
                case MenuDetailService.edit:
                  context.router
                      .push(
                        ServiceCreateV2Route(
                          service: myBloc.state.service,
                        ),
                      )
                      .then((value) => myBloc.getDetail(widget.id));
                  break;
                case MenuDetailService.remove:
                  handeDelete();
                  break;
              }
            },
            child: Text(
              MenuDetailService.values[index].name,
              textAlign: TextAlign.center,
              style: StyleApp.normal(),
            ),
          ),
        );
      },
    );
  }

  _buildOverview() {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radius,
      ),
      child: ListTile(
        dense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2.5),
        leading: SizedBox(
          height: 42,
          width: 42,
          child: BaseCacheImage(
            url: (myBloc.state.service?.images?.isNotEmpty ?? false)
                ? (myBloc.state.service?.images?[0] ??
                    PrefKeys.imgProductDefault)
                : PrefKeys.imgProductDefault,
          ),
        ),
        trailing: Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: myBloc.state.service?.active == true
                ? ColorApp.green
                : ColorApp.red,
          ),
        ),
        title: Text(
          myBloc.state.service?.title ?? 'Chưa có thông tin',
          style: p5.copyWith(
            color: blackColor,
          ),
        ),
        subtitle: Text(
          myBloc.state.service?.code ?? 'Chưa có thông tin',
          style: p6.copyWith(
            color: greyColor,
          ),
        ),
      ),
    );
  }

  void handeDelete() {
    DialogUtils.showLoadingDialog(context, 'Đang xử lý...');
    myBloc.deleteService(widget.id).then((value) {
      context.pop();
      if (value.code == 200) {
        context.pop();
        DialogUtils.showSuccessDialog(
          context,
          content: 'Xóa dịch vụ thành công',
          barrierDismissible: true,
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Xoá dịch vụ thất bại',
        );
      }
    });
  }
}
