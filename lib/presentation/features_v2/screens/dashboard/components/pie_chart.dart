import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/home/widgets/indicator.dart';
import 'package:pharmago/presentation/features_v2/models/local_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../constants/spacing.dart';

class PieChartDashboard extends StatefulWidget {
  final String centerText;
  final String? subText;
  final List<LocalModel> dataChart;
  final double size;
  final double radius;
  final double fontSize;
  final bool showLabel;
  const PieChartDashboard({
    required this.centerText,
    required this.dataChart,
    required this.size,
    this.subText,
    this.radius = 5,
    this.fontSize = 16,
    this.showLabel = false,
  });

  @override
  State<PieChartDashboard> createState() => _PieChartDashboardState();
}

class _PieChartDashboardState extends State<PieChartDashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: widget.size,
          width: widget.size,
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
                  startDegreeOffset: -90,
                  sectionsSpace: 0,
                  sections: _showingSections(),
                ),
              ).size(height: widget.size),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.centerText,
                      style: StyleApp.semibold(fontSize: widget.fontSize),
                    ),
                    if (widget.subText != null)
                      Text(
                        widget.subText!,
                        style: StyleApp.normal(
                          color: ColorApp.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.showLabel) sp16.height,
        if (widget.showLabel)
          GridView(
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: sp8,
              mainAxisSpacing: sp8,
              mainAxisExtent: 20,
            ),
            shrinkWrap: true,
            children: List.generate(
              widget.dataChart.length,
              (index) => Indicator(
                color: widget.dataChart[index].color ?? ColorApp.greyEA,
                text: widget.dataChart[index].title ?? '',
                value: '${widget.dataChart[index].value}',
                isSquare: false,
                size: sp16,
                mainAxisAlignment: index % 2 != 0
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
              ),
            ),
          ),
      ],
    );
  }

  int touchedIndex = -1;

  List<PieChartSectionData> _showingSections() {
    widget.dataChart.removeWhere(
      (element) => element.value.validator <= 0,
    );
    final list = List.generate(
      widget.dataChart.length,
      (i) {
        final isTouched = i == touchedIndex;
        final radius = isTouched ? widget.radius + 5 : widget.radius;

        return PieChartSectionData(
          color: widget.dataChart[i].color,
          value: widget.dataChart[i].value ?? 0,
          title:
              isTouched ? '${widget.dataChart[i].value.formatPercent()}%' : '',
          radius: radius,
          titleStyle: StyleApp.normal(fontSize: 12),
        );
      },
    );
    final totalValue =
        widget.dataChart.fold(0.0, (acc, curr) => acc + (curr.value ?? 0));
    if ((100 - totalValue) > 0) {
      list.add(
        PieChartSectionData(
          color: ColorApp.greyEA,
          value: 100 - totalValue,
          title: '',
          radius: widget.radius,
          titleStyle: StyleApp.normal(fontSize: 12),
        ),
      );
    }

    return list;
  }
}
