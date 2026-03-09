import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage {
  Future<XFile?> pickCropImage({
    required CropAspectRatio aspectRatio,
    required ImageSource source,
  }) async {
    final XFile? pickImage = await ImagePicker().pickImage(
      source: source,
    );
    if (pickImage == null) {
      return null;
    }
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      uiSettings: [
        AndroidUiSettings(
          showCropGrid: false,
          toolbarTitle: 'Căn chỉnh ảnh',
        ),
        IOSUiSettings(
          title: 'Căn chỉnh ảnh',
        )
      ],
      sourcePath: pickImage.path,
      // cropStyle: CropStyle.circle,
      compressQuality: 90,
      compressFormat: ImageCompressFormat.jpg,
    );
    if (croppedFile == null) {
      return null;
    }
    return XFile(croppedFile.path);
  }
}
