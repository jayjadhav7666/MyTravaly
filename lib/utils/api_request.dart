import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_travely/utils/api_exception.dart';

class ApiRequest {
  Future<http.Response> sendPostRequest({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse(url);
    final http.Response response;
    response = await http.Client().post(
      uri,
      headers: headers,
      body: json.encode(body),
    );
    return response;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 403:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorizedException(response.body.toString());
      default:
        FetchDataException(
            'Error while Communication with status code${response.statusCode}');
    }
  }
}
