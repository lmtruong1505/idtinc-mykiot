import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/wallet/bloc/bloc/wallet_event.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../base/loading.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../bloc/bloc/wallet_bloc.dart';
import '../bloc/bloc/wallet_state.dart';
import '../data/models/wallet_transaction_model.dart';

@RoutePage()
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  bool _shouldShowTitle = false;
  final walletBloc = getIt.get<WalletBloc>();
  final _scrollController = ScrollController();
  final _scrollDebebtController = ScrollController();
  final _infiniteListController =
      InfiniteListController<TransactionModel>.init();

  final _infiniteListDebebtController =
      InfiniteListController<DebebtTransactionModel>.init();

  late TabController? tabCtrl;

  @override
  void initState() {
    super.initState();
    tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const BaseAppBar(title: 'Ví của bạn'),
      body: BlocListener<WalletBloc, WalletState>(
        bloc: walletBloc,
        listener: (context, state) {
          // if (state is WalletDepositUrlSuccessState) {
          //     context.router.push(const WalletDepositRoute());
          // }
        },
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _infiniteListController.onRefresh();
              _infiniteListDebebtController.onRefresh();
              walletBloc.add(WalletDetailEvent());
              // walletBloc
              //   ..listDebt(0)
              //   ..listTransaction(0);
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: whiteColor,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  expandedHeight: 250,
                  toolbarHeight: 64,
                  pinned: true,
                  floating: true,
                  snap: true,
                  excludeHeaderSemantics: true,
                  titleSpacing: 0,
                  title: AnimatedCrossFade(
                    firstChild: 0.height,
                    secondChild: _titleCollapsed,
                    crossFadeState: _shouldShowTitle
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          // Điều kiện để hiển thị title:
                          // 1. Chiều cao hiện tại nhỏ hơn chiều cao mở rộng
                          // 2. Đã được ghim
                          _shouldShowTitle = constraints.maxHeight < 32 + 48 &&
                              constraints.maxHeight >= 32;
                        });
                      });
                      return FlexibleSpaceBar(
                        background: _balanceView,
                        titlePadding: const EdgeInsets.all(0),
                        collapseMode: CollapseMode.parallax,
                      );
                    },
                  ),
                ),
                SliverAppBar(
                  backgroundColor: whiteColor,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  // expandedHeight: 250,
                  toolbarHeight: 75,
                  pinned: true,
                  // floating: true,
                  // snap: true,
                  excludeHeaderSemantics: true,
                  // titleSpacing: 0,
                  title: _buildTab(),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: tabCtrl,
                    children: [
                      InfiniteList<TransactionModel>(
                        shrinkWrap: true,
                        getData: (page) {
                          return walletBloc.listTransaction(page);
                        },
                        itemBuilder: (context, item, index) {
                          final isOut = item.type == 'output';
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: borderColor_2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isOut ? 'Chi tiêu ZNS' : 'Nạp tiền vào ví',
                                  style: p6.copyWith(color: greyTextColor),
                                ),
                                Text(
                                  '${isOut ? '- ' : ''}${item.amount.formatCurrency}đ',
                                  style: p5.copyWith(
                                      color: isOut ? red_1 : green_1),
                                ),
                              ],
                            ),
                          );
                        },
                        scrollController: _scrollController,
                        infiniteListController: _infiniteListController,
                        heightGap: 0,
                        circularProgressIndicator: const BaseLoading(),
                        noItemFoundWidget: const EmptyContainer(),
                      ),
                      InfiniteList<DebebtTransactionModel>(
                        shrinkWrap: true,
                        getData: (page) => walletBloc.listDebt(page),
                        itemBuilder: (context, item, index) {
                          final isInput = item.type == 'input';
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: borderColor_2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.metaData?['message'] ?? '',
                                  style: p6.copyWith(color: greyTextColor),
                                ),
                                Text(
                                  '${isInput ? '- ' : ''}${item.amount.formatCurrency}đ',
                                  style: p5.copyWith(
                                    color: isInput ? red_1 : green_1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        scrollController: _scrollDebebtController,
                        infiniteListController: _infiniteListDebebtController,
                        heightGap: 0,
                        circularProgressIndicator: const BaseLoading(),
                        noItemFoundWidget: const EmptyContainer(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _titleCollapsed {
    return Container(
      color: mainColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Image.asset(
            '${AssetsPath.image}/apple-wallet.png',
            fit: BoxFit.cover,
            width: 24,
          ),
          8.width,
          BlocBuilder<WalletBloc, WalletState>(
            bloc: walletBloc,
            builder: (context, state) {
              return Text(
                '${walletBloc.wallet?.balance.formatCurrency} đ',
                style: h2.copyWith(color: whiteColor),
              );
            },
          ),
          const Spacer(),
          const Icon(Icons.add_circle_outline_rounded),
        ],
      ),
    );
  }

  Widget get _balanceView {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24)
          .copyWith(right: 0, bottom: 16),
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: mainColor,
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('${AssetsPath.image}/background_wp.png'),
          colorFilter: ColorFilter.mode(mainColor, BlendMode.difference),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  FaIcon(iconCode: 'f555', color: whiteColor),
                  8.width,
                  Text(
                    'Ví Pharmago',
                    style: p9.copyWith(color: whiteColor),
                  ),
                ],
              ),
              BlocBuilder<WalletBloc, WalletState>(
                bloc: walletBloc,
                builder: (context, state) {
                  return Text(
                    '${walletBloc.wallet?.balance.formatCurrency} đ',
                    style: h2.copyWith(color: whiteColor),
                  );
                },
              ),
              SupportButton(
                backgroundColor: blackColor.withOpacity(0.75),
                radius: 16,
                title: 'Nạp tiền',
                color: whiteColor,
                event: () {
                  // walletBloc.add(WalletDepositEvent(amount: 10000));
                  context.router.push(const WalletDepositRoute());
                },
                largeButton: false,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          16.width,
          Expanded(
            child: Image.asset(
              '${AssetsPath.image}/3d-wallet.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  // Widget get _actionsButtonView {
  //   return GridView(
  //     padding: const EdgeInsets.all(0),
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 4,
  //       childAspectRatio: 0.5,
  //       crossAxisSpacing: 8,
  //       // mainAxisExtent: 200,
  //     ),
  //     children: [
  //       // _itemAction(title: 'Nạp tiền', faIcon: 'e09a'),
  //       // _itemAction(title: 'Rút tiền', faIcon: 'e094'),
  //       // _itemAction(title: 'Lịch sử', faIcon: 'f7fd'),
  //       // _itemAction(title: 'Chi tiết', faIcon: 'f555'),
  //     ],
  //   );
  // }

  final tabTitle = ['Lịch sử ', 'Công nợ'];

  Widget _buildTab() {
    return TabBar(
      controller: tabCtrl,
      isScrollable: true,
      labelColor: AppColors.text_primary,
      labelStyle: AppStyle.bodyBsMedium,
      unselectedLabelColor: AppColors.text_tertiary,
      unselectedLabelStyle: AppStyle.bodyBsRegular,
      indicator: BoxDecoration(
        borderRadius: 50.radius,
        color: AppColors.bg_primary,
        boxShadow: AppShadows.elevator0,
      ),
      onTap: (value) {
        // final maxPixel = scrollTab.position.maxScrollExtent;
        // final pixel = maxPixel / tabTitle.length;
        // if (value == tabTitle.length - 1) {
        //   scrollTab.animateTo(
        //     maxPixel,
        //     duration: 300.milliseconds,
        //     curve: Curves.linear,
        //   );
        // } else {
        //   scrollTab.animateTo(
        //     pixel * value,
        //     duration: 300.milliseconds,
        //     curve: Curves.linear,
        //   );
        // }
      },
      tabs: List.generate(
        tabTitle.length,
        (index) => Tab(
          height: 37,
          text: tabTitle[index],
        ),
      ),
    ).container(
      padding: EdgeInsets.zero,
      bgColor: AppColors.bg_secondary,
      radius: 50,
      border: Border.all(
        color: AppColors.border_tertiary,
      ),
    );
  }

  Widget _itemAction({
    String? title,
    String? faIcon,
    Function? onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: black5o,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              '${AssetsPath.image}/3d-wallet-trans.png',
              width: 28,
            ),
            // FaIcon(
            //   iconCode: faIcon ?? 'f555',
            // ),
          ),
          4.height,
          Text(
            title ?? 'data',
            style: p5.copyWith(color: blackColor),
          ),
        ],
      ),
    );
  }
}
