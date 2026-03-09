import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_state.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';

class ServicePictureView extends StatelessWidget {
  const ServicePictureView({
    super.key,
    required this.myBloc,
  });

  final ServiceCreateCubit myBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCreateCubit, ServiceCreateState>(
      bloc: myBloc,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: 12.pading,
                margin: 12.pading,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      offset: const Offset(1, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ảnh sản phẩm',
                      style: h5,
                    ),
                    12.height,
                    InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final images = await picker.pickMultiImage(limit: 4 - state.imageService.length);
                        myBloc.imageServiceChange(images);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(sp8),
                              padding: const EdgeInsets.all(sp12),
                              color: green_3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Tải ảnh lên ${state.imageService.length}/4',
                                    style: p5.copyWith(color: green_3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: green_3),
                            ),
                            padding: const EdgeInsets.all(sp12),
                            margin: const EdgeInsets.only(left: sp12),
                            child: const Icon(
                              size: 16,
                              Icons.camera_alt_outlined,
                              color: green_3,
                            ),
                          )

                        ],
                      ),
                    ),
                    12.height,
                    _buildListPic(state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListPic(ServiceCreateState state){
    return Visibility(
      visible: state.imageService.isNotEmpty,
      child: Container(
        width: double.infinity,
        height: sp56,
        margin: const EdgeInsets.only(top: sp12),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final image = state.imageService[index];
            return Stack(
              children: [
                Container(
                  width: sp56,
                  height: sp56,
                  margin: const EdgeInsets.all(sp4),
                  padding: const EdgeInsets.all(sp4),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor_2),
                    borderRadius: BorderRadius.circular(sp8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sp8),
                    child: Image.file(image),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: (){
                      myBloc.removeImageProduct(index);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/ic_delete.svg',
                      width: sp16,
                      height: sp16,
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => gapWidth(sp12),
          itemCount: state.imageService.length,
        ),
      ),
    );
  }
}
