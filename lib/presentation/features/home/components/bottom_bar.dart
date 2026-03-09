part of '../home_page.dart';

class BottomBarHome extends StatelessWidget {
  const BottomBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavHomeBloc, CubitState<TabCodeNav>>(
      builder: (context, state) {
        print('=======NavHomeBloc');
        return _bgNav(
          child: Row(
            children: List.generate(
              TabCodeNav.values.length,
              (index) {
                final tab = TabCodeNav.values[index];
                if (!showAppointment && TabCodeNav.appointment == tab) {
                  return const SizedBox.shrink();
                }
                if (showAppointment && TabCodeNav.warehouse == tab) {
                  return const SizedBox.shrink();
                }

                return GestureDetector(
                  onTap: () {
                    if (TabCodeNav.createOrder.index == index) {
                      handleCreateOrder(context);
                    } else {
                      context.read<NavHomeBloc>().onChanged(tab);
                    }
                  },
                  // onLongPress: () {
                  //   if (TabCodeNav.order.index == index) {
                  //     final cubit = getIt.get<AuthWsManagerCubit>();
                  //     final isAuth = cubit.state.isAuthen;
                  //     if (isAuth) {
                  //       cubit.stateChange(isAuth: !isAuth);
                  //       return;
                  //     }
                  //     AuthWsInputDialog.show(
                  //       context,
                  //       callBack: (value) {
                  //         cubit
                  //             .verifyCode(getCompany!, value)
                  //             .then((bool isSuccess) {
                  //           if (isSuccess) {
                  //             Navigator.of(context).pop();
                  //           } else {
                  //             toastification.show(
                  //               title: const Text('Xác thực thất bại'),
                  //               type: ToastificationType.error,
                  //               autoCloseDuration: const Duration(seconds: 3),
                  //             );
                  //           }
                  //         });
                  //       },
                  //     );
                  //   }
                  // },
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: index != state.data?.index
                              ? Colors.transparent
                              : AppColors.border_brandSolid,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        7.height,
                        _buildIcon(index, state.data!),
                        2.height,
                        Text(
                          tab.title,
                          textAlign: TextAlign.center,
                          style: index == state.data?.index
                              ? AppStyle.bodyXsMedium
                              : AppStyle.bodyXsRegular.copyWith(
                                  color: AppColors.text_quaternary,
                                ),
                        ),
                      ],
                    ),
                  ),
                ).expanded();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _bgNav({required Widget child}) {
    return Container(
      padding: 16.padingBottom,
      decoration: const BoxDecoration(
        color: AppColors.bg_primary,
        border: Border(
          top: BorderSide(
            color: AppColors.border_tertiary,
          ),
        ),
      ),
      child: child,
    );
  }

  Widget _buildIcon(int index, TabCodeNav state) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: TabCodeNav.values[index] == TabCodeNav.createOrder
            ? AppColors.bg_brandPrimary_variant1
            : null,
      ),
      child: Center(
        child: FaIcon(
          iconCode: TabCodeNav.values[index].iconCode,
          type: state.index == index ? FaIconType.solid : FaIconType.regular,
          color: TabCodeNav.values[index] == TabCodeNav.createOrder
              ? AppColors.fg_brand_primary_variant1
              : state.index == index
                  ? AppColors.fg_primary
                  : null,
        ),
      ),
    );
  }

  static Future<void> handleCreateOrder(BuildContext context) async {
    if (isDrugStore ?? false) {
      context.router.push(CreateOrderRoute(type: 'product'));
    } else {
      return await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoTheme(
            data: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                primaryColor: AppColors.bg_primary,
              ),
              barBackgroundColor: AppColors.bg_primary,
            ),
            child: CupertinoActionSheet(
              cancelButton: ActionBtn(
                color: null,
                onTap: () => context.pop(),
                title: 'Huỷ bỏ',
              ),
              actions: [
                ActionBtn(
                  title: 'Tạo mới đơn hàng',
                  onTap: () {},
                  style: AppStyle.bodyBsSemiBold.copyWith(
                    color: AppColors.text_quaternary,
                  ),
                ),
                ActionBtn(
                  title: 'Tạo đơn hàng sản phẩm',
                  onTap: () async {
                    context.router.push(CreateOrderRoute(type: 'product'));
                  },
                ),
                ActionBtn(
                  title: 'Tạo đơn hàng dịch vụ',
                  onTap: () async {
                    context.router.push(CreateOrderRoute(type: 'service'));
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
