import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../base/button.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';

class InvoiceAiInstructPopup extends StatefulWidget {
  const InvoiceAiInstructPopup({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const InvoiceAiInstructPopup();
      },
    );
  }

  @override
  State<InvoiceAiInstructPopup> createState() => _InvoiceAiInstructPopupState();
}

class _InvoiceAiInstructPopupState extends State<InvoiceAiInstructPopup> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(sp16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sp16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(sp16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Hướng dẫn chụp ảnh ',
                    style: s18w700.copyWith(
                      color: AppColors.text_primary,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      radius: sp16,
                      backgroundColor: black5o,
                      child: FaIcon(iconCode: 'f00d'),
                    ),
                  ),
                ],
              ),
              Text(
                'Hệ thống sẽ tự động nhận diện sản phẩm, số lượng, đơn vị, đơn giá từ hóa đơn bạn chụp',
                style: s14w400.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              CarouselSlider(
                items: [
                  Image.asset(
                      '${AssetsPath.image}/invoice_ai_instruct_right.png'),
                  Image.asset(
                      '${AssetsPath.image}/invoice_ai_instruct_wrong.png'),
                ],
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _index = index;
                    });
                  },
                  height: 350,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1].map((e) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(left: e == 1 ? sp4 : sp0),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp8),
                      border: Border.all(color: AppColors.border_tertiary),
                      color:  _index == e ? AppColors.border_tertiary : AppColors.bg_primary,
                    ),
                    width: _index == e ? sp24 : sp8,
                    height: sp8,
                  );
                }).toList(),
              ),
              Text(
                'Lưu ý: Ảnh mờ, mất góc, bóng đổ hoặc gập hóa đơn có thể khiến AI nhận sai thông tin! Hãy chụp lại nếu ảnh không rõ ràng để đảm bảo độ chính xác cao nhất.',
                style: s12w400.copyWith(color: AppColors.text_secondary),
              ),
              sp24.height,
              Align(
                alignment: Alignment.center,
                child: ExtraButton(
                  title: 'Xác nhận',
                  event: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor:
                      AppColors.button_neutral_solid_backgroundDefault,
                  borderRadius: sp48,
                  titleColor: AppColors.button_neutral_solid_textDefault,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
