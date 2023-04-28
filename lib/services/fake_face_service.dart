import 'package:http/http.dart';

class FakeFaceService {

  String baseUrl = 'https://100k-faces.glitch.me/random-image-url';

  Future<Response> getFace() async {
    final response = await get(
      Uri.parse(baseUrl),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "content-type": "application/json",
        'Accept': '*/*',
      },
    );

    return response;
  }

}