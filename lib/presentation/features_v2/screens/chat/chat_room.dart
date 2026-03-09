import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/chat/chat_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/chat/chat_socket_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/chat/components/item_message.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../router/router.gr.dart';
import '../../models/customer/message_zalo_model.dart';
import '../../models/customer/socket_oa_model.dart';

@RoutePage()
class ScreenChatRoom extends StatefulWidget {
  final CustomerModel customer;
  const ScreenChatRoom({
    super.key,
    required this.customer,
  });

  @override
  State<ScreenChatRoom> createState() => _ScreenChatRoomState();
}

class _ScreenChatRoomState extends State<ScreenChatRoom> {
  final bloc = ChatBloc();
  final scroll = ScrollController();
  final text = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIt.call<ChatSocketBloc>().init();
    bloc.getChats(
      userId: widget.customer.zalo?.userId,
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<ChatSocketBloc, CubitState>(
      bloc: getIt<ChatSocketBloc>(),
      listener: (context, state) {
        print(state.data);
        if (state.status == BlocStatus.success) {
          final oa = SocketOAModel.fromJson(state.data);
          bloc.addChatBySocket(
            oa: oa,
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          context.unFocus();
        },
        child: Scaffold(
          backgroundColor: ColorApp.greyEA,
          appBar: _buildAppbar(),
          body: BlocBuilder<ChatBloc, CubitState>(
            bloc: bloc,
            builder: (context, state) {
              if (bloc.messages.isEmpty && state.status == BlocStatus.loading) {
                return const Center(
                  child: BaseLoading(
                    height: 100,
                  ),
                );
              }
              if (bloc.messages.isEmpty && state.status == BlocStatus.success) {
                return const Center(
                  child: Text('Chưa có tin nhắn'),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await bloc.getChats(
                    userId: widget.customer.zalo?.userId,
                    isMore: true,
                  );
                },
                child: ListView(
                  padding: 16.pading +
                      context.padding.bottom.padingBottom +
                      60.padingBottom,
                  reverse: true,
                  controller: scroll,
                  children: _buildMessages(),
                ),
              );
            },
          ),
          bottomSheet: _buildInput(),
        ),
      ),
    );
  }

  List<Widget> _buildMessages() {
    final List<Widget> list = [];
    const interval = Duration(minutes: 15);

    final Map<String, List<MessageZaloModel>> groupedMessages = {};

    List<MessageZaloModel> currentGroup = [];
    DateTime groupStartTime = bloc.messages.first.createAt ?? DateTime.now();

    for (final message in bloc.messages) {
      if (message.createAt!.isAfter(groupStartTime.subtract(interval))) {
        // Nếu tin nhắn trong khoảng thời gian nhóm hiện tại, thêm vào nhóm
        currentGroup.add(message);
      } else {
        // Nếu không, kết thúc nhóm hiện tại và bắt đầu nhóm mới
        groupedMessages[getWhen(groupStartTime)] = currentGroup;
        currentGroup = [message];
        groupStartTime = message.createAt!;
        // Bắt đầu nhóm mới từ tin nhắn hiện tại
      }
    }

    // Thêm nhóm cuối cùng
    if (currentGroup.isNotEmpty) {
      groupedMessages[getWhen(groupStartTime)] = currentGroup;
    }

    groupedMessages.forEach(
      (key, value) {
        for (final msg in value) {
          list.add(ItemMessage(message: msg));
        }
        list.add(
          Center(
            child: Chip(
              backgroundColor: Colors.blue[50],
              label: Text(
                key,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
          ),
        );
      },
    );

    // groupBy<MessageZaloModel, String>(bloc.messages, (msg) {
    //   return getWhen(msg.createAt);
    // }).forEach(
    //   (when, actualMessages) {
    //     for (final msg in actualMessages) {
    //       list.add(ItemMessage(message: msg));
    //     }
    //     list.add(
    //       Center(
    //         child: Chip(
    //           backgroundColor: Colors.blue[50],
    //           label: Text(
    //             when,
    //             style: const TextStyle(color: Colors.black54, fontSize: 14),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );

    return list;
  }

  String getWhen(DateTime? date) {
    return date.fomatCustom(fomat: 'HH:mm d MMM');
  }

  _sendMessage() {
    if (text.text.isNotEmpty) {
      bloc.sendMessage(
        userId: widget.customer.zalo?.userId ?? '',
        message: text.text,
      );
      text.clear();
      context.unFocus();
    }
  }

  _sendImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      bloc.sendImage(
        userId: widget.customer.zalo?.userId ?? '',
        image: image,
      );
    }
  }

  Widget _buildInput() {
    return Container(
      color: ColorApp.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: text,
            onEditingComplete: _sendMessage,
            decoration: InputDecoration(
              hintText: 'Nhập gì đó...',
              border: InputBorder.none,
              contentPadding: 16.pading,
              prefixIcon: IconButton(
                onPressed: _sendImage,
                icon: const Icon(
                  Icons.photo_outlined,
                  color: ColorApp.grey,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send_sharp,
                  color: ColorApp.grey,
                ),
              ),
            ),
          ),
          // 8.height,
          // Row(
          //   children: [
          //     12.width,
          //     IconBtn(
          //       onTap: () {},
          //       backgroundColor: ColorApp.white,
          //       icon: const Icon(
          //         Icons.photo_size_select_actual_outlined,
          //         color: ColorApp.grey,
          //       ),
          //     ),
          //     12.width,
          //     IconBtn(
          //       onTap: () {},
          //       backgroundColor: ColorApp.white,
          //       icon: const Icon(
          //         Icons.attachment,
          //         color: ColorApp.grey,
          //       ),
          //     ),
          //   ],
          // ),
          8.height,
          context.padding.bottom.height,
        ],
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: ColorApp.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: ColorApp.black,
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          BaseCacheImage(
            url: widget.customer.image ?? widget.customer.zalo?.zaloImg ?? '',
            borderRadius: 40.radius,
            fit: BoxFit.cover,
            height: 40,
            width: 40,
          ),
          8.width,
          Text(
            widget.customer.fullName ?? '',
            overflow: TextOverflow.ellipsis,
            style: StyleApp.medium(),
          ).expanded(),
        ],
      ),
      actions: [
        Center(
          child: GestureDetector(
            onTap: () {
              context.pushRoute(
                RouteCustomerDetail(
                  customer: widget.customer,
                ),
              );
            },
            child: Container(
              padding: 10.pading,
              margin: 16.padingRight,
              decoration: BoxDecoration(
                borderRadius: 8.radius,
                color: ColorApp.greyF5,
              ),
              child: const Icon(
                Icons.info_outline,
                color: ColorApp.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
