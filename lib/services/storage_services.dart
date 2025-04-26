import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String> uploadFile({
    String mainPath = 'uploads',
    required String filePath,
    required String fileName,
    bool isDeleted = false,
  }) async {
    try {
      final File originalFile = File(filePath);
      if (!originalFile.existsSync()) {
        throw Exception("File does not exist: $filePath");
      }

      final Stopwatch stopwatch = Stopwatch()..start();
      File? compressedFile = await _compressImage(originalFile);
      if (compressedFile == null) {
        throw Exception("Failed to compress image.");
      }
      Uint8List bytes = await compressedFile.readAsBytes();
      final UploadTask uploadTask =
          storage.ref('$mainPath/$fileName').putData(bytes);
      final TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      stopwatch.stop();
      if (isDeleted) {
        Future.delayed(const Duration(minutes: 5), () async {
          await deleteFile(mainPath, fileName);
        });
      }
      return downloadURL;
    } catch (e) {
      if (kDebugMode) print('❌ Failed to upload file: $e');
      return '';
    }
  }

  static Future<File?> _compressImage(File file) async {
    if (await file.length() < 500 * 1024) {
      return file;
    }

    final String targetPath =
        '${file.parent.path}/compressed_${file.uri.pathSegments.last}';

    try {
      final XFile? result = await compute(_compressWorker, {
        'path': file.absolute.path,
        'target': targetPath,
      });
      return result != null ? File(result.path) : null;
    } catch (e) {
      if (kDebugMode) print('Error compressing image: $e');
      return null;
    }
  }

  static Future<XFile?> _compressWorker(Map<String, String> args) async {
    return await FlutterImageCompress.compressAndGetFile(
      args['path']!,
      args['target']!,
      quality: 80,
      format: CompressFormat.jpeg,
    );
  }

  static Future<String?> getFileUrl({
    required String mainPath,
    required String fileName,
  }) async {
    try {
      String downloadURL =
          await storage.ref('$mainPath/$fileName').getDownloadURL();
      return downloadURL;
    } catch (e) {
      if (kDebugMode) print('Failed to get file URL: $e');
      return null;
    }
  }

  static Future<void> deleteFile(String mainPath, String fileName) async {
    final fullPath = '$mainPath/$fileName';

    try {
      await storage.ref(fullPath).delete();
      if (kDebugMode) print('✅ File deleted at: $fullPath');
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        if (kDebugMode) {
          debugPrint('⚠️ File not found at $fullPath, skipping delete...');
        }
      } else {
        if (kDebugMode) {
          debugPrint('❌ FirebaseException while deleting: ${e.code} - ${e.message}');
        }
        rethrow;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Unexpected error deleting file at $fullPath: $e');
      }
      rethrow;
    }
  }
}
