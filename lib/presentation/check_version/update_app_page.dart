import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/constants/pref_key.dart';
import '../../shared/constants/storage/shared_preference.dart';
import '../base/app_bar.dart';
import '../constants/spacing.dart';
import 'check_vesion.dart';

@RoutePage()
class UpdateAppPage extends StatefulWidget {
  final ModelVersion modelVersion;
  const UpdateAppPage({
    super.key,
    required this.modelVersion,
  });

  @override
  State<UpdateAppPage> createState() => _UpdateAppPageState();
}

class _UpdateAppPageState extends State<UpdateAppPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        backgroundColor: ColorApp.bgScreen,
        appBar: const BaseAppBar(
          title: 'Cập nhật phiên bản',
        ),
        body: SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: 16.padingHor + 16.padingTop,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: ColorApp.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorApp.black.withOpacity(0.3),
                      blurRadius: sp4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Đã có phiên bản mới',
                      style: StyleApp.medium(fontSize: 16),
                    ),
                    const SizedBox(height: sp16),
                    RichText(
                      text: TextSpan(
                        text: 'Phiên bản mới: ',
                        style: StyleApp.normal(color: ColorApp.grey79),
                        children: [
                          TextSpan(
                            text: '${widget.modelVersion.version} (có sẵn)',
                            style: StyleApp.normal(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: sp12),
                    RichText(
                      text: TextSpan(
                        text: 'Phiên bản đang sử dụng: ',
                        style: StyleApp.normal(color: ColorApp.grey79),
                        children: [
                          TextSpan(
                            text: widget.modelVersion.localVersion,
                            style: StyleApp.normal(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: sp24),
                    MainButtonV2(
                      title: 'Tải xuống bản cập nhật mới ngay !',
                      onTap: _updateApp,
                      icon: const Icon(
                        Icons.download_rounded,
                        size: sp20,
                        color: ColorApp.white,
                      ),
                    ),
                    MainButtonV2(
                      title: 'Bỏ qua',
                      backgroundColor: ColorApp.white,
                      textStyle: StyleApp.medium(color: ColorApp.blue20),
                      onTap: () {
                        final token = AppSharedPreference.instance
                            .getValue(PrefKeys.token);
                        if (token != null) {
                          context.router.replaceAll([const WorkSpaceRoute()]);
                        } else {
                          context.router.replaceAll([const LoginRoute()]);
                        }
                      },
                      icon: const Icon(
                        Icons.navigate_next,
                        size: sp20,
                        color: ColorApp.white,
                      ),
                    ),
                    5.height,
                  ],
                ),
              ),
              const SizedBox(height: sp24),
              Text(
                'Phiên bản mới có gì',
                style: StyleApp.medium(color: ColorApp.grey79),
              ),
              context.padding.bottom.height,
              50.height,
            ],
          ),
        ),
      ),
    );
  }

  void _updateApp() async {
    if (Platform.isAndroid) {
      final url = Uri.parse(widget.modelVersion.url ?? '');
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else if (Platform.isIOS) {
      final url = Uri.parse(widget.modelVersion.url ?? '');
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
