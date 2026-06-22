import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

Future<File> urlToFileCached(String imageUrl) async {
  if (imageUrl.isEmpty) {
    throw Exception(LocaleKeys.errorsEmptyImageUrl.tr());
  }

  final uri = Uri.tryParse(imageUrl);

  if (uri == null || !uri.hasAbsolutePath) {
    return File(imageUrl);
  }

  final tempDir = await getTemporaryDirectory();
  final fileName = md5.convert(utf8.encode(imageUrl)).toString();
  final file = File('${tempDir.path}/$fileName.jpg');

  if (await file.exists()) {
    return file;
  }

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    await file.writeAsBytes(response.bodyBytes);
    return file;
  } else {
    throw Exception(LocaleKeys.errorsFailedToDownloadImage.tr(args: [response.statusCode.toString()]));
  }
}
