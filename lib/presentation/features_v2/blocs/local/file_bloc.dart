import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../repositories/events/event_repository.dart';
import '../enum/bloc_status.dart';
import '../state/cubit_state.dart';

class FileBloc extends Cubit<CubitState> {
  FileBloc() : super(CubitState());
  final picker = ImagePicker();
  XFile? file;
  final List<XFile> files = [];
  final _repo = EventRepository();

  chooseImage({ImageSource source = ImageSource.gallery}) async {
    emit(state.copyWith(status: BlocStatus.loading));
    file = await picker.pickImage(source: source);
    emit(state.copyWith(status: BlocStatus.success));
  }

  chooseFile({
    Function(XFile)? callBack,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = result.xFiles.first;
      files.addAll(result.xFiles);
      callBack?.call(result.xFiles.first);
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  uploadFile({
    required int customerId,
    required String type,
    String? appointmentSchedule,
    String? medicalBill,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'docx',
        'pdf',
        'doc',
      ],
    );
    if (result != null) {
      emit(state.copyWith(status: BlocStatus.loading));
      final res = await _repo.uploadFile(
        customerId: customerId,
        files: result.xFiles,
        type: type,
        appointmentSchedule: appointmentSchedule,
        medicalBill: medicalBill,
      );
      if (res.code == 200) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            msg: 'Tải file lên thành công',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.failure,
            msg: res.message ?? 'Tải file lên không thành công',
          ),
        );
      }
    }
  }

  remove(int index) {
    files.removeAt(index);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
