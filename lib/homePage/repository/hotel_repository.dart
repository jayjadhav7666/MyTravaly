import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_travely/constants/api_constants.dart';
import 'package:my_travely/homePage/model/hotels_model.dart';
import 'package:my_travely/utils/shared_preference_helper.dart';
import 'package:my_travely/utils/api_request.dart';
import 'package:my_travely/utils/common_api_result_model.dart';

class HotelRepository {
  Future<void> registerDevice() async {
    final url = Uri.parse(ApiConstants.baseUrl);

    final body = {
      "action": "deviceRegister",
      "deviceRegister": {
        "deviceModel": "RMX3521",
        "deviceFingerprint":
            "realme/RMX3521/RE54E2L1:13/RKQ1.211119.001/S.f1bb32-7f7fa_1:user/release-keys",
        "deviceBrand": "realme",
        "deviceId": "RE54E2L1",
        "deviceName": "RMX3521_11_C.10",
        "deviceManufacturer": "realme",
        "deviceProduct": "RMX3521",
        "deviceSerialNumber": "unknown"
      }
    };

    final response = await http.post(
      url,
      headers: {
        "authtoken": ApiConstants.authToken,
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final info = jsonDecode(response.body);
      final visitorToken = info['data']['visitorToken'];
      await SharedPreferenceHelper.instance.setVisitorToken(visitorToken);
      debugPrint("Device registered successfully ✅");
    } else {
      throw Exception("Device registration failed: ${response.statusCode}");
    }
  }

  Future<ApiResult<List<Datum>>> fetchHotels(
      String city, String state, String country) async {
    await registerDevice();
    final String visitorToken =
        await SharedPreferenceHelper.instance.getVisitorToken();

    final headers = {
      'authtoken': ApiConstants.authToken,
      'visitortoken': visitorToken,
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "action": "popularStay",
      "popularStay": {
        "limit": 10, //maximum 10
        "entityType": "Any", //hotel, resort, Home Stay, Camp_sites/tent, Any
        "filter": {
          "searchType": "byCity", //byCity, byState, byCountry, byRandom,
          "searchTypeInfo": {
            "country": city,
            "state": state,
            "city": country,
          }
        },
        "currency": "INR"
      }
    };

    try {
      final response = await ApiRequest().sendPostRequest(
        url: ApiConstants.baseUrl,
        body: requestBody,
        headers: headers,
      );

      debugPrint("HotelRepository.fetchHotels() => ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonString = ApiRequest().returnResponse(response);
        final List results = jsonString['data'] ?? [];
        final hotels = results.map((e) => Datum.fromJson(e)).toList();
        log('$hotels');
        return ApiResult(data: hotels, statusCode: response.statusCode);
      } else if (response.statusCode == 400) {
        return ApiResult(
          errorMessage: "Bad request. Please check your input and try again.",
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401) {
        return ApiResult(
          errorMessage: "Unauthorized access. Please log in again.",
          statusCode: response.statusCode,
        );
      } else {
        return ApiResult(
          errorMessage: "Unexpected error: ${response.statusCode}",
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return ApiResult(
        errorMessage: "No internet connection. Please check your network.",
        statusCode: 0,
      );
    } on TimeoutException {
      return ApiResult(
        errorMessage: "Request timed out. Please try again later.",
        statusCode: 0,
      );
    } on FormatException {
      return ApiResult(
        errorMessage: "Invalid response format. Please contact support.",
        statusCode: 0,
      );
    } catch (e) {
      return ApiResult(
        errorMessage: "An unexpected error occurred: ${e.toString()}",
        statusCode: 0,
      );
    }
  }
}
