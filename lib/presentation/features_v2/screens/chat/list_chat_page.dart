import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features/conversation/data/models/conversation_model.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/chat/list_chat_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/color_app.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../router/router.gr.dart';

@RoutePage()
class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  final bloc = ListChatBloc();
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getChats();
    scroll.onMore(
      () {
        bloc.getChats(isMore: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Danh sách hội thoại'),
      body: BlocBuilder<ListChatBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return LoadListPage(
            state: state,
            listEmpty: bloc.users.isEmpty,
            child: ListView.separated(
              controller: scroll,
              padding: 16.pading,
              itemCount: bloc.users.length,
              itemBuilder: (context, index) => _buildUser(bloc.users[index]),
              separatorBuilder: (context, index) => const Divider(
                height: 0,
                color: ColorApp.greyE2,
              ),
            ).expanded(),
          );
        },
      ),
    );
  }

  ListTile _buildUser(ConversationModel user) {
    return ListTile(
      onTap: () {
        context.pushRoute(
          RouteChatRoom(
            customer: CustomerModel(
              id: user.id,
              fullName: user.name,
              image: user.image,
              uuid: user.uuid,
              conversation: ConversationModel(
                id: user.id,
                uuid: user.uuid,
                lastMessage: user.lastMessage,
                image: user.image,
                name: user.name,
                updatedAt: user.createdAt,
                createdAt: user.lastMessage?.createdAt,
              ),
            ),
          ),
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: BaseCacheImage(
        url: user.image ?? '',
        borderRadius: 40.radius,
        height: 50,
        width: 50,
      ),
      title: Row(
        children: [
          Text(
            user.name ?? '',
            style: StyleApp.semibold(),
          ).expanded(),
          Text(
            user.lastMessage?.createdAt.fomatCustom(fomat: 'hh:mm a') ?? '',
            maxLines: 2,
            style: StyleApp.semibold(),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Text(
            '${(user.lastMessage?.isMe ?? false) ? 'Bạn: ' : ''} ${user.lastMessage?.message}'.trim(),
            style: StyleApp.normal(color: ColorApp.grey79),
            maxLines: 2,
          ).expanded(),
          Visibility(
            visible: user.lastMessage?.read == true,
            child: const Icon(
              Icons.check_rounded,
              size: 10,
              color: ColorApp.blue20,
            ),
          ),
          // Visibility(
          //   visible: user.lastMessage?.read == true &&
          //       user.lastMessage?.isMe == false,
          //   child: const Icon(
          //     Icons.circle,
          //     size: 10,
          //     color: ColorApp.main,
          //   ),
          // ),
        ],
      ),
    );
  }
}
