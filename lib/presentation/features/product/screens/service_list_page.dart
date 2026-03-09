import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/custom_btn.dart';
import '../../../../shared/components/input/app_input.dart';
import '../../../../shared/constants/pref_key.dart';
import '../../../../shared/style_app/color_app.dart';
import '../../../../shared/style_app/dimensions.dart';
import '../../../../shared/style_app/style_text.dart';
import '../../../base/cache_image.dart';
import '../../../base/loading.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../cubit/service_manager_cubit/service_manager_cubit.dart';
import '../cubit/service_manager_cubit/service_manager_state.dart';
import '../domain/entities/service_entity.dart';

@RoutePage()
class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  final myBloc = getIt.get<ServiceManagerCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc,
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: const BaseAppBar(
          title: 'Quản lý dịch vụ',
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.search),
            // ),
            // IconButton(
            //   onPressed: () async {
            //     await context.router
            //         .push(ServiceCreateV2Route());
            //     myBloc.servicesILC.onRefresh();
            //
            //   },
            //   icon: const Icon(Icons.add),
            // ),
          ],
        ),
        body: Container(
          height: heightDevice(context),
          width: heightDevice(context),
          padding: const EdgeInsets.symmetric(
            vertical: sp24,
            horizontal: sp24,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              myBloc.servicesILC.onRefresh();
            },
            child: SingleChildScrollView(
              controller: myBloc.scrollController,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: MainButton(
                      title: 'Tạo mới dịch vụ',
                      event: () async {
                        await context.router.push(ServiceCreateV2Route());
                        myBloc.servicesILC.onRefresh();
                      } ,
                    ),
                  ),
                  16.height,
                  BlocBuilder<ServiceManagerCubit, ServiceManagerState>(
                    builder: (context, state) {
                      return _buildStatus();
                    },
                  ).size(height: sp40),
                  sp16.height,
                  BlocBuilder<ServiceManagerCubit, ServiceManagerState>(
                    builder: (context, state) {
                      return _buildFilter(state);
                    },
                  ),
                  16.height,
                  InfiniteList(
                    shrinkWrap: true,
                    getData: (page) async {
                      return myBloc.getServices(page);
                    },
                    itemBuilder: (context, item, index) {
                      return _buildItem(item);
                    },
                    scrollController: myBloc.scrollController,
                    infiniteListController: myBloc.servicesILC,
                    circularProgressIndicator: const BaseLoading(),
                    noItemFoundWidget: const EmptyContainer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(ServiceEntity item) {
    return InkWell(
      onTap: () async {
        await context.router.push(
          ServiceDetailRoute(id: item.id!),
        );
        myBloc.servicesILC.onRefresh();
      },
      child: Container(
        padding: const EdgeInsets.all(sp16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(sp12),
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(sp0),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
              leading: SizedBox(
                height: sp48,
                width: sp48,
                child: BaseCacheImage(
                  url: (item.images?.isNotEmpty ?? false)
                      ? (item.images?[0] ?? PrefKeys.imgProductDefault)
                      : PrefKeys.imgProductDefault,
                ),
              ),
              title: Text(
                item.title ?? '',
                style: p5.copyWith(
                  color: blackColor,
                ),
              ),
              subtitle: Text(
                '${FormatCurrency(item.price)}/${item.unit}',
                style: StyleApp.normal(color: green_3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) =>
          BtnStatusCount(
            onPressed: () {
              myBloc.selectFilterButton(myBloc.state.listFilter[index]);
            },
            title: myBloc.state.listFilter[index].title,
            isActive: myBloc.state.listFilter[index] ==
                myBloc.state.selectFilter,
            count: _getCount(myBloc.state.listFilter[index].code),
          ),
      separatorBuilder: (context, index) => sp16.width,
      itemCount: myBloc.state.listFilter.length,
    );
  }

  Row _buildFilter(ServiceManagerState state) {
    return Row(
      children: [
        Expanded(
          child: AppInputV2(
            hintText: 'Tìm tên dịch vụ',
            borderColor: ColorApp.greyE2,
            backgroundColor: ColorApp.white,
            radius: Dimensions.sp8,
            prefixIcon: const Icon(
              Icons.search,
              color: ColorApp.black,
            ),
            onChanged: (p0) {
              myBloc.searchChange(p0);
            },
            onConfirm: (p0) {},
          ),
        ),
        // Dimensions.sp16.width,
        // GestureDetector(
        //   onTap: () {},
        //   child: Container(
        //     width: 45,
        //     height: 45,
        //     clipBehavior: Clip.antiAlias,
        //     decoration: ShapeDecoration(
        //       color: Colors.white,
        //       shape: RoundedRectangleBorder(
        //         side: const BorderSide(
        //           width: 1,
        //           color: ColorApp.greyE2,
        //         ),
        //         borderRadius: Dimensions.sp8.radius,
        //       ),
        //     ),
        //     child: Center(
        //       child: Image.asset(
        //         Assets.iconsIcSort,
        //         width: 20,
        //         color: ColorApp.greyAA,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }


  int _getCount(String code) {
    return myBloc.state.serviceCount.fold(0, (total, e) {
      if (e.code == code) {
        return e.value;
      }
      return total;
    });
  }


}
