import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/screens/select_address.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_cubit.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

@RoutePage()
class CustomerDetailPage extends StatefulWidget {
  final int id;
  const CustomerDetailPage({super.key, required this.id});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabBarCtl;

  final myBloc = getIt.get<CustomerCubit>();

  @override
  void initState() {
    super.initState();

    _tabBarCtl = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();

    _tabBarCtl.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: bg_5,
        appBar: AppBar(
          title: const Text('Chi tiết khách hàng'),
          actions: [
            InkWell(
              onTap: () async {
                // await context.router.push(CustomerUpdateRoute(id: widget.id));
                // // ignore: use_build_context_synchronously
                // await myBloc.getDetail(context, widget.id);
                // myBloc.entityILC.onRefresh();
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: const Icon(
                  Icons.delete_outline_outlined,
                  size: 25,
                  color: red_1,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await context.router.push(CustomerUpdateRoute(id: widget.id));
                // ignore: use_build_context_synchronously
                await myBloc.getDetail(context, widget.id);
                myBloc.entityILC.onRefresh();
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: const Icon(Icons.edit_outlined, size: 25, color: bg_1),
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            controller: _tabBarCtl,
            tabs: const [
              Tab(
                text: 'Thông tin cơ bản',
              ),
              Tab(
                text: 'Bệnh án',
              ),
              Tab(
                text: 'Kết quả xét nghiệm',
              ),
              Tab(
                text: 'Lịch hẹn',
              ),
              Tab(
                text: 'Dịch vụ đã dùng',
              ),
              Tab(
                text: 'Đơn hàng',
              ),
              Tab(
                text: 'Sản phẩm đã mua',
              ),
              Tab(
                text: 'Thông tin bổ sung',
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => myBloc..getDetail(context, widget.id),
          child: BlocBuilder<CustomerCubit, CustomerState>(
            builder: (context, state) {
              return TabBarView(
                controller: _tabBarCtl,
                children: [
                  _infoBasic(state),
                  Text('Bệnh án'),
                  Text('Kết quả xét nghiệm'),
                  Text('Lịch hẹn'),
                  Text('Dịch vụ đã dùng'),
                  Text('Đơn hàng'),
                  Text('Sản phẩm đã mua'),
                  _infoSupport(state),
                ],
              );
            },
          ),
        ),
      );

  Widget _infoBasic(CustomerState state) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(sp16),
          padding: const EdgeInsets.all(sp16),
          width: widthDevice(context),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${state.customer.name}',
                    style: p3.copyWith(color: blackColor),
                  ),
                  const CircleAvatar(
                    radius: sp24,
                    backgroundColor: green_2,
                    child: Icon(
                      Icons.phone,
                      color: green_1,
                    ),
                  ),
                ],
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Mã khách hàng',
                content: state.customer.code ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Số điện thoại',
                content: state.customer.phone ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Email',
                content: state.customer.email ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Ngày sinh',
                content: Date.formatDateDay(
                  state.customer.birthday,
                ),
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Giới tính',
                content: state.customer.gender == 1 ? 'Name' : 'Nữ',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Địa chỉ',
                content: SelectAddressView.formatAddress(
                  state.customer.address,
                ),
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(sp16).copyWith(top: sp0),
          padding: const EdgeInsets.all(sp16),
          width: widthDevice(context),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowItem(
                title: 'Người tạo:',
                content: state.customer.code ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Thời gian tạo:',
                content: state.customer.phone ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Người cập nhật:',
                content: state.customer.email ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Thời gian cập nhật:',
                content: Date.formatDateDay(
                  state.customer.birthday,
                ),
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoSupport(CustomerState state) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(sp16),
          padding: const EdgeInsets.all(sp16),
          width: widthDevice(context),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowItem(
                title: 'Số CMND/CCCD',
                content: state.customer.license ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Ngày cấp',
                content: state.customer.licenseDate != null
                    ? DateFormat('dd/M/y').format(state.customer.licenseDate!)
                    : 'Chưa có thông tin',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Xưng hô',
                content: state.customer.title ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(sp16).copyWith(top: sp0),
          padding: const EdgeInsets.all(sp16),
          width: widthDevice(context),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowItem(
                title: 'Họ và tên',
                content: state.customer.contactName ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Chức danh',
                content: state.customer.contactTitle ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Số điện thoại',
                content: state.customer.contactPhone ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Email',
                content: state.customer.contactEmail ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(sp16).copyWith(top: sp0),
          padding: const EdgeInsets.all(sp16),
          width: widthDevice(context),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowItem(
                title: 'Số tài khoản',
                content: state.customer.accountNumber ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Tên ngân hàng',
                content: state.customer.bankName ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
              gapHeight(sp12),
              RowItem(
                title: 'Cơ sở',
                content: state.customer.bankBranch ?? '',
                titleStyle: p6.copyWith(color: greyTextColor),
                contetnStyle: p5.copyWith(color: blackColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
