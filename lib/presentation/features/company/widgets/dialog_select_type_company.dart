import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/create_company_cubit/create_company_state.dart';

class DialogSelectTypeCompany extends StatelessWidget {
  const DialogSelectTypeCompany({
    super.key,
    required this.onSelect,
  });

  final Function(TypeCompany value) onSelect;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          width: widthDevice(context) - sp48,
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            color: whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bạn muốn tạo',
                style: h5.copyWith(color: blackColor),
              ),
              gapHeight(sp24),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        onSelect(TypeCompany.clinic);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(sp16),
                        decoration: BoxDecoration(
                          color: bg_4,
                          borderRadius: BorderRadius.circular(sp12),
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.2),
                              blurRadius: sp2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            LottieBuilder.asset(
                              '${AssetsPath.lottie}/clinic.json',
                              height: 100,
                            ),
                            gapHeight(sp16),
                            Text(
                              'Phòng khám',
                              style: p5.copyWith(color: blackColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  gapWidth(sp16),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        onSelect(TypeCompany.drugstore);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(sp16),
                        decoration: BoxDecoration(
                          color: bg_4,
                          borderRadius: BorderRadius.circular(sp12),
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.2),
                              blurRadius: sp2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            LottieBuilder.asset(
                              '${AssetsPath.lottie}/drug_store.json',
                              height: 100,
                            ),
                            gapHeight(sp16),
                            Text(
                              'Hiệu thuốc',
                              style: p5.copyWith(color: blackColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
