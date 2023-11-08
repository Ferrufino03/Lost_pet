import 'package:image_picker/image_picker.dart';

Future<XFile?> getResource(ImageSource img) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: img);
  return image;
}
