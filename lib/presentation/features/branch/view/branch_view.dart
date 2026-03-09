import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../router/router.gr.dart';

class BranchView extends StatelessWidget {
  const BranchView({
    super.key,
    required this.company, this.onReload,
  });

  final CompanyEntity company;
  final Function? onReload;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await context.router.push(BranchDetailRoute(id: company.id ?? -1));
        onReload?.call();
      },
      child: Container(
        padding: 16.padingHor + 12.padingVer,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: 8.radius,
          border: Border.all(
            color: borderColor_2,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name ?? '',
                      style: StyleApp.semibold(
                        fontSize: 16,
                        color: blackColor,
                      ),
                    ),
                    8.height,
                    Text(
                      'Quản lý',
                      style: StyleApp.normal(
                        fontSize: 14,
                        color: blackColor,
                      ),
                    ),
                  ],
                ).expanded(),
                Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                )
              ],
            ),
            8.height,
            Row(
              children: [
                IcSvg.asset('/people.svg'),
                12.width,
                Text('${company.totalStaff ?? 0} nhân viên')
              ],
            )
          ],
        ),
      ),
    );
  }
}
