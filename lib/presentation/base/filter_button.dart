
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/size_device.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';

class FilterButtonItem {
  final String label;
  final dynamic value;

  const FilterButtonItem(this.label, this.value);
}

class FilterButton extends StatelessWidget {
  final List<FilterButtonItem> listFilter;
  final FilterButtonItem selectFilter;
  final Function(FilterButtonItem value) handleSelectFilter;
  final int? value;

  const FilterButton(
      this.listFilter, this.selectFilter, this.handleSelectFilter,
      {super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 36,
        maxHeight: 36,
        maxWidth: widthDevice(context),
        minWidth: widthDevice(context),
      ),
      // width: widthDevice(context),
      // height: 40,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: sp16),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        // physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => handleSelectFilter(listFilter[index]),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: sp8, horizontal: sp12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp8),
                  color: listFilter[index] == selectFilter
                      ? accentColor_1
                      : whiteColor,
                  boxShadow: []),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      listFilter[index].label,
                      style: p5.copyWith(
                        color: listFilter[index] == selectFilter
                            ? whiteColor
                            : greyColor,
                      ),
                    ),
                    Visibility(
                      visible: value != null,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: sp8,
                          ),
                          CircleAvatar(
                            radius: sp12,
                            backgroundColor: listFilter[index] == selectFilter
                                ? whiteColor
                                : accentColor_4,
                            child: Text(
                              value?.toString() ?? '',
                              style: p8.copyWith(
                                color: mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: listFilter.length,
      ),
    );
  }
}
