import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:notes/controllers/loading_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class UploadService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndUploadImage(BuildContext context) async {
    final loading = Provider.of<LoadingController?>(context, listen: false);

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      loading?.loading(true);
      String url = await uploadImage(file);
      loading?.loading(false);

      return url;
    }
    return null; // Return null if no file was picked
  }

  Future<String> uploadImage(File file) async {
    // Read the image
    final image = img.decodeImage(file.readAsBytesSync());

    // Resize the image to reduce quality
    final resizedImage =
        img.copyResize(image!, width: 200); // Resize to 100px width

    // Get the temp directory to save the resized image
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_image.jpg')
      ..writeAsBytesSync(
          img.encodeJpg(resizedImage, quality: 60)); // Set quality to 50

    // Create a reference to Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the file
    UploadTask uploadTask = ref.putFile(tempFile);

    // Wait for the upload to complete
    TaskSnapshot snapshot = await uploadTask;

    // Get the download URL
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
