import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/local/index_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_banner_bloc.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class BannerDrugWidget extends StatefulWidget {
  const BannerDrugWidget({super.key, required this.bloc});
  final WholesaleDrugBannerBloc bloc;

  @override
  State<BannerDrugWidget> createState() => _BannerDrugWidgetState();
}

class _BannerDrugWidgetState extends State<BannerDrugWidget> {
  final indexBloc = IndexBloc();
  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => indexBloc,
        ),
        BlocProvider(
          create: (context) => widget.bloc,
        ),
      ],
      child: BlocBuilder<IndexBloc, int>(
        builder: (context, state) {
          return Column(
            children: [
              BlocBuilder<WholesaleDrugBannerBloc, CubitState>(
                builder: (context, state) {
                  return CarouselSlider.builder(
                    itemCount: bloc.list?.length ?? 0,
                    itemBuilder: (context, index, realIndex) {
                      final imgs = bloc.list?.map((e) => e.image).toList();
                      if (imgs?.isEmpty == true) {
                        return Image.asset(
                          Assets.imgsMeme,
                          fit: BoxFit.fill,
                        );
                      }
                      return BaseCacheImage(
                        url: imgs?[index] ?? '',
                        borderRadius: 0.radius,
                        height: 152,
                        width: double.infinity,
                      );
                    },
                    options: CarouselOptions(
                      aspectRatio: 375 / 145,
                      // height: 152,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) => indexBloc.change(index),
                    ),
                  );
                },
              ),
              BlocBuilder<WholesaleDrugBannerBloc, CubitState>(
                builder: (context, bannerState) {
                  return SizedBox(
                    height: 8,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final isSelect = index == state;
                        return Container(
                          width: isSelect ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: isSelect ? 999.radius : null,
                            shape:
                                isSelect ? BoxShape.rectangle : BoxShape.circle,
                            color:
                                isSelect ? AppColors.grey80 : AppColors.white,
                            border: Border.all(color: AppColors.grey80),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => 4.width,
                      itemCount: bloc.list?.length ?? 0,
                    ),
                  );
                },
              ).padding(8.padingTop),
            ],
          );
        },
      ),
    );
  }
}
