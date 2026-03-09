part of '../../create_workspace_screen.dart';

class _buildStaffManager extends StatelessWidget {
  final CreateCompanyState state;
  final Function()? onTap;
  const _buildStaffManager({
    super.key,
    required this.state,
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
            text: 'Quản lý',
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
        if (state.manager?.id == null)
          FormField(
            validator: (value) {
              // if (state.manager?.id == null) {
              //   return 'Vui lòng chon quản lý chi nhánh';
              // }
              return null;
            },
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabelButton(
                    onPressed: onTap,
                    label: 'Chọn quản lý',
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
        if (state.manager?.id != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // IconBtn(
              //   size: const Size(30, 30),
              //   padding: EdgeInsets.zero,
              //   icon: const Icon(
              //     Icons.manage_accounts_outlined,
              //     size: 20,
              //   ),
              // ),
              AvatarCustom(
                url: state.manager?.avatar ?? '',
              ),
              8.width,
              Text(
                state.manager?.fullName ?? '',
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodyBsSemiBold,
              ).expanded(),
              16.width,
              IconBtn(
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
