import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final supabase = Supabase.instance.client;

  Future<String?> pickUploadImgStorage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["jpg", "png"]);

    if (result != null) {
      Uint8List? fileBytesResult = result.files.first.bytes;
      String path = "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
      final supabase = Supabase.instance.client;
      await supabase.storage.from('imagens').uploadBinary(
            path,
            fileBytesResult!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      String imagePublicUrl =
          supabase.storage.from("imagens").getPublicUrl(path);

      return imagePublicUrl;
    }
    return null;
  }

  Future<String?> uploadImgStorage({required Uint8List imgMemory}) async {
    Uint8List? fileBytesResult = imgMemory;

    String path = "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
    final supabase = Supabase.instance.client;
    await supabase.storage.from('imagens').uploadBinary(
          path,
          fileBytesResult,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    String imagePublicUrl = supabase.storage.from("imagens").getPublicUrl(path);

    return imagePublicUrl;
  }

  Future<String?> uploadReplaceImgStorage(
      {required String publicUrl, required Uint8List imgMemory}) async {
    deleteImageFromPublicUrl(publicUrl);
    Uint8List? fileBytesResult = imgMemory;

    String path = "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
    final supabase = Supabase.instance.client;
    await supabase.storage.from('imagens').uploadBinary(
          path,
          fileBytesResult,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    String imagePublicUrl = supabase.storage.from("imagens").getPublicUrl(path);

    return imagePublicUrl;
  }

  void deleteImageFromPublicUrl(String publicUrl) async {
    final uri = Uri.parse(publicUrl);
    final segments = uri.pathSegments;

    // Verifica se é uma URL válida do Supabase
    final index = segments.indexOf('public');
    if (index == -1 || index + 1 >= segments.length) {
      return;
    }

    final bucket = segments[index + 1];
    final path = segments.skip(index + 2).join('/');

    await supabase.storage.from(bucket).remove([path]);
  }

  String getPathUrl({required String publicUrl}) {
    final uri = Uri.parse(publicUrl);
    final segments = uri.pathSegments;

    // Verifica se é uma URL válida do Supabase
    final index = segments.indexOf('public');

    final path = segments.skip(index + 2).join('/');
    return path;
  }
}
