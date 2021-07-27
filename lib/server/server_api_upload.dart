import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class UploadAPI {
  static final UploadAPI _singleton = new UploadAPI._internal();
  factory UploadAPI() {
    return _singleton;
  }

  UploadAPI._internal();

  Future<dynamic> upload(String apiUrl, String fileKey, File file, String token,
      Map<String, String> fields, String type) async {
    var contentType;

    String name = basename(file.path);
    if (name.contains(".jpg") ||
        name.contains(".jpeg") ||
        name.contains(".png"))
      contentType =
          "image/${basename(file.path).replaceAll(basenameWithoutExtension(file.path), '').replaceAll('.', '').replaceAll("jpg", "jpeg")}";
    else
      contentType =
          "application/${basename(file.path).replaceAll(basenameWithoutExtension(file.path), '').replaceAll('.', '')}";

    // contentType = lookupMimeType(file.path);

    final files = <http.MultipartFile>[];
    if (await file.exists()) {
      final length = await file.length();
      if (contentType != null)
        files.add(new http.MultipartFile(fileKey, file.openRead(), length,
            contentType: MediaType.parse(contentType),
            filename: basename(file.path)));
      else
        files.add(new http.MultipartFile(fileKey, file.openRead(), length,
            filename: basename(file.path)));
    }

    final request = new http.MultipartRequest(type, Uri.parse(apiUrl))
      ..fields.addAll(fields)
      ..files.addAll(files)
      ..headers.addAll(
          {"Authorization": token, "content-type": "multipart/form-data"});

    // http.Response response =
    //     await http.Response.fromStream(await request.send());

    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient client = new IOClient(httpClient);

    try {
      return http.Response.fromStream(await client.send(request));
    } catch (e) {
      client.close();
      return e;
    }
  }
}
