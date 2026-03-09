import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pharmago/presentation/services/local_auth.dart';
import 'package:toastification/toastification.dart';

import '../../shared/constants/pref_key.dart';
import '../../shared/constants/storage/shared_preference.dart';
import '../../shared/style_app/init_style.dart';
import '../config/app_style/init_app_style.dart';
import '../di/di.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../features/home/cubit/nav_home_bloc.dart';
import '../features/product/cubit/cubit/banner_cubit.dart';
import '../features_v2/blocs/auth/user_bloc.dart';
import '../features_v2/blocs/calendar/calendar_manager_bloc.dart';
import '../features_v2/blocs/customer/customer_manager_bloc.dart';
import '../features_v2/blocs/menu/menu_company_bloc.dart';
import '../features_v2/blocs/phieu_kham/list_pk_bloc.dart';
import '../features_v2/blocs/role/list_role_bloc.dart';
import '../features_v2/blocs/service/bloc_index.dart';
import '../features_v2/blocs/staff/staff_manager_bloc.dart';
import '../router/router.dart';
import '../router/router.gr.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = getIt.get<AppRouter>();

  @override
  void initState() {
    super.initState();

    LocalAuthService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('vi_VN', null);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavHomeBloc()..onChanged(TabCodeNav.home),
        ),
        BlocProvider(
          create: (context) => MenuCompanyBloc(),
        ),
        BlocProvider(
          create: (context) => UserBloc()..getData(),
        ),
        BlocProvider(
          create: (context) => StaffManagerBloc(),
        ),
        BlocProvider(
          create: (context) => ServiceTypeBloc()..getList(),
        ),
        BlocProvider(
          create: (context) => CustomerManagerCubit(),
        ),
        BlocProvider(
          create: (context) => CalendarManagerBloc(),
        ),
        BlocProvider(
          create: (context) => ListPhieuKhamBloc(),
        ),
        BlocProvider(
          create: (context) => ListRoleBloc()..init(),
        ),
        BlocProvider(
          create: (context) => getIt.get<AuthWsManagerCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<BannerCubit>(),
        ),
      ],
      child: ToastificationWrapper(
        child: SafeArea(
          top: false ,
          bottom: Platform.isAndroid,
          child: MaterialApp.router(
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('vi'),
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              final Locale device = deviceLocale ?? const Locale('vi');
          
              return device;
            },
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
            routerDelegate: _appRouter.delegate(
              deepLinkBuilder: (_) async {
                // final version = await CheckVersion.check(
                //   ios: 'com.idtinc.pharmagoStore',
                //   android: 'com.idtinc.pharmago',
                // );
                // if (version.isUpdate) {
                //   print(
                //     'Đã có phiên bản mới.\nPhiên bản ${version.version} đã sẵn sàng.\nBạn đang dùng ${version.localVersion}.',
                //   );
                //   return DeepLink([
                //     UpdateAppRoute(
                //       modelVersion: version,
                //     ),
                //   ]);
                // } else {
                //   print(
                //     'Phiên bản trên cửa hàng ${version.version}.\nBạn đang dùng ${version.localVersion}.',
                //   );
                // }
                return DeepLink(_mapRouteToPageRouteInfo());
              },
            ),
            routeInformationParser: _appRouter.defaultRouteParser(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: false,
              fontFamily: 'roboto',
              scaffoldBackgroundColor: AppColors.bg_primary,
              //textTheme: GoogleFonts.robotoTextTheme(Typography.tall2021),
              datePickerTheme: DatePickerThemeData(
                cancelButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => ColorApp.main,
                  ),
                ),
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => ColorApp.main,
                  ),
                ),
              ),
              colorScheme: const ColorScheme.light(
                primary: ColorApp.main,
                error: AppColors.ultility_negative_60,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PageRouteInfo> _mapRouteToPageRouteInfo() {
    final token = AppSharedPreference.instance.getValue(PrefKeys.token);
    // final rememberPass = AppSharedPreference.instance
    //     .getValue(PrefKeys.rememberPassword) as bool?;
    if (token != null) {
      //return [const WorkSpaceRoute()];
      return [const ListWorkspaceRoute()];
    }
    return [const LoginRoute()];
  }
}
