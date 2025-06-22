// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(String path, String filePath) async {
    File file = File(filePath);

    final filename = basename(filePath);

    String? downloadLink;
    Reference ref = _firebaseStorage
        .ref()
        .child(path)
        .child("${DateTime.now()}.${filename.split(".").last}");
    TaskSnapshot uploadTask = await ref.putFile(file).whenComplete(() {});
    downloadLink = await uploadTask.ref.getDownloadURL();

    return downloadLink;
  }

  Future<UploadTask> uploadFiles(String path, String filePath) async {
    File file = File(filePath);
    Reference ref = _firebaseStorage.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    return uploadTask;
  }

  Future<String> uploadImageData(
    String path,
    Uint8List byteList,
    String filename,
  ) async {
    String? downloadLink;
    Reference ref = _firebaseStorage.ref().child(path).child(filename);
    TaskSnapshot uploadTask = await ref.putData(byteList).whenComplete(() {});
    downloadLink = await uploadTask.ref.getDownloadURL();

    return downloadLink;
  }
}
