import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class ChartCustomerRevenue extends StatefulWidget {
  const ChartCustomerRevenue({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  State<ChartCustomerRevenue> createState() => _ChartCustomerRevenueState();
}

class _ChartCustomerRevenueState extends State<ChartCustomerRevenue> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: widget.cubit,
      builder: (context, state) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(sp16).copyWith(top: sp0),
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Khách hàng đang có',
                style: p9.copyWith(color: blackColor),
              ),
              gapWidth(sp4),
              Text(
                FormatCurrency(state.customerRevenueReport?.total),
                style: h5.copyWith(color: blackColor),
              ),
              gapWidth(sp4),
              Row(
                children: [
                  Text(
                    'Đơn trung bình (',
                    style: p9.copyWith(color: greyTextColor),
                  ),
                  Text(
                    '${state.customerRevenueReport?.average} đơn',
                    style: p8.copyWith(color: green_1),
                  ),
                  Text(
                    '/khách hàng)',
                    style: p9.copyWith(color: greyTextColor),
                  ),
                ],
              ),
              gapHeight(sp16),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.cubit.filterOrderByChange(
                        FilterCustomerRevenueReport.byQuantity,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: sp4,
                        horizontal: sp8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp24),
                        color: state.orderBy ==
                                FilterCustomerRevenueReport.byQuantity
                            ? mainColor
                            : bg_4,
                      ),
                      child: Text(
                        'Theo số lượng đơn',
                        style: p7.copyWith(
                          color: state.orderBy ==
                                  FilterCustomerRevenueReport.byQuantity
                              ? whiteColor
                              : blackColor,
                        ),
                      ),
                    ),
                  ),
                  gapWidth(sp8),
                  GestureDetector(
                    onTap: () {
                      widget.cubit.filterOrderByChange(
                        FilterCustomerRevenueReport.byRevenue,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: sp4,
                        horizontal: sp8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp24),
                        color: state.orderBy ==
                                FilterCustomerRevenueReport.byRevenue
                            ? mainColor
                            : bg_4,
                      ),
                      child: Text(
                        'Theo doanh số',
                        style: p7.copyWith(
                          color: state.orderBy ==
                                  FilterCustomerRevenueReport.byRevenue
                              ? whiteColor
                              : blackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              state.isLoadingReportCustomerRevenue
                  ? const SizedBox(height: sp124 * 2, child: BaseLoading())
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final customer =
                            state.customerRevenueReport?.details?[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.all(sp0),
                          leading: SizedBox(
                            width: 92,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: index == 0
                                      ? yellow_1
                                      : index == 1
                                          ? greyColor.withOpacity(0.4)
                                          : index == 2
                                              ? yellow_1.withOpacity(0.4)
                                              : whiteColor,
                                  child: Text(
                                    '${index + 1}',
                                    style: h6.copyWith(color: blackColor),
                                  ),
                                ),
                                gapWidth(sp8),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(sp12),
                                    child: BaseCacheImage(
                                      url: (customer?.image?.isEmpty ?? true)
                                          ? PrefKeys.avatarDefault
                                          : customer!.image!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Container(
                            margin: const EdgeInsets.only(bottom: sp8),
                            child: Text(
                              customer?.fullName ?? '',
                              style: h6.copyWith(color: greyTextColor),
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                '${FormatCurrency(customer?.revenue)}đ',
                                style: h6.copyWith(color: mainColor),
                              ),
                              Text(
                                ' - ',
                                style: p5.copyWith(color: blackColor),
                              ),
                              Text(
                                '${FormatCurrency(customer?.quantity)} đơn hàng',
                                style: p5.copyWith(color: greyTextColor),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => gapHeight(sp0),
                      itemCount:
                          state.customerRevenueReport?.details?.length ?? 0,
                    ),
              gapWidth(sp4),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Xem thêm',
                    style: p5.copyWith(color: blue_1),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
