import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../../../base/cache_image.dart';
import '../../../base/empty_container.dart';
import '../../../base/loading.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../cubit/conversation_cubit/conversation_cubit.dart';
import '../cubit/conversation_cubit/conversation_state.dart';
import '../domain/entities/conversation_entity.dart';

@RoutePage()
class ConversationListPage extends StatefulWidget {
  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  final _myBloc = getIt.get<ConversationCubit>();

  final ScrollController _scrollController = ScrollController();

  double heightItem = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final maxHeightOnePage = heightItem * _myBloc.state.limit;
      final max = maxHeightOnePage * _myBloc.state.page;
      final min = heightItem * (_myBloc.state.page - 1);
      if (min <= _scrollController.offset && _scrollController.offset <= max) {
        _myBloc.listConversation();
      }
    });
  }

  @override
  void dispose() {
    _myBloc.closeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<ConversationCubit>(
        create: (context) => _myBloc
          ..listConversation()
          ..initRealtimeMessage(),
        child: BlocBuilder<ConversationCubit, ConversationState>(
          builder: (context, state) => Scaffold(
            appBar: const BaseAppBar(
              title: 'Danh sách hội thoại',
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: sp16),
              color: whiteColor,
              child: Column(
                children: [
                  gapHeight(sp16),
                  AppInputSupport(
                    hintText: 'Tìm kiếm bạn bè',
                    onConfirm: _myBloc.changeSearch,
                    radius: sp32,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: blackColor,
                    ),
                    suffixIcon: Container(
                      padding: const EdgeInsets.only(right: sp12),
                      child: const Icon(Icons.qr_code),
                    ),
                    backgroundColor: bg_5,
                    borderColor: bg_5,
                  ),
                  gapHeight(sp16),
                  Expanded(
                    child: state.conversations == null
                        ? const BaseLoading()
                        : state.conversations!.isEmpty
                            ? const EmptyContainer()
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 14),
                                controller: _scrollController,
                                itemBuilder: (context, index) =>
                                    _oneChat(state.conversations![index]),
                                itemCount: state.conversations!.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(
                                  height: sp24,
                                  color: greyColor.withOpacity(0.2),
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _oneChat(ConversationEntity conversation) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          heightItem = constraints.maxHeight;
          return InkWell(
            onTap: () => context.router.push(
              ConversationRoute(
                conversation: conversation,
                cubit: _myBloc,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BaseCacheImage(
                    url: conversation.avatar ?? PrefKeys.avatarDefault,
                    width: sp48,
                    height: sp48,
                  ),
                ),
                gapWidth(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              conversation.name ?? 'Người dùng WeZolo',
                              style: h6.copyWith(color: blackColor),
                            ),
                          ),
                          gapWidth(sp16),
                          Text(
                            DateFormat('hh:mm a').format(
                              conversation.lastMessage?.createdAt ??
                                  DateTime.now(),
                            ),
                            style: p7.copyWith(color: greyColor),
                          ),
                        ],
                      ),
                      gapHeight(sp4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${(conversation.lastMessage?.isMe ?? false) ? 'Bạn: ' : ''} ${conversation.lastMessage?.content}',
                              style: (conversation.lastMessage?.isRead ?? false)
                                  ? p8.copyWith(color: greyColor)
                                  : p7.copyWith(color: greyColor),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                          gapWidth(sp64),
                          Visibility(
                            visible:
                                (conversation.lastMessage?.isRead ?? false),
                            child: const Icon(
                              Icons.check_rounded,
                              size: sp16,
                              color: blue_3,
                            ),
                          ),
                          Visibility(
                            visible:
                                !(conversation.lastMessage?.isRead ?? false) &&
                                    !(conversation.lastMessage?.isMe ?? true),
                            child: const Icon(
                              Icons.circle,
                              size: sp12,
                              color: green_1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
}
