part of '../../create_workspace_screen.dart';

class BuildAddress extends StatelessWidget {
  final AddressEntity? addressEntity;
  final Function()? onTap;
  const BuildAddress({
    super.key,
    this.addressEntity,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        16.height,
        RichText(
          text: TextSpan(
            text: 'Địa chỉ',
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.input_label,
            ),
            // children: [
            //   TextSpan(
            //     text: ' *',
            //     style: AppStyle.bodyBsRegular.copyWith(
            //       color: AppColors.text_brand_primary_variant2,
            //     ),
            //   ),
            // ],
          ),
        ),
        8.height,
        if (addressEntity == null)
          FormField(
            // validator: (value) {
            //   if (addressEntity == null) {
            //     return 'Vui lòng chọn địa chỉ';
            //   }
            //   return null;
            // },
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabelButton(
                    onPressed: onTap,
                    label: 'Chọn địa chỉ',
                    backgroundColor: AppColors.bg_primary,
                    border: BorderSide(
                      color: field.hasError
                          ? Theme.of(context).colorScheme.error
                          : AppColors.button_neutral_outlined_borderDefault,
                    ),
                    labelStyle: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.button_neutral_outlined_textDefault,
                    ),
                    suffixIcon: const Icon(
                      Icons.add,
                      size: 17,
                      color: AppColors.button_neutral_outlined_textDefault,
                    ),
                  ),
                  if (field.hasError)
                    Text(
                      field.errorText ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ).padding(16.padingLeft),
                ],
              );
            },
          ),
        if (addressEntity != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBtn(
                size: const Size(30, 30),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                ),
              ),
              8.width,
              Text(
                addressEntity?.formatAddress ?? '',
                style: AppStyle.bodyBsSemiBold,
              ).expanded(),
              16.width,
              if (onTap != null) IconBtn(
                onTap: onTap,
                size: const Size(24, 24),
                padding: EdgeInsets.zero,
                backgroundColor:
                    AppColors.button_neutral_solid_backgroundDefault,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.bg_primary,
                  size: 17,
                ),
              ),
            ],
          ).container(
            boxShadow: AppShadows.elevator1,
          ),
      ],
    );
  }
}
