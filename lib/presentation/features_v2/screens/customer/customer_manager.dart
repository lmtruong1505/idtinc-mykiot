import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/chat/chat_socket_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';
import '../../../../shared/components/button/custom_btn.dart';
import '../../../../shared/components/input/app_input.dart';
import '../../../../shared/style_app/init_style.dart';
import '../../../base/app_bar.dart';
import '../../../base/v2/date_time_widget.dart';
import '../../../base/v2/expanded_section.dart';
import '../../blocs/customer/customer_manager_bloc.dart';
import '../../blocs/date_time/param_date.dart';
import '../../../router/router.gr.dart';
import '../../models/customer/socket_oa_model.dart';
import 'components/item_customer.dart';

@RoutePage()
class CustomerManagerV2Page extends StatefulWidget {
  const CustomerManagerV2Page({super.key});

  @override
  State<CustomerManagerV2Page> createState() => _CustomerManagerV2PageState();
}

class _CustomerManagerV2PageState extends State<CustomerManagerV2Page>
    with SingleTickerProviderStateMixin {
  late CustomerManagerCubit bloc;
  final scroll = ScrollController();
  final delay = DelayCallBack(delay: 500.milliseconds);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read<CustomerManagerCubit>();
    bloc.getList();
    scroll.addListener(
      () {
        if (scroll.position.pixels == scroll.position.maxScrollExtent) {
          bloc.getList(isMore: true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatSocketBloc, CubitState>(
      bloc: getIt<ChatSocketBloc>(),
      listener: (context, state) {
        print(state.data);
        if(state.status == BlocStatus.success){
          bloc.updateZaloCustomer(SocketOAModel.fromJson(state.data));
        }
      },
      child: Scaffold(
        backgroundColor: ColorApp.greyF5,
        appBar: const BaseAppBar(
          title: 'Quản lý khách hàng',
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            bloc.getList();
          },
          child: SingleChildScrollView(
            controller: scroll,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: Dimensions.sp16.pading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainButton(
                  title: 'Thêm mới',
                  radius: Dimensions.sp8,
                  event: () {
                    context.router.push(CustomerActionRoute()).then(
                      (value) {
                        if (value == true) {
                          bloc.getList();
                        }
                      },
                    );
                  },
                ),
                Dimensions.sp16.height,
                _buildSearchFilter(),
                Dimensions.sp16.height,
                BlocBuilder<CustomerManagerCubit, CubitState>(
                  bloc: bloc,
                  builder: (context, state) {
                    return LoadListPage(
                      state: state,
                      height: 200,
                      listEmpty: bloc.list.isEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          bloc.list.length,
                          (index) => ItemCustomer(
                            customer: bloc.list[index],
                          ).padding(
                            Dimensions.sp16.padingBottom,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                context.padding.bottom.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFilter() {
    return BlocBuilder<CustomerManagerCubit, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppInputV2(
                    hintText: 'Tìm kiếm theo tên, sđt khách hàng',
                    borderColor: ColorApp.greyE2,
                    backgroundColor: ColorApp.white,
                    radius: Dimensions.sp8,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: ColorApp.black,
                    ),
                    onChanged: (p0) {
                      delay.debounce(
                        () {
                          bloc.search = p0;
                        },
                      );
                    },
                    onConfirm: (p0) {
                      bloc.search = p0;
                    },
                  ),
                ),
                // Dimensions.sp16.width,
                // GestureDetector(
                //   onTap: () {
                //     //bloc.isFilter = !bloc.isFilter;
                //     DialogUtils.showBottomDialogText(
                //       context,
                //       SearchPopup(),
                //     );
                //   },
                //   child: Container(
                //     width: 45,
                //     height: 45,
                //     clipBehavior: Clip.antiAlias,
                //     decoration: ShapeDecoration(
                //       color: Colors.white,
                //       shape: RoundedRectangleBorder(
                //         side: BorderSide(
                //           width: 1,
                //           color:
                //               bloc.isFilter ? ColorApp.main : ColorApp.greyE2,
                //         ),
                //         borderRadius: Dimensions.sp8.radius,
                //       ),
                //     ),
                //     child: Center(
                //       child: Image.asset(
                //         Assets.iconsIcSort,
                //         width: 20,
                //         color: bloc.isFilter ? ColorApp.main : ColorApp.greyAA,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            _inputFilter(),
          ],
        );
      },
    );
  }

  Widget _inputFilter() {
    return ExpandedSection(
      isSelected: bloc.isFilter,
      child: Container(
        margin: Dimensions.sp16.padingTop,
        padding: Dimensions.sp12.pading,
        decoration: BoxDecoration(
          borderRadius: Dimensions.sp8.radius,
          border: Border.all(color: ColorApp.main),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BtnFilter(
              icon: Icons.calendar_month_outlined,
              title: bloc.titleDate,
              onClosed: () {
                bloc.date = null;
              },
              onPressed: () {
                context.dialog(DateTimeWidget()).then((value) {
                  if (value is ParamDate) {
                    bloc.date = value;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
