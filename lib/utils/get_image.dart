import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class GetImage {
  final ImagePicker _picker = ImagePicker();
  late File image;

  Future getImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.camera);
    File file = File(img!.path);
    image = file;
    // var storeImage = FirebaseStorage.instance.ref().child(image.path);
    // var task = await storeImage.putFile(image);
    // var reportImgUrl = await storeImage.getDownloadURL();
    return file;
  }

  Future imageToFireStorage() async {
    var storeImage = FirebaseStorage.instance.ref().child(image.path);
    await storeImage.putFile(image);
    var reportImgUrl = await storeImage.getDownloadURL();
    return reportImgUrl;
  }
}
