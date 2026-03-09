import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../../../base/cache_image.dart';
import '../../../base/dialog.dart';
import '../../../base/loading.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../router/router.gr.dart';
import '../cubit/conversation_cubit/conversation_cubit.dart';
import '../cubit/conversation_cubit/conversation_state.dart';
import '../domain/entities/conversation_entity.dart';
import '../domain/entities/message_entity.dart';

@RoutePage()
class ConversationPage extends StatefulWidget {
  const ConversationPage({
    super.key,
    this.conversation,
    this.customerId,
    required this.cubit,
  });

  final ConversationEntity? conversation;
  final ConversationCubit cubit;
  final int? customerId;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late ConversationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.cubit;

    _cubit.init(
      uuid: widget.conversation?.uuid,
      conversation: widget.conversation,
    );
    _cubit.getMessages(widget.conversation?.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_5,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BlocBuilder<ConversationCubit, ConversationState>(
            bloc: _cubit,
            builder: (context, state) => _body(state),
          ),
        ),
      ),
    );
  }

  Widget _dialogCameraGallery(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(sp24, sp0, sp24, sp24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _cubit.uploadImage(context, true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: sp20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(sp12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chụp ảnh',
                      style: p3.copyWith(color: blackColor),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0.1,
              color: greyColor,
            ),
            GestureDetector(
              onTap: () => _cubit.uploadImage(context, false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(sp12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chọn ảnh từ thư viện',
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
            gapHeight(sp12),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: sp16),
                decoration: const BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hủy bỏ',
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildAreaSendMessage(ConversationState state) => Container(
        padding: const EdgeInsets.fromLTRB(sp12, sp12, sp12, sp24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => DialogUtils.showBottomDialogText(
                context,
                _dialogCameraGallery(context),
                // backgroundColor: Colors.transparent,
              ),
              child: Container(
                padding: const EdgeInsets.all(sp12),
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(120),
                  ),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  size: sp24,
                  color: greyTextColor,
                ),
              ),
            ),
            gapWidth(sp12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: sp12),
                decoration: BoxDecoration(
                  color: bg_2.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(sp54),
                ),
                child: TextField(
                  cursorColor: blackColor,
                  onChanged: _cubit.changeContent,
                  onTap: () => _cubit.scrollList(time: 500),
                  onSubmitted: (value) => _cubit.sendMessage(context),
                  focusNode: _cubit.focusText,
                  controller: _cubit.controllerText,
                  style: p3.copyWith(color: blackColor),
                  decoration: InputDecoration(
                    hintText: 'Aa',
                    hintStyle: p5.copyWith(color: greyColor),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            gapWidth(sp12),
            GestureDetector(
              onTap: () => _cubit.sendMessage(context),
              child: Container(
                decoration: BoxDecoration(
                  color: state.content != '' ? mainColor : whiteColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(sp12).copyWith(left: sp16),
                child: Icon(
                  Icons.send_rounded,
                  color: state.content != '' ? whiteColor : greyColor,
                  size: sp20,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _body(ConversationState state) => Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: sp12, horizontal: sp12),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: greyColor.withOpacity(0.2),
                  blurRadius: sp4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: greyTextColor,
                    size: 25,
                  ),
                ),
                gapWidth(sp8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(sp48),
                  child: BaseCacheImage(
                    url: state.conversation?.avatar ?? PrefKeys.avatarDefault,
                    width: sp40,
                    height: sp40,
                    fit: BoxFit.contain,
                  ),
                ),
                gapWidth(sp12),
                Expanded(
                  child: Text(
                    state.conversation?.name ?? 'Người dùng WeZolo',
                    style: h5,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (widget.customerId != null) {
                      await context.router.push(CustomerDetailRoute(id: widget.customerId!));
                    }
                    // FocusScope.of(context).unfocus();
                    // await Future.delayed(Duration(milliseconds: 200));
                    // context.router.push(
                    //     UserInfoRoute(contact: widget.contact, uuid: state.uuid));
                  },
                  child: const Icon(
                    Icons.info,
                    size: sp24,
                    color: blue_3,
                  ),
                ),
                const SizedBox(width: sp12),
              ],
            ),
          ),
          Expanded(
            child: state.messages == null
                ? const Column(
                    children: [SizedBox(height: sp40), BaseLoading()],
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(sp16),
                    controller: _cubit.msgController,
                    itemBuilder: (context, index) {
                      MessageEntity? nextMsg;
                      if (index + 1 < state.messages!.length) {
                        nextMsg = state.messages![index + 1];
                      }
                      return _oneChat(
                        state.messages![index],
                        nextMsg,
                      );
                    },
                    itemCount: state.messages!.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: sp12),
                  ),
          ),
          _buildAreaSendMessage(state),
        ],
      );

  Widget _oneChat(MessageEntity msg, MessageEntity? nextMsg) => SizedBox(
        width: widthDevice(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          // textDirection: !msg.isMe! ? TextDirection.ltr : TextDirection.rtl,
          mainAxisAlignment: msg.isMe ?? false
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Visibility(
              visible: !msg.isMe!,
              child: Container(
                width: sp20,
                margin: const EdgeInsets.only(right: sp8, bottom: sp2),
                child: Visibility(
                  visible: !msg.isMe! && nextMsg?.isMe != msg.isMe,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sp40),
                    child: BaseCacheImage(
                      url: _cubit.state.conversation?.avatar ??
                          PrefKeys.avatarDefault,
                      width: sp20,
                      height: sp20,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widthDevice(context) / 20 * 15,
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  msg.isMe ?? false ? 40 : 0,
                  0,
                  msg.isMe ?? false ? 0 : 40,
                  0,
                ),
                padding: const EdgeInsets.all(sp12),
                decoration: BoxDecoration(
                  color: msg.isMe ?? false ? mainColor : whiteColor,
                  borderRadius: BorderRadius.circular(sp16),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.05),
                      // spreadRadius: sp4,
                      blurRadius: sp4,
                    ),
                  ],
                ),
                child: Text(
                  msg.content ?? '',
                  style: p5.copyWith(
                    color: msg.isMe ?? false
                        ? whiteColor
                        : blackColor.withOpacity(0.9),
                  ),
                ),
              ),
            ),
            Visibility(
              visible:
                  (msg.isMe ?? false) && msg.status == MessageStatus.sending,
              child: Container(
                margin: const EdgeInsets.only(left: sp4),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: greyColor,
                  size: sp16,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    // _cubit.closeSocket();
    super.dispose();
  }
}
