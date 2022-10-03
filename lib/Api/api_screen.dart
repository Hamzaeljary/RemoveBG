import 'dart:typed_data';
import 'package:http/http.dart' as http;

class Api {
  Future<Uint8List> removeBgApi(String imagePath) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://pixcut.wondershare.com/openapi/api/v1/matting/removebg"));
    request.files
        .add(await http.MultipartFile.fromPath("content", imagePath));
    request.headers.addAll({"appkey": "e4ba1d97c2230fbf37ef58a4e39c7316"}); //Put Your API key HERE
    final response = await request.send();
    if (response.statusCode == 200) {
      http.Response imgRes = await http.Response.fromStream(response);
      return imgRes.bodyBytes;
    } else {
      throw Exception("Error occurred with response ${response.statusCode}");
    }
  }
}
