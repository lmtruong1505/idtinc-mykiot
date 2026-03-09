part of '../../create_workspace_screen.dart';

class _buildTime extends StatelessWidget {
  final CreateCompanyCubit bloc;
  final Function()? onTap;
  const _buildTime({super.key, required this.bloc, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        16.height,
        RichText(
          text: TextSpan(
            text: 'Giờ mở cửa',
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.input_label,
            ),
          ),
        ),
        8.height,
        RangeInput(
          value1: bloc.getTimeStr(bloc.state.timeOpen),
          value2: bloc.getTimeStr(bloc.state.timeClose),
          onChanged: (start, end) {
            onTap?.call();
            final startTime = start.length == 5
                ? TimeOfDay(
                    hour: int.parse(start.split(':')[0]),
                    minute: int.parse(start.split(':')[1]),
                  )
                : null;
            final endTime = end.length == 5
                ? TimeOfDay(
                    hour: int.parse(end.split(':')[0]),
                    minute: int.parse(end.split(':')[1]),
                  )
                : null;
            bloc.changeTime(
              open: startTime,
              close: endTime,
            );
          },
          inputFormatters: [
            HourMinsFormatter(),
            LengthLimitingTextInputFormatter(5),
          ],
          validator: (value1, value2) {
            if (value1.isEmptyOrNull && value2.isEmptyOrNull) {
              return null;
            }
            if (!value1.isTimeOfDay) {
              return 'Thời gian mở cửa không đúng định đạng';
            }
            if (!value2.isTimeOfDay) {
              return 'Thời gian đóng cửa không đúng định đạng';
            }
            return null;
          },
          prefixIcon: const Icon(
            Icons.access_time_rounded,
            color: AppColors.input_iconDefault,
            size: 17,
          ),
          hintStart: '00:00',
          hintEnd: '00:00',
        ),
      ],
    );
  }
}
