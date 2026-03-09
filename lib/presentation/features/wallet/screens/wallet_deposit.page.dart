import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/wallet/bloc/bloc/wallet_event.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../gen/assets.dart';
import '../../../base/app_bar.dart';
import '../../../base/dialog.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../di/di.dart';
import '../bloc/bloc/wallet_bloc.dart';
import '../bloc/bloc/wallet_state.dart';
import '../data/models/deep_link_bank_model.dart';

@RoutePage()
class WalletDepositPage extends StatefulWidget {
  const WalletDepositPage({super.key});

  @override
  State<WalletDepositPage> createState() => _WalletDepositPageState();
}

class _WalletDepositPageState extends State<WalletDepositPage> {
  final walletBloc = getIt<WalletBloc>();
  final _amountCtl = TextEditingController(text: '500.000');
  final GlobalKey _qrKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    walletBloc.add(WalletDetailEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      bloc: walletBloc,
      listener: (context, state) {
        if (state is WalletDepositSuccessState) {
          DialogUtils.showSuccessDialog(
            context,
            content: 'Đã nạp tiền thành công vào ví PMG',
            barrierDismissible: true,
          ).then((_) {
            context.router.removeUntil(
              (route) {
                return route.name == WalletRoute.name;
              },
            );
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: const BaseAppBar(title: 'Nạp tiền vào ví'),
          body: Stack(
            children: [
              Image.asset(Assets.imgsBackgroundWp),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      '${AssetsPath.image}/3d-wallet.png',
                      fit: BoxFit.cover,
                      width: context.width / 3,
                    ),
                    16.height,
                    const Text(
                      'Hãy nhập số tiền bạn muốn chuyển vào ví PMG',
                      style: p5,
                    ),
                    8.height,
                    Form(
                      key: _formKey,
                      child: InputCurrency(
                        controller: _amountCtl,
                        hintText: 'Nhập số tiền',
                        backgroundColor: borderColor_2,
                        inputFormatters: [
                          CurrencyTextInputFormatter.currency(
                            locale: 'vi',
                            symbol: '',
                          ),
                        ],
                        validate: (value) {
                          final amout =
                              int.tryParse(value?.replaceAll('.', '') ?? '0') ??
                                  0;
                          if (amout < 500.000) {
                            return 'Số tiền tối thiểu là 500.000đ';
                          }
                        },
                        onConfirm: (value) {
                          final validate = _formKey.currentState!.validate();
                          if (!validate) return;
                          final amout =
                              int.tryParse(value.replaceAll('.', '')) ?? 0;
                          FocusScope.of(context).unfocus();
                          context.dialog(
                            DialogConfirm(
                              title: 'Chuyển tiền',
                              content: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Bạn có chắc chắn nạp ',
                                  style: AppStyle.bodyBsRegular.copyWith(
                                    color: AppColors.text_secondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: amout.formatPrice(type: 'đ'),
                                      style: AppStyle.bodyBsSemiBold.copyWith(
                                        color: AppColors.text_secondary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' không?',
                                      style: AppStyle.bodyBsRegular.copyWith(
                                        color: AppColors.text_secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              confirm: () {
                                context.pop();
                                walletBloc
                                    .add(WalletDepositEvent(amount: amout));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    BlocBuilder<WalletBloc, WalletState>(
                      bloc: walletBloc,
                      builder: (context, state) {
                        if (state is WalletDepositUrlLoadingState) {
                          return const BaseLoading();
                        }
                        if (state is WalletDepositUrlSuccessState) {
                          return Column(
                            children: [
                              const Divider(height: 24),
                              const Text(
                                'Vui lòng quét mã qr để chuyển tiền',
                                style: p5,
                              ),
                              Text(
                                'Lưu ý: khi chuyển khoản thành công, hãy để hệ thống\ntự động thoát trang hiện tại.',
                                style: p9.copyWith(color: red_3),
                                textAlign: TextAlign.center,
                              ),
                              16.height,
                              RepaintBoundary(
                                key: _qrKey,
                                child: QrImageView(
                                  data: state.data.qrData,
                                  size: context.width / 2,
                                ),
                              ),
                              16.height,
                              RowItem2(
                                title: 'Chủ tài khoản:',
                                content: Text(state.data.accountName),
                              ),
                              8.height,
                              RowItem2(
                                title: 'Số tài khoản:',
                                content: Text(state.data.accountNumber),
                              ),
                              8.height,
                              Text(
                                'Hãy chọn ngân hàng mà bạn muốn chuyển\nMã QR sẽ được lưu trong thư viện\n(chúng tôi sẽ cập nhật tính năng tự động điền trong tương lai)',
                                style: p9.copyWith(color: blue_1),
                                textAlign: TextAlign.center,
                              ),
                              16.height,
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final item = state.listDeeplinks[index];
                                  return InkWell(
                                    onTap: () => _selectedDeeplinkHandle(item),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: bg_4,
                                        borderRadius: BorderRadius.circular(12),
                                        border:
                                            Border.all(color: borderColor_2),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          item.appLogo,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: state.listDeeplinks.length,
                              ),
                            ],
                          );
                        }
                        return 0.height;
                      },
                    ),
                  ],
                ).padding(const EdgeInsets.all(16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectedDeeplinkHandle(DeepLinkBankModel dl) async {
    final RenderRepaintBoundary boundary =
        _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    // await ImageGallerySaver.saveImage(pngBytes);
    walletBloc.add(SelectedDeeplinkBankEvent(dl: dl));
  }
}
