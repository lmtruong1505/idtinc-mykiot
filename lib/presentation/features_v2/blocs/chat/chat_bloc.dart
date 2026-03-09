import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../models/customer/message_zalo_model.dart';
import '../../models/customer/socket_oa_model.dart';
import '../../repositories/chat/chat_repository.dart';
import '../state/init_state.dart';

class ChatBloc extends Cubit<CubitState> {
  ChatBloc() : super(CubitState());

  //wss://core.wezolo.com/socket/?workspace=${this.companyData.workspace}

  final _repo = ChatRepositoryV2();
  final List<MessageZaloModel> messages = [];
  int _page = 1;

  getChats({
    bool isMore = false,
    String? userId,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      messages.clear();
    }
    final length = messages.length;
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getMessage(
      userId: userId,
      page: _page,
      limit: 20,
    );
    if (isMore) {
      res.data?.forEach(
        (element) {
          messages.insert(length, element);
        },
      );
    } else {
      res.data?.forEach(
        (element) {
          messages.insert(0, element);
        },
      );
    }
    //messages.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }

  sendMessage({
    required String userId,
    required String message,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    messages.insert(
      0,
      MessageZaloModel(
        isMe: true,
        read: true,
        id: id,
        messageText: message,
        state: StateMessage.loading,
        createAt: DateTime.now(),
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
    emit(state.copyWith(status: BlocStatus.success));
    final res = await _repo.sendMessage(
      userId: userId,
      message: message,
    );
    final index = messages.indexWhere(
      (element) => element.id == id,
    );
    if (index != -1) {
      if (res.code == 200) {  
        messages.removeAt(index);
      } else {
        messages[index].state = StateMessage.error;
      }
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  sendImage({
    required String userId,
    required XFile image,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    messages.insert(
      0,
      MessageZaloModel(
        isMe: true,
        read: true,
        id: id,
        messageText: '',
        attachments: [
          Attachments(
            type: 'image',
            thumbnail: image.path,
            url: image.path,
            isFile: true,
          ),
        ],
        state: StateMessage.loading,
        createAt: DateTime.now(),
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
    emit(state.copyWith(status: BlocStatus.success));
    final res = await _repo.uploadImage(
      image: image,
    );
    final index = messages.indexWhere(
      (element) => element.id == id,
    );
    if (res.data.validator.isNotEmpty) {
      final resMessage = await _repo.sendMessage(
        userId: userId,
        message: '',
        attachments: res.data,
      );

      if (index != -1) {
        if (resMessage.code == 200) {
          messages.removeAt(index);
        } else {
          messages[index].state = StateMessage.error;
        }
      }
    } else if (index != -1) {
      messages[index].state = StateMessage.error;
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  addChatBySocket({
    required SocketOAModel oa,
  }) {
    final DateTime? createAt = DateTime.tryParse(oa.timestamp ?? '');

    messages.insert(
      0,
      MessageZaloModel(
        isMe: oa.sendBy == 'OA',
        read: true,
        id: createAt?.millisecondsSinceEpoch,
        messageId: oa.messageId,
        messageText: oa.message,
        attachments: oa.attachments,
        createAt: createAt ?? DateTime.now(),
        timestamp: oa.timestamp,
        sendBy: oa.sendBy,
      ),
    );

    messages.removeWhere(
      (element) => (element.messageId.isEmptyOrNull &&
          element.state != StateMessage.loading &&
          element.state != StateMessage.error),
    );
    emit(state.copyWith(status: BlocStatus.success));
  }
}
