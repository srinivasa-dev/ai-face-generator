import 'package:http/http.dart';

class FakeFaceService {

  String baseUrl = 'https://fakeface.rest/face/json';

  Future<Response> getFace({String? gender, required int minimumAge, required int maximumAge, bool? random = true}) async {
    final response = random!
        ? await get(Uri.parse('$baseUrl?minimum_age=$minimumAge&maximum_age=$maximumAge'),)
        : await get(Uri.parse('$baseUrl?gender=$gender&minimum_age=$minimumAge&maximum_age=$maximumAge'),);

    return response;
  }

}