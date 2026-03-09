import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_cubit.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/presentation/features/product/widgets/service_create_v2/service_info_v2.dart';
import 'package:pharmago/presentation/features/product/widgets/service_create_v2/service_picture_view.dart';

import '../../../../base/button.dart';
import '../../../../base/dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../../router/router.gr.dart';
import '../../widgets/service_create_v2/service_extra_view.dart';
import '../../widgets/service_create_v2/service_remind_view.dart';

@RoutePage()
class ServiceCreateV2Page extends StatefulWidget {
  const ServiceCreateV2Page({super.key, this.service});

  final ServiceEntity? service;

  @override
  State<ServiceCreateV2Page> createState() => _ServiceCreateV2PageState();
}

class _ServiceCreateV2PageState extends State<ServiceCreateV2Page>
    with SingleTickerProviderStateMixin {

  late final TabController _tabController;
  final myBloc = getIt.get<ServiceCreateCubit>();
  final basicKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..init(widget.service, ),
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: blackColor,),
          ),
          title: Text(
            widget.service == null ? 'Tạo dịch vụ' : 'Cập nhật dịch vụ',
            style: h4.copyWith(fontWeight: BOLD, color: blackColor),
          ),
          centerTitle: true,
          backgroundColor: whiteColor,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: blackColor,
            indicatorColor: green_3,
            labelStyle: p5.copyWith(
              color: greyColor,
            ),
            tabAlignment: TabAlignment.center,
            tabs: const [
              Tab(text: 'Thông tin cơ bản'),
              Tab(text: 'Ảnh dịch vụ'),
              Tab(text: 'Cài đặt nhắc hẹn'),
              Tab(text: 'Thông tin bổ sung'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ServiceInfoV2(formKey: basicKey, myBloc: myBloc),
            ServicePictureView(myBloc: myBloc),
            ServiceRemindView(myBloc: myBloc),
            ServiceExtraView(myBloc: myBloc),
          ],
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
            event: () {
              if (widget.service == null) {
                _createServiceHandle();
              } else {
                _updateServiceHandle();
              }
            },
          ),
        ),
      ),
    );
  }
  void _createServiceHandle() {
    final validate = basicKey.currentState!.validate();
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

  void _updateServiceHandle() {
    final validate = basicKey.currentState!.validate();
    if (!validate) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang cập nhật dịch vụ...');
    myBloc.updateService().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Cập nhật dịch vụ thành công',
          titleClose: 'Danh sách dịch vụ',
          titleConfirm: 'Chi tiết',
          close: () {
            context.router.popUntil(
                  (route) => route.settings.name == 'ServiceListRoute' || route.settings.name == 'HomeRoute',
            );
          },
          accept: () {
            context.router.popUntil(
                  (route) => route.settings.name == 'ServiceListRoute' ||route.settings.name == 'HomeRoute',
            );
            context.router.push(
              ServiceDetailRoute(id: value.data),
            );
          },
        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Cập nhật dịch vụ thất bại \n ${value.message}',
      );
    });
  }
}
