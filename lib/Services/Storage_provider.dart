import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:inventory/Services/Base_Storage_provider.dart';

import 'package:uuid/uuid.dart';

class StorageProvider extends BaseStorageProvider {
  final FirebaseStorage _firebaseStorage;

  StorageProvider({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = FirebaseStorage.instance;

  Future<String> _uploadImage({
    required File image,
    required String ref,
  }) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  // @override
  // Future<String> uploadProductImage({File? image}) {

  //   throw UnimplementedError();
  // }

  // Future<String> uploadProfileImage({
  //   required String url,
  //   required File image,
  // }) async {
  //   var imageId = Uuid().v4();

  //   //Update User Profile image by id.
  //   if (url.isNotEmpty) {
  //     final exp = RegExp(r'userProfile_(.*).jpg');
  //     imageId = exp.firstMatch(url)[1];
  //     // imageId = exp.firstMatch(url)[1];
  //   }

  //   final downloadUrl = await _uploadImage(
  //     image: image,
  //     ref: "images/users/userProfile_$imageId.jpg",
  //   );
  //   return downloadUrl;
  // }
  @override
  Future<String> uploadProductImage({required File? image}) async {
    final imageId = Uuid().v4();
    final downloadUrl = await _uploadImage(
      image: image as File,
      ref: 'products/product_$imageId.jpg',
    );
    return downloadUrl;
  }
}
