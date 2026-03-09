import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/typography.dart';

import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'indicator.dart';

class ChartCustomer extends StatefulWidget {
  const ChartCustomer({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  State<ChartCustomer> createState() => _ChartCustomerState();
}

class _ChartCustomerState extends State<ChartCustomer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: widget.cubit..getReportCustomer(),
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
                'Nguồn khách hàng',
                style: h5.copyWith(color: blackColor),
              ),
              Row(
                children: [
                  Text(
                    '${widget.cubit.percentDifferent(state.currentCustomer.toDouble(), state.lastCustomer.toDouble())}%',
                    style: h6.copyWith(color: state.currentCustomer > state.lastCustomer ? green_1 : red_1),
                  ),
                  gapWidth(sp4),
                  Text(
                    'tháng này',
                    style: p6.copyWith(color: greyTextColor),
                  ),
                ],
              ),
              gapHeight(sp12),
              _chart(state),
            ],
          ),
        );
      },
    );
  }

  int touchedIndex = -1;

  Widget  _chart(HomeState state) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: sp64,
                    sections: _showingSections(),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        state.currentCustomer.toString(),
                        style: h5.copyWith(color: blackColor),
                      ),
                      Text(
                        'Khách hàng',
                        style: p9.copyWith(color: greyTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          gapHeight(sp16),
          Expanded(
            flex: 1,
            child: GridView(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 10,
                crossAxisCount: 2,
                crossAxisSpacing: sp8,
                mainAxisSpacing: sp8,
              ),
              children: [
                const Indicator(
                  color: blue_1,
                  text: 'Facebook',
                  value: '0',
                  isSquare: false,
                  size: sp16,
                ),
                const Indicator(
                  color: yellow_1,
                  text: 'Zalo OA',
                  value: '0',
                  isSquare: false,
                  size: sp16,
                ),
                const Indicator(
                  color: purple_1,
                  text: 'Google',
                  value: '0',
                  isSquare: false,
                  size: sp16,
                ),
                Indicator(
                  color: green_1,
                  text: 'Khác',
                  value: state.currentCustomer.toString(),
                  isSquare: false,
                  size: sp16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      // final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 10.0 : 5.0;
      // const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: blue_1,
            value: 40,
            title: isTouched ? '40%' : '',
            radius: radius,
            titleStyle: p8.copyWith(color: blackColor),
          );
        case 1:
          return PieChartSectionData(
            color: yellow_1,
            value: 30,
            title: isTouched ? '30%' : '',
            radius: radius,
            titleStyle: p8.copyWith(color: blackColor),
          );
        case 2:
          return PieChartSectionData(
            color: purple_1,
            value: 15,
            title: isTouched ? '15%' : '',
            radius: radius,
            titleStyle: p8.copyWith(color: blackColor),
          );
        case 3:
          return PieChartSectionData(
            color: green_1,
            value: 15,
            title: isTouched ? '15%' : '',
            radius: radius,
            titleStyle: p8.copyWith(color: blackColor),
          );
        default:
          throw Error();
      }
    });
  }

}
