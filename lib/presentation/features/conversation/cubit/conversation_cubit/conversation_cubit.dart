import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../data/apis/end_point.dart';
import '../../../../../shared/constants/pref_key.dart';
import '../../../../base/dialog.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecase/conversation_list_use_case.dart';
import '../../domain/usecase/delete_message_use_case.dart';
import '../../domain/usecase/message_list_use_case.dart';
import 'conversation_state.dart';

@injectable
class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit(
    this._conversationListUseCase,
    this._deleteMessageUseCase,
    this._messageListUseCase,
    // this._sendMessageUseCase,
  ) : super(ConversationState());

  // final ChatUseCase _useCase;
  final ConversationListUseCase _conversationListUseCase;
  // final SendMessageUseCase _sendMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final MessageListUseCase _messageListUseCase;
  final ScrollController chatController = ScrollController();
  WebSocketChannel? channel;

  void init({
    String? uuid,
    String? contact,
    ConversationEntity? conversation,
  }) async {
    if (conversation == null) {
      // emit(state.copyWith(search: contact?.phone ?? ''));
      final input = ConversationListInput(
        search: contact,
        page: 1,
        limit: 1,
      );
      final res = await _conversationListUseCase.execute(input);
      if (res.response.data?.isNotEmpty ?? false) {
        emit(
          state.copyWith(
            conversation: res.response.data![0],
            uuid: res.response.data![0].uuid,
          ),
        );
        getMessages(state.conversation!.uuid);
      }
      return;
    } else {
      emit(
        state.copyWith(
          uuid: uuid,
          conversation: conversation,
        ),
      );
    }
  }

  final TextEditingController controllerText = TextEditingController();
  final FocusNode focusText = FocusNode();

  void changeSearch(String search) {
    emit(
      state.copyWith(
        search: search,
        page: 1,
        conversations: [],
        canLoadMore: true,
      ),
    );
    listConversation();
  }

  Future<void> changeContent(String content) async {
    if (state.content != '' && content == '' ||
        state.content == '' && content != '') {
      scheduleMicrotask(() => emit(state.copyWith(content: content)));
    } else {
      emit(state.copyWith(content: content));
    }
  }

  void initRealtimeMessage() => _runSocket();

  final ScrollController msgController = ScrollController();
  void getMessages(String? uuid) async {
    if (uuid != null) {
      final input = MessageListInput(uuid: uuid, page: 1, limit: 20);
      final res = await _messageListUseCase.execute(input);
      emit(state.copyWith(messages: res.response.data));
      scrollList();
    } else {
      emit(state.copyWith(messages: []));
    }
  }

  Future<void> _runSocket() async {
    try {
      final wsUrl = Uri.parse('${Api.urlSocket}?oa_id=${PrefKeys.oaId}');
      channel = WebSocketChannel.connect(wsUrl);
      if (channel == null) return;
      await channel!.ready;
      channel!.stream.listen((message) {
        final json = jsonDecode(message.toString());
        _affterHearMessage(json);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> closeSocket() async {
    if (channel != null) channel!.sink.close(status.goingAway);
  }

  /// This function handle message affter hear from Socket
  ///
  /// This function requrired input type [Map], inside:
  ///
  /// 1. If message was sended by current account, this function will add new [MessageEntity]
  /// into state [ConversationState] => messages
  ///
  /// 2. Querry in state [ConversationState] (chats) => Find [ConversationEntity] in List and Update
  void _affterHearMessage(Map<String, dynamic> json) {
    final content = json['message'];
    final sendBy = json['send_by'];
    final userId = json['user_id'];
    try {
      if (state.uuid != null && userId != null && sendBy == 'USER') {
        // 1. Add
        _addMessage(
          isMe: false,
          content: content,
          status: MessageStatus.sended,
        );
      }
      if (state.uuid != null && userId != null && sendBy == 'OA') {
        final list = List<MessageEntity>.from(state.messages ?? []);
        final index = list.lastIndexWhere((e) => e.content == content);
        list[index] = list[index].copyWith(status: MessageStatus.sended);
        emit(state.copyWith(messages: list, content: ''));
      }
      if (state.conversations?.isNotEmpty ?? false) {
        // 2. Querry vs Add
        final list = List<ConversationEntity>.from(state.conversations ?? []);
        final index = list.indexWhere((e) => e.uuid == userId);
        list[index] = list[index].copyWith(
          lastMessage: MessageEntity(
            content: content,
            isRead: state.conversation == null ? false : true,
            status: MessageStatus.sended,
            isMe: sendBy != 'USER',
          ),
        );
        emit(state.copyWith(conversations: list));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> sendMessage(BuildContext context) async {
    if (state.content == '' || state.uuid == null) return;
    try {
      final payload = {
        'message': state.content,
        'oa_id': PrefKeys.oaId,
        'send_by': 'OA',
        'user_id': state.uuid,
      };
      channel!.sink.add(jsonEncode(payload));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    // final input = SendMessageInput(uuid: state.uuid!, content: state.content);
    _addMessage();
    // final rp = await _sendMessageUseCase.execute(input);
    // final list = List<MessageEntity>.from(state.messages ?? []);
    // final index = list.indexWhere(
    //   (e) =>
    //       e.content == rp.response.data?.content &&
    //       e.status == MessageStatus.sending,
    // );
    // list[index] = list[index].copyWith(status: MessageStatus.sended);
    // emit(state.copyWith(messages: list));
    // if (rp.response.code != 200 && rp.response.code != 201) {
    //   // ignore: use_build_context_synchronously
    //   DialogUtils.showErrorDialog(
    //     context,
    //     content: rp.response.message ?? 'Lỗi kết nối máy chủ!',
    //   );
    // }
  }

  void _addMessage({bool? isMe, String? content, MessageStatus? status}) {
    final list = List<MessageEntity>.from(state.messages ?? []);
    list.add(
      MessageEntity(
        content: content ?? state.content,
        createdAt: DateTime.now(),
        isMe: isMe ?? true,
        status: status ?? MessageStatus.sending,
      ),
    );
    emit(state.copyWith(messages: list, content: ''));
    controllerText.clear();
    scrollList();
  }

  var scrolling = false;
  void scrollList({int? time}) => scheduleMicrotask(
        () async {
          // if (scrolling) return;?
          scrolling = true;
          await Future.delayed(Duration(milliseconds: time ?? 50));
          msgController.animateTo(
            msgController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn,
          );
          scrolling = false;
        },
      );

  void changeUuid(String? uuid) => emit(state.copyWith(uuid: uuid));

  void deleteMessages(BuildContext context) => DialogUtils.showErrorDialog(
        context,
        content:
            'Bạn có chắc chắn muốn xoá cuộc trò chuyện này?\nThao tác này không thể hoàn tác.',
        titleClose: 'Huỷ',
        titleConfirm: 'Xác nhận',
        close: () => Navigator.of(context).pop(),
        accept: () async {
          Navigator.of(context).pop();
          DialogUtils.showLoadingDialog(
            context,
            'Đang xoá cuộc trò chuyện, vui lòng đợi!',
          );
          final input = DeleteMessageInput(uuid: state.uuid!);
          final res = await _deleteMessageUseCase.execute(input);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          if (res.response.code == 200) {
            // ignore: use_build_context_synchronously
            await DialogUtils.showSuccessDialog(
              context,
              content: 'Xoá cuộc trò chuyện thành công!!!',
              barrierDismissible: true,
            );
            changeUuid(null);
            return;
          }
          // ignore: use_build_context_synchronously
          DialogUtils.showErrorDialog(
            context,
            content: 'Xoá cuộc trò chuyện không thành công!!!',
          );
        },
      );

  Future<void> uploadImage(BuildContext context, bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? picture = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (picture == null) return;
    final size = await picture.length();
    if (size > 5 * 1024 * 1024) {
      // ignore: use_build_context_synchronously
      DialogUtils.showErrorDialog(
        context,
        content: 'Ảnh đại diện không được quá 5M.\nVui lòng chọn ảnh khác!',
      );
      return;
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    emit(state.copyWith(image: File(picture.path)));
  }

  Future<void> listConversation() async {
    if (!state.canLoadMore) return;
    emit(state.copyWith(canLoadMore: false));
    final input = ConversationListInput(
      search: state.search,
      page: state.page,
      limit: state.limit,
    );
    final res = await _conversationListUseCase.execute(input);
    emit(
      state.copyWith(
        conversations: res.response.data,
        page: state.page + 1,
        canLoadMore: true,
      ),
    );
    if ((res.response.data?.isEmpty ?? true) ||
        (res.response.data?.length ?? 0) < state.limit) {
      emit(state.copyWith(canLoadMore: false));
    }
  }
}
